require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:rating) { create(:rating) }

  context "when recently created" do
    let(:rating){ Rating.new }

    it "should be invalid" do
      expect(rating).to be_invalid
    end

    context "after validated, error message list" do
      let(:error_messages) do
        rating.valid?
        rating.errors.messages
      end

      it { expect(error_messages).to have_key(:initials) }
      it { expect(error_messages).to have_key(:score) }

    end
  end

  describe "after_save callback" do
    let(:rating){ build(:rating) }
    it "should invoke #send_notifications" do
      expect(rating).to receive(:send_notifications)

      rating.save
    end
  end

  describe "#send_notifications" do
    it "should deliver mail through AdminMailer" do
      mailer_result = double(:mailer_result)

      expect(AdminMailer).to receive(:new_rating).with(rating).and_return(mailer_result)
      expect(mailer_result).to receive(:deliver)

      rating.send_notifications
    end
  end
end
