class Api::CharitiesController < ApplicationController
	def index
		@charities_local = Charity.all

		render json: @charities_local
	end

	def show
		@charity = Charity.find_by ein: params[:ein]
		render json: @charity
	end
end