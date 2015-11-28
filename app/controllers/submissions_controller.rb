class SubmissionsController < ApplicationController
  #before_filter :require_verification

  def create
    if account_email_submitted_to_belongs_to_existing_account?
      if account_email_submitted_to_belongs_to_website_submitted_from?

        if website_belonging_to_account.verified? # DECIDE: should email also have to be verified? (existing_account.verified?) -> Not really, because no scenario in which website verified, but not email
          @submission = Submission.new(email: params[:email], name: params[:name], message: params[:message], website_id: website_belonging_to_account.id) # Not correct, because same website domain might exist multiple times belonging to different accounts. Write test for this case, because current test suite wouldn't catch this problem. 
            if @submission.save
              render plain: "Thanks for submitting with dabbleform!"
            else
              render plain: "Something went wrong!"
            end
          AppMailer.send_new_submission_email(@submission, existing_account, website_belonging_to_account).deliver_now
        else
          render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this dabbleform for your website."
          AppMailer.send_account_verification_email(existing_account, website_belonging_to_account).deliver_now
        end
      else
        new_website = Website.new(domain: website_submitted_from, account_id: existing_account.id, verified: false, token: generate_token)
        if new_website.save
          render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this dabbleform for your website."
          AppMailer.send_account_verification_email(existing_account, new_website).deliver_now
        else
          render plain: "Soemthing went wrong!"
        end
      end
    else 
      new_account = Account.new(email: account_email_submitted_to)
      if new_account.save
        new_website = Website.new(domain: website_submitted_from, account_id: new_account.id, verified: false, token: generate_token) # does the account stored in memory already have an id?
        if new_website.save
          render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this dabbleform for your website."
          AppMailer.send_account_verification_email(new_account, new_website).deliver_now
        else
          render plain: "Soemthing went wrong!"
        end
      else
        render plain: "Something went wrong!"
      end
    end
  end

  private

  def account_email_submitted_to_belongs_to_website_submitted_from?
    if website_belonging_to_account
    website_belonging_to_account.account_id == existing_account.id
    else
      false
    end
  end

  def website_belonging_to_account
    Website.find_by(domain: website_submitted_from, account_id: existing_account.id)
  end

  def existing_account
    Account.find_by(email: account_email_submitted_to)
  end

  def account_email_submitted_to_belongs_to_existing_account?
    !!existing_account
    # existing.account.email == account_email_submitted_to
  end

  # def website_belongs_to_existing_account?
  #   @existing_account = Account.find_by(website: website_submitted_from)
  #   !!@existing_account
  # end

  def website_submitted_from
    if request.env["HTTP_REFERER"].nil? 
      'no_http_referer'
    else
      get_host_without_www(request.env["HTTP_REFERER"])
    end
  end

  def account_email_submitted_to
    params[:account_email] + "." + params[:format]
  end

  def generate_token
    SecureRandom.urlsafe_base64
  end

end