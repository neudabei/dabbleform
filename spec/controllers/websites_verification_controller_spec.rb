require 'rails_helper'

describe WebsitesVerificationController do
  describe "POST verify" do
    context "with valid token" do
      before do
        account = Account.create(email: 'email@domain.com')
        @website = Website.create(domain: 'domain.com', verified: false, token: "123456", account_id: account.id)
        get :verify, token: "123456"
      end

      it "sets the website verified field to true" do
        expect(@website.reload.verified).to eq(true)
      end

      it "shows page informing that verification is complete" do
        expect(response.body).to eq("Thanks for verifying your website. The website #{@website.domain} is now ready to accept submissions from your dabbleform.")
      end
    end

    context "with invalid token" do
      before do
        account = Account.create(email: 'email@domain.com')
        @website = Website.create(domain: 'domain.com', verified: false, token: "123456", account_id: account.id)
        get :verify, token: "123"
      end

      it "does not set the website verified field to 'true'" do
        expect(@website.reload.verified).to eq(false)
      end

      it "shows page informing that the token is invalid" do
        expect(response.body).to eq("Your token has expired. Get in touch with support via support@dabbleform.com if you have problems verifying your account.")
      end
    end
  end
end