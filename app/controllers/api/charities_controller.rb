class Api::CharitiesController < ApplicationController
	def index
		page = params[:page].to_i
		start = (page - 1) * 20 + 1
		@charities= HTTParty.get("#{url}&start=#{start}").as_json["data"]
		render json: {charities: de_dupe(@charities)}
	end

	def show
		ein = params[:ein]
		@charity = Charity.find_by ein: ein
		if @charity
			render json: @charity
		else
			@charity = HTTParty.get("#{url}&ein=#{ein}").as_json["data"][0]
			render json: @charity
		end
	end

	private
	def de_dupe(charities)
		@db_charities = Charity.all
		charities.map! do |org_charity|
			@db_charities.each do |db_charity|
				if db_charity["ein"] == org_charity["ein"]
					org_charity = db_charity
					break
				else
					# org_charity["token_amount"] = 0
					org_charity
				end
			end
			org_charity
		end
		# charities.sort! {|x,y| y["token_amount"] <=> x["token_amount"]}
		charities
	end

	def url
		url = "http://data.orghunter.com/v1/charitysearch?user_key=fd8d0a7418b42223ada1b88c40dfa0a9&eligible=1"
	end
	
end