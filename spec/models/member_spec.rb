require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member){ create(:member) }

  context "when recently created" do
    let(:member){ Member.new }

    it "should be invalid" do
      expect(member).to be_invalid
    end

    context "after validated, error message list" do
      let(:error_messages) do
        member.valid?
        member.errors.messages
      end

      it { expect(error_messages).to have_key(:first_name) }
      it { expect(error_messages).to have_key(:last_name) }
      it { expect(error_messages).to have_key(:email) }
      it { expect(error_messages).to have_key(:password) }

    end
  end

  describe "after_save callback" do
    let(:member){ build(:member) }
    it "should invoke #send_notifications" do
      expect(member).to receive(:send_notifications)

      member.save
    end
  end

  describe "#send_notifications" do
    let(:mailer_result) { double(:mailer_result) }

    before :each do
      allow(mailer_result).to receive(:deliver).and_return(nil)
    end

    it "should send new_member delivery mail" do
      expect(AdminMailer).to receive(:new_member).with(member).and_return(mailer_result)
      expect(MemberMailer).to receive(:new_member).with(member).and_return(mailer_result)

      expect(mailer_result).to receive(:deliver).twice

      member.send_notifications
    end
  end

  describe "#full_name" do
    let(:member){ create(:member, first_name: 'Joe', last_name: 'Doe') }

    it "returns first + last names" do
      expect(member.full_name).to eq('Joe Doe')
    end
  end
end
