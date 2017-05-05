class Api::CharitiesController < ApplicationController
	def index
		@charities_local = Charity.all
		@charities_third_party = HTTParty.get("http://data.orghunter.com/v1/charitysearch?user_key=fd8d0a7418b42223ada1b88c40dfa0a9&eligible=1").as_json["data"]
		render json: {charities: de_dupe(@charities_third_party)}
	end

	def show
		@charity = Charity.find_by ein: params[:ein]
		render json: @charity
	end

	private
	def de_dupe(charities)
		@db_charities = Charity.all
		charities.map! do |org_charity|
			@db_charities.each do |db_charity|
				if db_charity["ein"] == org_charity["ein"]
					org_charity = db_charity
				end
			end
			org_charity
		end
		charities
	end
	
end