class Api::CharitiesController < ApplicationController
	def index
		@charities= Charity.all;
		render json: {charities: sort_by_goal(@charities)}
	end

	def show
		ein = params[:ein]
		@charity = Charity.find_by ein: ein
		if @charity
			render json: {charity: @charity, exists: true}
		else
			@charity = HTTParty.get("#{url}&ein=#{ein}").as_json["data"][0]
			render json: {charity: @charity, exists: false}
		end
	end

	def search
		query = params[:query].upcase
		@suggested = []
		Charity.all.each do |charity|
			regex_query = Regexp.new("#{query}")
			if regex_query =~ charity["charityName"]
				@suggested << charity
			end
		end
		
		@org_charities = HTTParty.get("#{url}&searchTerm=#{query}")
		
		render json: {
			suggested: @suggested,
			charities: @org_charities["data"]
		}

	end

	def donate
		ein = params[:ein]
		token = params[:token]
		@charity = Charity.find_by ein: ein
		if @charity
			@charity["token_amount"] += token
			@charity.save()
		else
			@charity = Charity.new()
			new_charity = HTTParty.get("#{url}&ein=#{ein}").as_json["data"][0]
			@charity["ein"] = new_charity["ein"]
			@charity["city"] = new_charity["city"]
			@charity["state"] = new_charity["state"]
			@charity["zipCode"] = new_charity["zipCode"]
			@charity["category"] = new_charity["category"]
			@charity["charityName"] = new_charity["charityName"]
			@charity["url"] = new_charity["url"]
			@charity["missionStatement"] = new_charity["missionStatement"]
			@charity["website"] = new_charity["website"]
			@charity["token_amount"] = token
			@charity["time_started"] = Time.new()
			@charity.save()
		end
		current_user["token_amount"] -= token
		current_user.save()
		Donation.create(charity_id: @charity.id, user_id: current_user.id, token_amount: token)
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
					org_charity["token_amount"] = 0
					org_charity["total_earned"] = 0
					org_charity
				end
			end
			org_charity
		end
		charities
	end

	def url
		url = "http://data.orghunter.com/v1/charitysearch?user_key=fd8d0a7418b42223ada1b88c40dfa0a9&eligible=1"
	end

	def sort_by_goal(charities)
		charities.sort_by {|x| [-x["token_amount"], -x["total_earned"]] }
	end
		
end