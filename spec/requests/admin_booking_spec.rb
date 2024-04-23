require "rails_helper"

RSpec.describe Admin::BookingsController, type: :request do
  let(:admin) {FactoryBot.create(:user, role: :admin)}
  let(:booking) {FactoryBot.create(:booking)}
  let(:room) {FactoryBot.create(:room)}
  before {sign_in admin}

  describe "GET #index" do
    it "render :index template" do
      get admin_bookings_path
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    context "when booking not found" do
      before {
        allow(Booking).to receive(:find_by).and_return(nil)
        get admin_booking_path(id: booking.id)
      }

      it "redirect to root path" do
        expect(response).to redirect_to(root_path)
      end

      it "flash alert" do
        expect(flash[:warning]).to match(/not found/)
      end
    end

    context "when booking found" do
      before {
        allow(Booking).to receive(:find_by).and_return(booking)
        get admin_booking_path(id: booking.id)
      }
      it "render :show template" do
        expect(response).to render_template(:show)
      end
    end

  end

  describe "PUT #update" do
    before do
        allow(Booking).to receive(:find_by).and_return(booking)
    end
    context "when booking update status to completed" do
      before {
        patch admin_booking_path(
          id: booking.id,
          status: :completed
        )
      }
      it "redirect admin bookings" do
        expect(response).to redirect_to(admin_bookings_path)
      end

      it "flash success" do
        expect(flash[:success]).to match(/successfully/)
      end
    end

    context "when booking update to confirmed" do
      before {
        patch admin_booking_path(
          id: booking.id,
          status: :confirmed,
          assigned_rooms: [""].union(Array.new(booking.amount) {Faker::Number.between(from: 1, to: 10)})
        )
      }

      context "when success" do
        before do
          allow(Room).to receive(:find_by).and_return(room)
          allow(room).to receive(:can_be_assigned?).and_return(true)
        end

        it "saved booking" do
          expect(booking).to receive(:status=).with(:confirmed)
          patch admin_booking_path(
            id: booking.id,
            status: :confirmed,
            assigned_rooms: [""].union(Array.new(booking.amount) {Faker::Number.between(from: 1, to: 10)})
          )
        end

        it "flash success" do
          allow(booking).to receive(:save!).and_return(true)
          patch admin_booking_path(
            id: booking.id,
            status: :confirmed,
            assigned_rooms: [""].union(Array.new(booking.amount) {Faker::Number.between(from: 1, to: 10)})
          )
          expect(flash[:success]).to match(/success/)
        end

        it "redirect to admin bookings" do
          allow(booking).to receive(:save!).and_return(true)
          patch admin_booking_path(
            id: booking.id,
            status: :confirmed,
            assigned_rooms: [""].union(Array.new(booking.amount) {Faker::Number.between(from: 1, to: 10)})
          )
          expect(response).to redirect_to(admin_bookings_path)
        end
      end

      context "when failed" do
        it "wrong assigns room count" do
          patch admin_booking_path(
            id: booking.id,
            status: :confirmed,
            assigned_rooms: [""].union(Array.new(booking.amount-1) {Faker::Number.between(from: 1, to: 10)})
          )
          expect(flash.now[:danger]).to match(/is not correct/)
        end
      end
    end

    context "when booking update to rejected with valid params" do
      before {
        patch admin_booking_path(
          id: booking.id,
          booking: {
            status: :rejected,
            reason: "xxxx"
          }
        )
      }
      it "flash success" do
        expect(flash[:success]).to match(/successfully/)
      end

      it "redirect to admin bookings" do
        expect(response).to redirect_to admin_bookings_path
      end

      it "send mail booking to user" do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end

    context "when booking update to rejected with invalid params" do
      before {
        patch admin_booking_path(
          id: booking.id,
          booking: {
            status: :rejected          }
        )
      }
      it "flash danger" do
        expect(flash[:danger]).to match(/failed/)
      end

      it "render :show" do
        expect(response).to render_template(:show)
      end

      it "status 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
