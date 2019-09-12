require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "self.boostable" do
    it do
      expect(Category).to receive(:where).with({boostable: true})

      Category.boostable
    end
  end

  describe "self.directory_sorted" do
    it "is pending"
  end
end
