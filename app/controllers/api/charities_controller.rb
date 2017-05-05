class Api::CharitiesController < ApplicationController
	def index
		@charities_local = Charity.all
		@charities_third_party = HTTParty.get("http://data.orghunter.com/v1/charitysearch?user_key=fd8d0a7418b42223ada1b88c40dfa0a9&eligible=1").as_json["data"]

		render json: { local: @charities_local, third_party: @charities_third_party }
	end

	def show
		@charity = Charity.find_by ein: params[:ein]
		render json: @charity
	end
end