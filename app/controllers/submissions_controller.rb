class SubmissionsController < ApplicationController
  def create
    @submission = Submission.new(params[:submission])
    # @request_domain = env["HTTP_REFERER"]
    # email from route of form submission /email@domain.com 
    # find account by email@domain.com
    # account website  == env["HTTP_REFERER"] ?

    if @submission.save
      render plain "Thanks for submitting!"
    else
      render plain "Something went wrong!"
    end
  end
  
  private

    def submission_params
      params.require(:submission).permit(:email, :website, :message)
    end
end