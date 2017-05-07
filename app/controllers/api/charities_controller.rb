class Api::CharitiesController < ApplicationController
	def index
		@charities= Charity.all;
		render json: {charities: sort_by_goal(@charities)}
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

	def search
		query = params[:query].upcase
		# query = "%#{query}%"
		# @db_charities = Charity.where("'charityName' ILIKE :query", query: query)
		# binding.pry
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
			charities: @org_charities
		}

	end

	def donate
		# binding.pry
		ein = params[:ein]
		token = params["token"]
		@charity = Charity.find_by ein: ein
		if @charity
			@charity["token_amount"] += token
			@charity.save()
		else
			new_charity = Charity.new()
			@charity = HTTParty.get("#{url}&ein=#{ein}").as_json["data"][0]
			new_charity["ein"] = @charity["ein"]
			new_charity["city"] = @charity["city"]
			new_charity["state"] = @charity["state"]
			new_charity["zipCode"] = @charity["zipCode"]
			new_charity["category"] = @charity["category"]
			new_charity["charityName"] = @charity["charityName"]
			new_charity["url"] = @charity["url"]
			new_charity["missionStatement"] = @charity["missionStatement"]
			new_charity["website"] = @charity["website"]
			new_charity["token_amount"] = token
			new_charity["time_started"] = Time.new()
			binding.pry
			new_charity.save()
		end
		current_user["token_amount"] -= token
		current_user.save()

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