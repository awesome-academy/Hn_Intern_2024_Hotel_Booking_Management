require "rails_helper"

RSpec.describe BookingsController, type: :request do
  let!(:user) {FactoryBot.create(:user)}
  let!(:booking) {FactoryBot.create(:booking)}
  let!(:booking_params_to_create) {FactoryBot.attributes_for(:booking)}
  let!(:room_type) {FactoryBot.create(:room_type)}
  let!(:booking_params_to_new) {
    {
      room_type_id: 1,
      view_type: 1,
      amount: 2,
      num_guest: 3,
      price: 100000,
      check_in: Date.today + 1.day,
      check_out: Date.today + 2.days
    }
  }

  before {
    sign_in user
  }

  describe "GET #index" do
    it "render :index template" do
      get bookings_path
      expect(response).to render_template(:index)
    end

    it "assigns @bookings" do
      booking = FactoryBot.create(:booking, user: user)
      get bookings_path
      expect(assigns(:bookings)).to eq([booking])
    end
  end


  describe "POST #show" do

    context "booking found" do
      it "render parital detail" do
        post booking_path(id: booking.id), as: :turbo_stream
        expect(response).to render_template(partial: "_detail")
      end
    end

    context "booking not found" do
      before {
        allow(Booking).to receive(:find_by).and_return(nil)
        post booking_path(id: booking.id)
      }
      it "flash warning" do
        expect(flash[:warning]).to match(/not found/)
      end

      it "redirect to root path" do
        expect(response).to redirect_to(root_path)
      end
    end

  end

   describe "GET #new" do
    before {
      allow(RoomType).to receive(:find_by).and_return(room_type)
      get new_booking_path(booking_params_to_new)
    }
    it 'assigns a new booking as @booking' do
      expect(assigns(:booking)).to be_a_new(Booking)
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do

    context "with valid params" do
      it "create a new booking" do
        allow(controller).to receive(:save_booking).and_return(true)
        allow(RoomType).to receive(:find_by).and_return(room_type)
        post bookings_path(booking: booking_params_to_create.merge(room_type_id: room_type.id))
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "render :new" do
        allow(controller).to receive(:save_booking).and_return(false)
        allow(RoomType).to receive(:find_by).and_return(room_type)
        post bookings_path(booking: booking_params_to_create)
        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(Booking).to receive(:find_by).and_return(booking)
      allow(booking).to receive(:can_be_deleted?).and_return(true)
    end
    it "success" do
      allow(booking).to receive(:destroy).and_return(true)
      delete new_booking_path, :params => {id: booking.id}, :headers => {"HTTP_REFERER" => bookings_path}
      expect(flash[:success]).to match(/success/)
    end

    it "failed" do
      allow(booking).to receive(:destroy).and_return(false)
      delete new_booking_path, :params => {id: booking.id}, :headers => {"HTTP_REFERER" => bookings_path}
      expect(flash[:danger]).to match(/failed/)
    end
  end
end
