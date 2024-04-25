require "rails_helper"

RSpec.describe RoomsController, type: :request do
  let!(:rooms) {FactoryBot.create_list(:room, 5)}

  describe "#index" do
    it "render :index template as html" do
      get rooms_path
      expect(response).to render_template(:index)
    end

    context "render :index template as turbo stream" do
      let(:params) {
        {
          check_in: "2024-10-10",
          check_out: "2024-10-15",
          amount: 1,
          num_guest: 1
        }
      }

      before do
        allow(controller).to receive(:filtered_rooms).and_return(rooms)
      end

      it "renders a turbo_stream response" do
        post rooms_path, params: params, as: :turbo_stream
        expect(response).to render_template(partial: "_list_rooms")
      end
    end
  end
end
