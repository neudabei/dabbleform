require 'rails_helper'

describe SubmissionsController do
  describe "POST create" do
    context "email submitted to belongs to existing account" do
      context "email submitted to belongs to website submitted from" do
        context "account associated with email submitted to is verified" do
          it "adds submission to new existing account"
          it "sends out email to account owner informing about new submission"
          it "shows standard thank you page for submitting"
        end
        context "account associated with email submitted to is not verified" do
          it "sends out email with verification link"
          it "shows page informing about necessity to confirm this new website for the existing account"
        end
      end
      context "email submitted to does not belong to website submitted from" do
        it "sends out email with verification link"
        it "shows page informing about necessity to confirm this new website for the existing account"
      end
    end

    context "email submitted to does not belong to existing account" do
      it "creates new account"
      it "adds website submitted from to list of sites of acccount"
      it "adds a 'no website specified' to list of site of account"
      it "sens out email with verification link"
      it "shows page informing about necessity to confirm account via link in email"
    end
  end
end