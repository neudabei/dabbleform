require 'rails_helper'

describe SubmissionsController do
  describe "POST create" do
    context "website submitted from belongs to existing account" do
      context "website from existing account belongs to email submitted do" do
        context "existing account is verified" do
          before do
            Account.create(email: 'email@domain.com', website: 'domain.com', verified: true, token: "1a2b3c")
            @request.env["HTTP_REFERER"] = "http://www.domain.com"
            post :create, {email: 'john@email.com', name: 'John', message: 'Hey there, great website!', account_email: 'email@domain', format: 'com'}
          end

          it "adds submission to existing account" do
            expect(Submission.count).to eq(1)
          end

          it "sends email to account owner informing about new submission" do
            expect(ActionMailer::Base.deliveries.last.to).to eq(["email@domain.com"])
          end
        end
        
        context "existing account is not verified" do
          before do
            Account.create(email: 'email@domain.com', website: 'domain.com', verified: false, token: "1a2b3c")
            @request.env["HTTP_REFERER"] = "http://www.domain.com"
            post :create, {email: 'john@email.com', name: 'John', message: 'Hey there, great website!', account_email: 'email@domain', format: 'com'}
          end

          it "sends out email with verification link" do
            expect(ActionMailer::Base.deliveries.last.to).to eq(["email@domain.com"])
          end

          it "shows page informing about necessity to confirm account via link in email" do
            expect(response.body).to eq("Thanks for submitting! Please check your email email@domain.com and verify this dabbleform for your website.") 
          end
        end
      end

      context "website from existing account doesn't belong to email submitted to" do
        before do
          @account = Account.create(email: 'email@domain.com', website: 'domain.com', verified: true)
          @request.env["HTTP_REFERER"] = "http://www.domain.com"
          post :create, {email: 'john@email.com', name: 'John', message: 'Hey there, great website!', account_email: 'new_email@domain', format: 'com'}
        end

        it "adds email to account" do
          expect(@account.reload.email).to eq("new_email@domain.com")
        end

        it "sends out email with verification link to the new /email submitted to" do
          expect(ActionMailer::Base.deliveries.last.to).to eq(["new_email@domain.com"])
        end

        it "shows page informing about necessity to confirm account via link in email" do
          expect(response.body).to eq("Thanks for submitting! Please check your email new_email@domain.com and verify this dabbleform for your website and new email.") 
        end
      end
    end

    context "website submitted from does not belong to existing account" do
      before do
        @request.env["HTTP_REFERER"] = "http://www.new_domain.com"
        post :create, {email: 'john@email.com', name: 'John', message: 'Hey there, great website!', account_email: 'account1@domain', format: 'com'}
      end
      
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
