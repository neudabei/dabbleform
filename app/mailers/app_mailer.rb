class AppMailer < ActionMailer::Base

  default from: "Dabbleform <info@dabbleform.com>"

  def send_account_verification_email(account)
    @account = account
    mail to: account.email, subject: "Verfiy your Dabbleform account"
  end

  def send_new_submission_email(submission, account)
    @submission = submission
    @account = account
    mail to: account.email, subject: "You have a new message from #{account.website}", reply_to: submission.email
  end
end