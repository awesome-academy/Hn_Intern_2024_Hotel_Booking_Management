require "rails_helper"

RSpec.describe Facility, type: :model do
  describe "scope" do
    it ".asc_name" do
      facility_list = FactoryBot.create_list(:facility, 10)
      sorted = facility_list.sort_by {|f| f.name}
      expect(Facility.asc_name).to eq(sorted)
    end
  end
end
