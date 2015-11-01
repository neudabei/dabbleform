class SubmissionsController < ApplicationController
  def create
    submission = Submission.new(email: params[:email], account_id: 1)
    # @request_domain = env["HTTP_REFERER"]
    # email from route of form submission /email@domain.com 
    # find account by email@domain.com
    # account website  == env["HTTP_REFERER"] ?

    # env["HTTP_REFERER"].start_with?("http://robertsj.com/")
    # http://robertsj.com innerhalb der () ersetzen mit domain aus zu submission account_id gehöriger website

    binding.pry

    if submission.save
      render plain: "Thanks for submitting!"
      # redirect_to "submission domain"
    else
      render plain: "Something went wrong!"
    end
  end
  
  # private

  #   def submission_params
  #     params.require(:submission).permit(:email, :name, :message)
  #   end
end