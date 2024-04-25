require "rails_helper"

RSpec.describe Admin::RoomsController, type: :request do
  let!(:admin) {FactoryBot.create(:user, role: :admin)}
  let!(:room) {FactoryBot.create(:room)}
  let!(:room_type) {FactoryBot.create(:room_type)}

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "render :index template" do
      get admin_rooms_path
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "render :new template" do
      get new_admin_room_path
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do

    it "with valid params" do
      room_params = {name: "0001", view_type: "pool", room_type_id: room_type.id}
      expect{
        post admin_rooms_path, params: {room: room_params}
      }.to change(Room, :count).by(1)
    end

    it "with invalid params" do
      room_params = {name: "", view_type: "pool", room_type_id: room_type.id}
      expect{
        post admin_rooms_path, params: {room: room_params}
      }.to change(Room, :count).by(0)
    end
  end

  describe "PUT #update" do
    it "with valid params" do
      room_params = {name: "0001", view_type: "pool", room_type_id: room_type.id}
      put admin_room_path(id: room.id, room: room_params)
      expect(flash[:notice]).to eq(I18n.t("flash.update_success"))
    end

    it "with invalid params" do
      room_params = {name: "", view_type: "pool", room_type_id: room_type.id}
      put admin_room_path(id: room.id, room: room_params)
      expect(flash[:alert]).to eq(I18n.t("flash.update_failed"))
    end
  end

  describe "POST #active_room" do
    it "flash notice activated" do
      allow(Room).to receive(:find_by).and_return(room)
      post active_room_admin_room_path(id: room.id)
      expect(flash[:notice]).to eq(I18n.t("flash.activated"))
    end
  end

  describe "POST #inactive_room" do
    before do
      allow(Room).to receive(:find_by).and_return(room)
    end

    context "room can be inactive" do
      it "flash notice inactivated" do
        allow(room).to receive(:can_be_inactive?).and_return(true)
        post inactive_room_admin_room_path(id: room.id)
        expect(flash[:notice]).to eq(I18n.t("flash.inactivated"))
      end
    end

    context "room can not be inactive" do
      it "flash notice inactivated" do
        allow(room).to receive(:can_be_inactive?).and_return(false)
        post inactive_room_admin_room_path(id: room.id)
        expect(flash[:alert]).to eq(I18n.t("flash.room_is_busy"))
      end
    end

  end
end
