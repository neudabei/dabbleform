class SubmissionsController < ApplicationController
  #before_filter :require_verification

  def create
    binding.pry
    if email_submitted_to_belongs_to_existing_account?
      if @existing_account.email == account_email_submitted_to
        if @existing_account.verified?
          @submission = Submission.new(email: params[:email], name: params[:name], message: params[:message], account_id: @existing_account.id)
            if @submission.save
              render plain: "Thanks for submitting with dabbleform!"
            else
              render plain: "Something went wrong!"
            end
          AppMailer.send_new_submission_email(@submission, @existing_account).deliver_now
        else
          render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this dabbleform for your website."
          AppMailer.send_account_verification_email(@existing_account).deliver_now
        end
      else
        render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this dabbleform for your website and new email."
        AppMailer.send_account_verification_email(@existing_account).deliver_now
      end
    else 
      new_account = Account.new(email: account_email_submitted_to)
      new_website = Website.new(domain: website_submitted_from, account_id: new_account.id, verified: false, token: generate_token) # does the account stored in memory already have an id?
      if new_account.save
        if new_website.save
          render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this dabbleform for your website."
          AppMailer.send_account_verification_email(new_account).deliver_now
        else
          render plain: "Soemthing went wrong!"
        end
      else
        render plain: "Something went wrong!"
      end
    end

  end

  private

  def email_submitted_to_belongs_to_existing_account?
    @existing_account = Account.find_by(email: account_email_submitted_to)
    false unless @existing_account
  end

  def website_belongs_to_existing_account?
    @existing_account = Account.find_by(website: website_submitted_from)
    !!@existing_account
  end

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