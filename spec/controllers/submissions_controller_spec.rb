require 'rails_helper'

describe SubmissionsController do
  describe "POST create" do
    context "website submitted from belongs to existing account" do

    end

    context "website submitted from does not belong to existing account" do
      before do
        @request.env["HTTP_REFERER"] = "http://www.new_domain.com"
        post :create, {email: 'john@email.com', name: 'John', message: 'Hey there, great website!', account_email: 'account1@domain', format: 'com'}
      end

      after { ActionMailer::Base.deliveries.clear }
      
      it "creates new account" do  
        expect(Account.count).to eq(1)
      end

      it "sends out email to the /email submitted to" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["account1@domain.com"])
      end

      it "shows page informing about necessity to confirm account via link in email" do
        expect(response.body).to eq("Thanks for submitting! Please check your email account1@domain.com and verify this dabbleform for your website.") 
      end
    end
  end
end


# Notes:
# - clear email queue in between (here or via config file)