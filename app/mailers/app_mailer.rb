class AppMailer < ActionMailer::Base

  default from: "Dabbleform <info@dabbleform.com>"

  def send_new_account_verification_email(new_account)
    @new_account = new_account
    mail to: account.email, subject: "Verfiy your Dabbleform account"
  end
end