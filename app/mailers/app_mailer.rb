class AppMailer < ActionMailer::Base

  default from: "Dabbleform <info@dabbleform.com>"

  def send_account_verification_email(account, website)
    @account = account
    @website = website
    mail to: account.email, subject: "Verfiy your Dabbleform account"
  end

  def send_new_submission_email(submission, account, website_belonging_to_account)
    @submission = submission
    @account = account
    @website_belonging_to_account = website_belonging_to_account
    mail to: account.email, subject: "You have a new message from #{website_belonging_to_account}", reply_to: submission.email
  end
end