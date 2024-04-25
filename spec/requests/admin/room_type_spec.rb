require "rails_helper"

RSpec.describe Admin::RoomTypesController, type: :request do
  let!(:admin) {FactoryBot.create(:user, role: :admin)}
  let!(:room_type) {FactoryBot.create(:room_type)}

  before { sign_in admin }

  describe "GET #index" do
    it "render :index template" do
      get admin_room_types_path
      expect(response).to render_template(:index)
    end
  end

  describe "POST #active" do
    it "activated" do
      room_type = FactoryBot.create(:room_type, status: :inactive)
      post admin_active_room_type_path(id: room_type.id)
      expect{ room_type.reload }.to change {room_type.status}.to("active")
    end
  end

  describe "POST #inactive" do
    let(:room_type) { FactoryBot.create(:room_type, status: "active") }

    before do
      allow(RoomType).to receive_message_chain(:with_attached_images, :includes, :find_by).and_return(room_type)
    end

    it "when room_type can be inactive" do
      allow(room_type).to receive(:can_be_inactive?).and_return(true)
      post admin_inactive_room_type_path(id: room_type.id)
      room_type.reload
      expect(room_type.status).to eq("inactive")
    end

    it "when room_type cannot be inactive" do
      allow(room_type).to receive(:can_be_inactive?).and_return(false)
      post admin_inactive_room_type_path(id: room_type.id)
      room_type.reload
      expect(room_type.status).to eq("active")
    end
  end

  describe "DELETE #remove_image" do
    it "remove image" do
      image = instance_double(ActiveStorage::Attachment, id: 1)
      allow(ActiveStorage::Attachment).to receive(:find_by).and_return(image)
      allow(image).to receive(:purge_later)
      delete admin_remove_image_path(id: image.id)
      expect(response).to redirect_to(admin_room_types_path)
    end
  end

  describe "GET #show" do
    it "render :show template" do
      get admin_room_type_path(id: room_type.id)
      expect(response).to render_template(:show)
    end

    it "room type not found" do
      allow(RoomType).to receive_message_chain(:with_attached_images, :includes, :find_by).and_return(nil)
      get admin_room_type_path(id: room_type.id)
      expect(response).to redirect_to(admin_room_types_path)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "flash notice" do
        allow(RoomType).to receive(:find_by).and_return(room_type)
        facility_1 = FactoryBot.create(:facility)
        facility_2 = FactoryBot.create(:facility)
        patch admin_room_type_path(
          id: room_type.id,
          room_type: {
            facility_ids: [facility_1.id, facility_2.id],
            images: []
          }
        )
        expect(flash[:notice]).to eq(I18n.t("flash.update_success"))
      end
    end

    context "with invalid params" do
      it "flash alert" do
        allow(RoomType).to receive_message_chain(:with_attached_images, :includes, :find_by).and_return(room_type)
        allow(room_type).to receive(:update).and_return(false)
        patch admin_room_type_path(
          id: room_type.id,
          room_type: {
            facility_ids: [""],
            images: []
          }
        )
        expect(flash[:alert]).to eq(I18n.t("flash.update_failed"))
      end
    end
  end
end
