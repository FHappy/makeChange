class Api::CharitiesController < ApplicationController
	def index
		@charities = Charity.all

		render json: @charities
	end
end