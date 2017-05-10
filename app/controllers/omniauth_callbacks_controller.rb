class OmniauthCallbacksController < ApplicationController
  skip_before_action :authenticate_user!

  def stripe_connect
    binding.pry
    @user = User.new(
      username: 'CraigAnderson',
      email: 'canderson@makemydonation.org',
      password: 'password'
    )
    if @user.update_attributes({
      provider: request.env["omniauth.auth"].provider,
      uid: request.env["omniauth.auth"].uid,
      access_code: request.env["omniauth.auth"].credentials.token,
      publishable_key: request.env["omniauth.auth"].info.stripe_publishable_key
    })
      # anything else you need to do in response..
      sign_in_and_redirect @user, 'root_path'
    else
      session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    render json: {
      'oops': "I'm sorry..."
    }
  end
  

end
