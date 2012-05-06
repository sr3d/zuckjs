class OauthController < ApplicationController
  
  def start
    session['oauth'] = Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::SECRET, oauth_callback_url)
    redirect_to session['oauth'].url_for_oauth_code(:permissions => "email,publish_actions")
  end
  
  
  def redirect
    session[:access_token] = Koala::Facebook::OAuth.new(oauth_redirect_url).get_access_token(params[:code]) if params[:code]

    redirect_to session[:access_token] ? success_path : failure_path
  end
  def callback
    session['access_token'] = session['oauth'].get_access_token(params[:code])
    graph = Koala::Facebook::API.new(session['access_token'])
    profile = graph.get_object("me")
    
    fb_user = FbUser.find_by_fb_id(profile['id'])

    # If the facebook user not exist then add one.
    if fb_user.nil?
      fb_user            = FbUser.new
      fb_user.fb_id      = profile['id']
      fb_user.name       = profile['name']
      fb_user.first_name = profile['first_name']
      fb_user.last_name  = profile['last_name']
      fb_user.link       = profile['link']
      fb_user.hometown   = profile['hometown']['name'] if profile['hometown']
      fb_user.gender     = profile['gender']
      fb_user.email      = profile['email']
    end

    # If there are no user match with fb user then add one as well.
    user = User.find_by_email(fb_user.email)
    if user.nil?
      password = Devise.friendly_token.downcase
      user = User.new(:username => fb_user.email, 
                      :email => fb_user.email, 
                      :password => password, 
                      :password_confirmation => password)
      user.name = "#{fb_user.first_name} #{fb_user.last_name}"
      user.confirmed_at = Time.now
      user.save
    end

    fb_user.user_id = user.id
    fb_user.save

    sign_in(user)
    redirect_to root_url
  end
  
end