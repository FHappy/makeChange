class Api::UsersController < ApplicationController
	def current
		@user = current_user
		@user_charities = @user.charities.uniq

		render json: { user: @user, charities: @user_charities }
	end
end