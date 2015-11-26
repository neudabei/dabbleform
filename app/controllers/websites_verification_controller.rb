class WebsitesVerificationController < ApplicationController

  def verify
    website = Website.find_by(token: params[:token])
    if website && website.token == params[:token]
      website.update(verified: true)
      render plain: "Thanks for verifying your website. The website #{website.domain} is now ready to accept submissions from your dabbleform." 
    else
      render plain: "Your token has expired. Get in touch with support via support@dabbleform.com if you have problems verifying your account." 
    end
  end

end