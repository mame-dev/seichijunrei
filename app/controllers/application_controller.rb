class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :system_user

  private

    def require_user
      unless current_user
        redirect_to root_path
      end
    end

    def current_user
      return nil if session[:access_token].blank?
      client = Foursquare2::Client.new(:oauth_token => session[:access_token], :api_version => Settings.api_version)
      begin
        @current_user ||= client.user('self')
      rescue Exception => e
        nil
      end
    end

    def system_user
      unless @system_user
        @system_user = Foursquare2::Client.new(:client_id => Settings.app_id, :client_secret => Settings.app_secret, :api_version => Settings.api_version)
      end
      @system_user
    end
end
