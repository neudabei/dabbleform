class SubmissionsController < ApplicationController
  before_filter :require_verification

  def create

    account_email_submitted_to = params[:account_email] + "." + params[:format]

    @account = Account.find_by(email: account_email_submitted_to) # email from domain not from form

    def account_verified?
      env["HTTP_REFERER"].start_with?(@account.website)
      # +  account_email_submitted_to belongs to this account
      # && account_email_submitted_to == account.email
    end

    # if account_verified? 
      # create new entry with corresponding account_id
      # send email to the account owner informing about new entry
    # else
      # send verification email to account_email_submitted_to
      # add new account 
    # end



    submission = Submission.new(email: params[:email], account_id: @account.id)

    if account_verified?
      if submission.save
        render plain: "Thanks for submitting!"
        # redirect_to "submission domain"
        # send email to the account owner informing about new entry
      else
        render plain: "Something went wrong!"
      end
    else
      render plain: "Account doesn't seem to be verified"
      # add new account:
        # - write domain created with get_host method to db as well as email submitted to
      # send verification email to account_email_submitted_to
    end
  end

end