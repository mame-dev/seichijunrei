class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  private

    def require_user
      unless current_user
        redirect_to root_path
      end
    end

    def current_user
      return nil if session[:access_token].blank?
      begin
        foursquare = Foursquare::Base.new(:access_token => session[:access_token])
        @current_user ||= foursquare.users.find('self')
      rescue Foursquare::InvalidAuth
        nil
      end
    end

    def foursquare
      unless current_user
        @foursquare ||= Foursquare::Base.new(:client_id => Settings.app_id, :client_secret => Settings.app_secret)
      else
        @foursquare ||= Foursquare::Base.new(:access_token => session[:access_token])
      end
    end
end
