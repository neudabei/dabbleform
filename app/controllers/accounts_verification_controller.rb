class AccountsVerificationController < ApplicationController

  def create
    binding.pry
    # if params[:token] == @account.token
    # update column 'account.verified' to true
    # and render page "thanks for verifying your account. this website is now ready to accept submissions from your dabbleform"
    # else
    # render page 'your token has expired. try submitting again or get in touch with support via support@dabbleform.com'
    # end
  end

end