require 'rails_helper'

RSpec.describe Listing, type: :model do
  let(:listing) { create(:listing) } # default instance

  context "when recently created" do
    let(:listing){ Listing.new }

    it "should be invalid" do
      expect(listing).to be_invalid
    end

    context "after validated, error message list" do
      let(:error_messages) do
        listing.valid?
        listing.errors.messages
      end

      it { expect(error_messages).to have_key(:listing_type) }
      it { expect(error_messages).to have_key(:zipcode) }
    end
  end

  describe "after_save :generate_sort_name " do
    it "should populate :sort_name after save" do
      listing = build(:listing)
      expect(listing.sort_name).to be_nil

      listing.save
      listing.reload
      expect(listing.sort_name).not_to be_nil
    end
  end

  describe "address methods" do
    let(:state){build(:state, name: 'District of Columbia', abbreviation: 'DC')}
    let(:city){build(:city, name: 'Washington', state: state)}
    let(:listing) { build(:listing, address_1: '1600 Pennsylvania Avenue NW', city: city, zipcode: '20500') }

    describe "after_validation :geocode" do
      it "should populate longitude and latitude attributes" do
        expect(listing).to receive(:geocode)
        listing.valid?
      end
    end

    describe "#address" do
      it { expect(listing.address).to eq('1600 Pennsylvania Avenue NW, Washington, DC 20500') }
    end
  end

  context "Alias methods" do
    let(:facility_name){ 'Facility name example' }
    let(:facility){ create(:listing, name: facility_name) }
    let(:person){ create(:listing, :person, first_name: 'Joe', last_name: 'Doe', middle_name: 'U', suffix: 'II', title: 'MD' ) }

    describe "#full_name" do
      context "when is facility" do
        it { expect(facility.full_name).to eq(facility_name) }
      end

      context "when is person" do
        it { expect(person.full_name).to eq('Joe U Doe, II') }
      end
    end

    describe "#sortable_name" do
      context "when is facility" do
        it { expect(facility.sortable_name).to eq(facility_name.upcase) }
      end

      context "when is person" do
        it { expect(person.sortable_name).to eq('DOE, JOE U') }
      end
    end

    describe "#meta_name" do
      context "when is facility" do
        it { expect(facility.meta_name).to eq(facility_name) }
      end

      context "when is person" do
        it { expect(person.meta_name).to eq('MD Joe U Doe, II') }
      end
    end
  end

  describe "#as_indexed_json" do

  end
end
