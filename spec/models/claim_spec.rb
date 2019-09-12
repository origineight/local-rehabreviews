require 'rails_helper'

RSpec.describe Claim, type: :model do
  let(:claim){ create(:claim) }

  context "when recently created" do
    let(:claim){ Claim.new }

    it "should be invalid" do
      expect(claim).to be_invalid
    end

    context "after validated, error message list" do
      let(:error_messages) do
        claim.valid?
        claim.errors.messages
      end

      it { expect(error_messages).to have_key(:name) }
      it { expect(error_messages).to have_key(:email) }
      it { expect(error_messages).to have_key(:phone) }

    end
  end

  describe "validations" do
    let(:member){ create(:member) }
    let(:listing){ create(:listing) }
    let!(:claim){ create(:claim, listing: listing, member: member) }
    let(:second_claim){ build(:claim, listing: listing, member: member) }

    it "should fail if there's more than one claim for listing per member" do
      expect(second_claim).to be_invalid
    end
  end

  describe "after_save callback" do
    let(:claim){ build(:claim) }
    it "should invoke #send_notifications" do
      expect(claim).to receive(:send_notifications)

      claim.save
    end
  end

  describe "#send_notifications" do
    let(:mailer_result) { double(:mailer_result) }

    before :each do
      allow(mailer_result).to receive(:deliver).and_return(nil)
    end

    context "when claim's listing is public" do
      let(:claim){ create(:claim, listing: create(:listing, :published)) }

      it "should send new_claim delivery mail" do
        expect(AdminMailer).to receive(:new_claim).with(claim).and_return(mailer_result)
        expect(mailer_result).to receive(:deliver)

        claim.send_notifications
      end
    end

    context "when claim's listing is not public" do

      it "should send new_listing delivery mail" do
        expect(AdminMailer).to receive(:new_listing).with(claim).and_return(mailer_result)
        expect(mailer_result).to receive(:deliver)

        claim.send_notifications
      end
    end
  end

end
