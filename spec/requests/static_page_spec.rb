require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  describe "GET #home" do
    it "render home template" do
      get root_path
      expect(response).to render_template(:home)
    end
  end
end
