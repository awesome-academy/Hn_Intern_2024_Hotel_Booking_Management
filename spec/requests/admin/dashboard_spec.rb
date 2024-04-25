require "rails_helper"

RSpec.describe "Admin::Dashboards", type: :request do
  let!(:admin) {FactoryBot.create(:user, role: :admin)}
  before do
    sign_in admin
  end
  describe "GET /index" do
    it "render :index template" do
      get admin_dashboard_path
      expect(response).to render_template(:index)
    end
  end
end
