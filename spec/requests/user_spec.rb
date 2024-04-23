require "rails_helper"

RSpec.describe Admin::UsersController, type: :request do
  let(:admin) {FactoryBot.create(:user, role: :admin)}
  let(:user) {FactoryBot.create(:user, role: :user)}
  before {
    sign_in admin
  }

  describe "GET #index" do
    it "renders the :index template" do
      get admin_users_path
      expect(response).to render_template :index
    end

    it "assigns @users" do
      get admin_users_path
      expect(assigns(:users)).not_to be_nil
    end
  end

  describe "POST #lock_user" do
    before do
      allow(User).to receive(:find_by).with(id: user.id.to_s).and_return(user)
    end

    context "when lock a user" do
      it "can lock" do
        expect(user).to receive(:lock_access!)
        post admin_lock_user_path(id: user.id )
      end

      it "notice success" do
        post admin_lock_user_path(id: user.id )
        expect(flash[:notice]).to match(/success/)
      end
    end
  end

  describe "POST #unlock_user" do
    before do
      allow(User).to receive(:find_by).with(id: user.id.to_s).and_return(user)
    end

    it "unlocks the user" do
      expect(user).to receive(:unlock_access!)
      post admin_unlock_user_path(id: user.id )
    end
  end

  describe "GET #show" do
    context "when user not found" do
      before {
        allow(User).to receive(:find_by).and_return(nil)
        get admin_user_path(id: "99999")
      }
      it "redirect to admin dashboard" do
        expect(response).to redirect_to(admin_dashboard_path)
      end

      it "flash alert user not found" do
        expect(flash[:alert]).to match(/not found/)
      end
    end

    context "when user found" do
      before {
        allow(User).to receive(:find_by).and_return(user)
      }
      it "render the :show template" do
        get admin_user_path(id: user.id)
        expect(response).to render_template :show
      end
    end
  end
end
