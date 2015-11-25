require 'rails_helper'

describe SubmissionsController do
  describe "POST create" do
    context "email submitted to belongs to existing account" do
      context "email submitted to belongs to website submitted from" do
        context "account associated with email submitted to is verified" do
          before do
            account = Account.create(email: 'account1@domain.com')
            Website.create(domain: 'domain.com', verified: true, token: "1a2b3c", account_id: account.id)
            @request.env["HTTP_REFERER"] = "http://www.domain.com"
            post :create, {email: 'john@email.com', name: 'John', message: 'Hey there, great website!', account_email: 'account1@domain', format: 'com'}
          end
          
          it "adds submission to new existing account" do
            expect(Submission.count).to eq(1)
          end

          it "sends out email to account owner informing about new submission" do
            expect(ActionMailer::Base.deliveries.last.to).to eq(["email@domain.com"])
          end

          it "shows standard thank you page for submitting" do
            expect(response.body).to eq("Thanks for submitting with dabbleform!") 
          end
        end

        context "account associated with email submitted to is not verified" do
          before do
            Account.create(email: 'account1@domain.com', domain: 'domain.com', verified: false, token: "1a2b3c")
            @request.env["HTTP_REFERER"] = "http://www.new_domain.com"
            post :create, {email: 'john@email.com', name: 'John', message: 'Hey there, great website!', account_email: 'account1@domain', format: 'com'}
          end

          it "sends out email with verification link" do
            expect(ActionMailer::Base.deliveries.last.to).to eq(["account1@domain.com"])
          end

          it "shows page informing about necessity to confirm this new website for the existing account" do
            expect(response.body).to eq("Thanks for submitting! Please check your email account1@domain.com and verify this dabbleform for your website.") 
          end
        end
      end

      context "email submitted to does not belong to website submitted from" do
        before do
          Account.create(email: 'account1@domain.com', domain: 'domain.com', verified: true, token: "1a2b3c")
          @request.env["HTTP_REFERER"] = "http://www.another_domain.com"
          post :create, {email: 'john@email.com', name: 'John', message: 'Hey there, great website!', account_email: 'account1@domain', format: 'com'}
        end

        it "adds website to websites associated with account" do
          expect(Account.first.websites).to include("another_domain.com")
        end

        it "adds 'no website referer' if website has no HTTP_REFERER" do
          @request.env["HTTP_REFERER"] = nil # does this work?
          expect(Account.first.website).to eq("no_referer")
        end

        it "sends out email with verification link" do
          expect(ActionMailer::Base.deliveries.last.to).to eq(["account1@domain.com"])
        end

        it "shows page informing about necessity to confirm this new website for the existing account" do
          expect(response.body).to eq("Thanks for submitting! Please check your email account1@domain.com and verify this dabbleform for your website.") 
        end
      end
    end

    context "email submitted to does not belong to existing account" do
      context "HTTP_REFERER is set" do
        before do
          @request.env["HTTP_REFERER"] = "http://www.new_domain.com"
          post :create, {email: 'john@email.com', name: 'John', message: 'Hey there, great website!', account_email: 'account1@domain', format: 'com'}
        end

        it "creates new account" do
          expect(Account.count).to eq(1)
        end

        it "adds website submitted from to list of sites of acccount" do
          expect(Account.first.website).to eq("new_domain.com")
        end

        it "sends out email with verification link" do
          expect(ActionMailer::Base.deliveries.last.to).to eq(["account1@domain.com"])
        end

        it "shows page informing about necessity to confirm account via link in email" do
          expect(response.body).to eq("Thanks for submitting! Please check your email account1@domain.com and verify this dabbleform for your website.") 
        end
      end

      context "HTTP_REFERER is not set" do
        before do
          post :create, {email: 'john@email.com', name: 'John', message: 'Hey there, great website!', account_email: 'account1@domain', format: 'com'}
        end

        it "creates new account" do
          expect(Account.count).to eq(1)
        end

        it "adds website submitted from to list of sites of acccount labeled 'no website referer'" do
          expect(Account.first.website).to eq("no_referer")
        end

        it "sends out email with verification link" do
          expect(ActionMailer::Base.deliveries.last.to).to eq(["account1@domain.com"])
        end

        it "shows page informing about necessity to confirm account via link in email" do
          expect(response.body).to eq("Thanks for submitting! Please check your email account1@domain.com and verify this dabbleform for your website.") 
        end
      end
    end
  end
end