class SessionsController < ApplicationController

  def new
    return redirect_to lists_path if current_user
    @authorize_url = authorize_url(callback_session_url)
  end

  def callback
    code = params[:code]
    access_token = access_token(code, callback_session_url)
    session[:access_token] = access_token
    redirect_to lists_path
  end

  def access_token(code, redirect_uri)
      # http://developer.foursquare.com/docs/oauth.html
      client_id = Settings.app_id
      client_secret = Settings.app_secret

      # check params
      raise "you need to define a client id before" if client_id.blank?
      raise "you need to define a client secret before" if client_secret.blank?
      raise "no code provided" if code.blank?
      raise "no redirect_uri provided" if redirect_uri.blank?

      # params
      params = {}
      params["client_id"] = client_id
      params["client_secret"] = client_secret
      params["grant_type"] = "authorization_code"
      params["redirect_uri"] = redirect_uri
      params["code"] = code

      # url
      url = oauth2_url('access_token', params)

      # response
      # http://developer.foursquare.com/docs/oauth.html
      response = JSON.parse(Typhoeus::Request.get(url).body)
      response["access_token"]
    end

  def authorize_url(redirect_uri)
      # http://developer.foursquare.com/docs/oauth.html
      client_id = Settings.app_id
      client_secret = Settings.app_secret

      # check params
      raise "you need to define a client id before" if client_id.blank?
      raise "no callback url provided" if redirect_uri.blank?

      # params
      params = {}
      params["client_id"] = client_id
      params["response_type"] = "code"
      params["redirect_uri"] = redirect_uri

      # url
      oauth2_url('authenticate', params)
    end

    def oauth2_url(method_name, params)
      "https://foursquare.com/oauth2/#{method_name}?#{params.to_query}"
    end

end