class SubmissionsController < ApplicationController
  #before_filter :require_verification

  def create

    if website_belongs_to_existing_account?
      if @existing_account.email == account_email_submitted_to
        if @existing_account.verified?
          @submission = Submission.new(email: params[:email], name: params[:name], message: params[:message], account_id: @existing_account.id)
            if @submission.save
              render plain: "Thanks for submitting!"
            else
              render plain: "Something went wrong!"
            end
          AppMailer.send_new_submission_email(@submission, @existing_account).deliver_now
        else
          render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this account."
          AppMailer.send_account_verification_email(@existing_account).deliver_now
        end
      else
        render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this account."
        @existing_account.update(email: account_email_submitted_to, verified: false, token: generate_token)
        @existing_account = Account.find_by(website: website_submitted_from) # reassign account to variable to include the new email address
        AppMailer.send_account_verification_email(@existing_account).deliver_now
      end
    else 
      new_account = Account.new(website: website_submitted_from, email: account_email_submitted_to, token: generate_token, verified: false)
      if new_account.save
        render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this dabbleform for your website."
        AppMailer.send_account_verification_email(new_account).deliver_now
      else
        render plain: "Something went wrong!"
      end
    end

  end

  private

  def website_belongs_to_existing_account?
    @existing_account = Account.find_by(website: website_submitted_from)
    !!@existing_account
  end

  def website_submitted_from
    get_host_without_www(request.env["HTTP_REFERER"])
  end

  def account_email_submitted_to
    params[:account_email] + "." + params[:format]
  end

  def generate_token
    SecureRandom.urlsafe_base64
  end

end