class SubmissionsController < ApplicationController
  #before_filter :require_verification

  def create

    if website_belongs_to_existing_account?
      if @existing_account.verified?
        @submission = Submission.new(email: params[:email], name: params[:name], message: params[:message], account_id: @existing_account.id)
          if @submission.save
            render plain: "Thanks for submitting!"
          else
            render plain: "Something went wrong!"
          end
        send_new_submission_email(@submission, @existing_account)
      else
        render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this account."
        AppMailer.send_account_verification_email(@existing_account).deliver_now
      end
    else 
      new_account = Account.new(website: website_submitted_from, email: account_email_submitted_to, verified: false)
      if new_account.save
        render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this account."
        AppMailer.send_account_verification_email(new_account).deliver_now
      else
        render plain: "Something went wrong!"
      end
    end

  end

  private

  def website_belongs_to_existing_account?
    @existing_account = Account.find_by(website: website_submitted_from)
    account.exists?
  end

  def website_submitted_from
    get_host_without_www(env["HTTP_REFERER"])
  end

  def account_email_submitted_to
    params[:account_email] + "." + params[:format]
  end





  # def create_old

  #   account_email_submitted_to = params[:account_email] + "." + params[:format]

  #   @account = Account.find_by(email: account_email_submitted_to) # email from domain not from form

  #   def account_verified?(account)
  #     if account
  #       get_host_without_www(env["HTTP_REFERER"]).start_with?(account.website)
  #     else
  #       false
  #     end
  #     # +  account_email_submitted_to belongs to this account
  #     # && account_email_submitted_to == account.email
  #   end

  #   # if account_verified? 
  #     # create new entry with corresponding account_id
  #     # send email to the account owner informing about new entry
  #   # else
  #     # send verification email to account_email_submitted_to
  #     # add new account 
  #   # end

  #   binding.pry

  #   if account_verified?(@account)
  #     submission = Submission.new(email: params[:email], account_id: @account.id)
  #     if submission.save
  #       render plain: "Thanks for submitting!"
  #       # redirect_to "submission domain"
  #       # send email to the account owner informing about new entry
  #     else
  #       render plain: "Something went wrong!"
  #     end
  #   else
  #     #render plain: "Account doesn't seem to be verified"
  #     # add new account:
  #       # - write domain created with get_host method to db as well as email submitted to
  #     # send verification email to account_email_submitted_to

      
  #     new_account = Account.new(email: account_email_submitted_to, website: get_host_without_www(env["HTTP_REFERER"]), verified: false)
  #     if new_account.save
  #       render plain: "Thanks for submitting! Please check your email #{account_email_submitted_to} and verify this account."
  #       AppMailer.send_new_account_verification_email(new_account).deliver_now
  #     else
  #       render plain: "Something went wrong!"
  #     end
  #   end
  # end

end