class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def require_verification
    # if not verified send out email to the address submitted to /email
  end

  def submission_id
    Account.find_by(email: params[:email]).id
  end

  # method from: http://stackoverflow.com/questions/6674230/how-would-you-parse-a-url-in-ruby-to-get-the-main-domain
  # Only parses twice if url doesn't start with a scheme
  def get_host_without_www(url)
    require 'uri'
    uri = URI.parse(url)
    uri = URI.parse("http://#{url}") if uri.scheme.nil?
    host = uri.host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end
end
