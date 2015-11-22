class AccountsVerificationController < ApplicationController

  def create
    # if params[:token] == @account.token
    # update column 'account.verified' to true
    # and render page "thanks for verifying your account. this website is now ready to accept submissions from your dabbleform"
    # else
    # render page 'your token has expired. try submitting again or get in touch with support via support@dabbleform.com'
    # end

    account = Account.find_by(token: params[:token])
    if account && account.token == params[:token]
      account.update(verified: true)
      render plain: "Thanks for verifying your account. The website #{account.website} is now ready to accept submissions from your dabbleform" 
    else
      render plain: "Your token has expired. Try submitting again or get in touch with support via support@dabbleform.com" 
    end
  end

end