class Api::UsersController < ApplicationController
	def current
		@user = current_user

		render json: @user
	end
end