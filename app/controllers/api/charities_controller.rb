class Api::CharitiesController < ApplicationController
	def index
		@charities= Charity.all;
		render json: {charities: sort_by_goal(@charities), image: image, backgroundImageOne: ActionController::Base.helpers.asset_path("background/colorHanzzz.jpg"), backgroundImageTwo: ActionController::Base.helpers.asset_path("background/colorHandsRotated.jpg")}
	end

	def show
		@charity = Charity.find_by ein: ein
		if @charity
			render json: { charity: @charity, comments: @charity.comments, image: image }
		else
			@charity = HTTParty.get("#{url}&ein=#{ein}").as_json["data"][0]
			render json: { charity: @charity, image: image }
		end
	end

	def search
		@suggested = []
		Charity.all.each do |charity|
			regex_query = Regexp.new("#{query.upcase}")
			if regex_query =~ charity["charityName"]
				@suggested << charity
			end
		end
		
		@org_charities = HTTParty.get("#{url}&searchTerm=#{query}&start=#{page}")
		
		render json: {
			suggested: sort_by_goal(@suggested),
			charities: de_dupe(@org_charities["data"]),
			image: image
		}

	end

	def search_category
		search_terms = {
			A: "Arts, Culture and Humanities",
			B: "Educational Institutions and Related Activities",
			C: "Environmental Quality, Protection and Beautification",
			D: "Animal-Related",
			E: "Health - General and Rehabilitative",
			F: "Mental Health, Crisis Intervention",
			G: "Diseases, Disorders, Medical Disciplines",
			H: "Medical Research",
			I: "Crime, Legal-Related",
			J: "Employment, Job-Related",
			K: "Food, Agriculture and Nutrition",
			L: "Housing, Shelter",
			M: "Public Safety, Disaster Preparedness and Relief",
			N: "Recreation, Sports, Leisure, Athletics",
			O: "Youth Development",
			P: "Human Services - Multipurpose and Other",
			Q: "International, Foreign Affairs and National Security",
			R: "Civil Rights, Social Action, Advocacy",
			S: "Community Improvement, Capacity Building",
			T: "Philanthropy, Voluntarism and Grantmaking Foundations",
			U: "Science and Technology Research Institutes, Services",
			V: "Social Science Research Institutes, Services",
			W: "Public, Society Benefit - Multipurpose and Other",
			X: "Religion-Related, Spiritual Development",
			Y: "Mutual/Membership Benefit Organizations, Other"
		}.as_json
		search_term = search_terms[query]
		if page
			@org_charities = HTTParty.get("#{url}&category=#{query}&start=#{page}")
		else
			@org_charities = HTTParty.get("#{url}&category=#{query}")
		end
		@suggested = []

		Charity.all.each do |charity|
			if search_term == charity["category"]
				@suggested << charity
			end
		end

		render json: { suggested: sort_by_goal(@suggested), charities: de_dupe(@org_charities["data"]), image: image  }
	end

  	def search_location
  		@org_charities = []
  		@suggested = []

  		truncated_zip = query[0, 5]

  		HTTParty.get("#{url}&city=#{query.upcase}&start=#{page}")["data"].each do |charity|
  			@org_charities << charity
  		end
  		HTTParty.get("#{url}&zipCode=#{truncated_zip}&start=#{page}")["data"].each do |charity|
  			@org_charities << charity
  		end
  		@org_charities.uniq!

  		Charity.all.each do |charity|
			regex_query = Regexp.new("#{query.upcase}")
			if regex_query =~ charity["city"]
				@suggested << charity
			end
		end
		Charity.all.each do |charity|
			if truncated_zip == charity["zipCode"]
				@suggested << charity
			end
		end
		@suggested.uniq!

		render json: { suggested: sort_by_goal(@suggested), charities: de_dupe(@org_charities) }
  	end
  
	def donate
		token = params[:token]
		@charity = Charity.find_by ein: ein

		if @charity && @charity["time_started"]
			@charity["token_amount"] += token

			if @charity["token_amount"] == 10
        @charity["total_earned"] += 5
				@charity["token_amount"] = 0
				@charity["time_started"] = nil
        goal_completion(@charity)
			end

		elsif @charity
			@charity["time_started"] = (Time.new().to_f) * 1000
			@charity["token_amount"] += token

			if @charity["token_amount"] == 10
        @charity["total_earned"] += 5
				@charity["token_amount"] = 0
				@charity["time_started"] = nil
        goal_completion(@charity)
			end

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
			@charity["time_started"] = (Time.new().to_f) * 1000
			add_lat_long(@charity)
	      	if @charity["token_amount"] == 10
	        	@charity["total_earned"] += 5
				@charity["token_amount"] = 0
				@charity["time_started"] = nil
	        	goal_completion(@charity)
			end
		end

		@charity.save()
		current_user["token_amount"] -= token
		current_user.save()
		Donation.create(charity_id: @charity.id, user_id: current_user.id, token_amount: token)
		ActionCable.server.broadcast 'donations',
			ein: @charity.ein,
			user: current_user
		head :ok

	end

	def refund
		@charity = Charity.find_by ein: ein
		@donations = @charity.donations.select { |donation| donation["active?"] }
		@donations.each do |donation|
			amount = donation.token_amount
			user = donation.user
			user["token_amount"] += amount
			donation["active?"] = false
			user.save()
			donation.save()
		end
		@charity["token_amount"] = 0
		@charity["time_started"] = nil
		@charity.save()

		render json: {charity: @charity}
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

	def query
		params[:query]
	end

	def ein
		params[:ein]
	end

	def page
		(params[:page].to_i - 1) * 20 + 1
	end

	def image
		category_url = {
			"Arts, Culture and Humanities": ActionController::Base.helpers.asset_path("makeChangeIcons/art.png"),
			"Educational Institutions and Related Activities": ActionController::Base.helpers.asset_path("makeChangeIcons/educational_institutions.png"),
			"Environmental Quality, Protection and Beautification": ActionController::Base.helpers.asset_path("makeChangeIcons/environment.png"),
			"Animal-Related": ActionController::Base.helpers.asset_path("makeChangeIcons/animal-related.png"),
			"Health - General and Rehabilitative": ActionController::Base.helpers.asset_path("makeChangeIcons/health.png"),
			"Mental Health, Crisis Intervention": ActionController::Base.helpers.asset_path("makeChangeIcons/mentalHealth.png"),
			"Diseases, Disorders, Medical Disciplines": ActionController::Base.helpers.asset_path("makeChangeIcons/disease.png"),
			"Medical Research": ActionController::Base.helpers.asset_path("makeChangeIcons/medicalResearch.png"),
			"Crime, Legal-Related": ActionController::Base.helpers.asset_path("makeChangeIcons/crime_legal-related.png"),
			"Employment, Job-Related": ActionController::Base.helpers.asset_path("makeChangeIcons/employment.png"),
			"Food, Agriculture and Nutrition": ActionController::Base.helpers.asset_path("makeChangeIcons/nutrition.png"),
			"Housing, Shelter": ActionController::Base.helpers.asset_path("makeChangeIcons/housing.png"),
			"Public Safety, Disaster Preparedness and Relief": ActionController::Base.helpers.asset_path("makeChangeIcons/publicSafety.png"),
			"Recreation, Sports, Leisure, Athletics": ActionController::Base.helpers.asset_path("makeChangeIcons/recreation.png"),
			"Youth Development": ActionController::Base.helpers.asset_path("makeChangeIcons/youth.png"),
			"Human Services - Multipurpose and Other": ActionController::Base.helpers.asset_path("makeChangeIcons/humanServices.png"),
			"International, Foreign Affairs and National Security": ActionController::Base.helpers.asset_path("makeChangeIcons/internationAffairs.png"),
			"Civil Rights, Social Action, Advocacy": ActionController::Base.helpers.asset_path("makeChangeIcons/rights.png"),
			"Community Improvement, Capacity Building": ActionController::Base.helpers.asset_path("makeChangeIcons/community.png"),
			"Philanthropy, Voluntarism and Grantmaking Foundations": ActionController::Base.helpers.asset_path("makeChangeIcons/philanthropy.png"),
			"Science and Technology Research Institutes, Services": ActionController::Base.helpers.asset_path("makeChangeIcons/techResearch.png"),
			"Social Science Research Institutes, Services": ActionController::Base.helpers.asset_path("makeChangeIcons/socialScience.png"),
			"Public, Society Benefit - Multipurpose and Other": ActionController::Base.helpers.asset_path("makeChangeIcons/publicBenefit.png"),
			"Religion-Related, Spiritual Development": ActionController::Base.helpers.asset_path("makeChangeIcons/religion.png"),
			"Mutual/Membership Benefit Organizations, Other": ActionController::Base.helpers.asset_path("makeChangeIcons/mutualBenefit.png"),
			"Not Provided": ActionController::Base.helpers.asset_path("makeChangeIcons/question.png")
		}.as_json
	end

	def sort_by_goal(charities)
		charities.sort_by {|x| [-x["token_amount"], -x["total_earned"]] }
	end

	def goal_completion(charity)
		transfer = Stripe::Transfer.create({
			:amount => 545,
			:currency => "usd",
			:destination => ENV["makeMyDonation_uid"],
			:transfer_group => "{TO_CHARITIES}",
			:partnerId => ENV["stripe_connect_client_id"],
			:ein => charity["ein"],
			:charityName => charity["charityName"]
		})
	end

	def add_lat_long(charity)
		url = "http://data.orghunter.com/v1/charitygeolocation?user_key=fd8d0a7418b42223ada1b88c40dfa0a9"
		charity["latitude"] = HTTParty.post("#{url}&ein=#{charity['ein']}").as_json["data"]["latitude"]
		charity["longitude"] = HTTParty.post("#{url}&ein=#{charity['ein']}").as_json["data"]["longitude"]
	end	
		
end