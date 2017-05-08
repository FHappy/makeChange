class Api::CharitiesController < ApplicationController
	def index
		@charities= Charity.all;
		render json: {charities: sort_by_goal(@charities), image: image}
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
		
		@org_charities = HTTParty.get("#{url}&searchTerm=#{query}")
		
		render json: {
			suggested: sort_by_goal(@suggested),
			charities: de_dupe(@org_charities["data"]),
			image: image
		}

	end

	def category_image
		category_url = {
			"Arts, Culture and Humanities": "http://culturextourism.com/wp-content/uploads/2014/06/Explore-Indigenous-Australian-Aboriginal-Art-Culture-Facts-400x210.jpg",
			"Educational Institutions and Related Activities": "http://www.topeducationdegrees.org/wp-content/uploads/2016/01/6357758756001800821152486765_State-Education-Generic-jpg.jpg",
			"Environmental Quality, Protection and Beautification": "https://static.pexels.com/photos/26559/pexels-photo-26559.jpg",
			"Animal-Related": "http://www.hillcountryalliance.org/wp-content/uploads/2014/06/WildlifeCover.jpg",
			"Health - General and Rehabilitative": "https://upload.wikimedia.org/wikipedia/commons/7/7a/Okayama_Red_Cross_Hospital.jpg",
			"Mental Health, Crisis Intervention": "https://www.qub.ac.uk/schools/media/Media,566209,en.jpg",
			"Diseases, Disorders, Medical Disciplines": "https://www.nimml.org/images/highlights/Research_Infectious_Disease_6.1.14_i.jpg",
			"Medical Research": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Crime, Legal-Related": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Employment, Job-Related": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Food, Agriculture and Nutrition": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Housing, Shelter": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Public Safety, Disaster Preparedness and Relief": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Recreation, Sports, Leisure, Athletics": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Youth Development": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Human Services - Multipurpose and Other": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"International, Foreign Affairs and National Security": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Civil Rights, Social Action, Advocacy": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Community Improvement, Capacity Building": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Philanthropy, Voluntarism and Grantmaking Foundations": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Science and Technology Research Institutes, Services": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Social Science Research Institutes, Services": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Public, Society Benefit - Multipurpose and Other": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Religion-Related, Spiritual Development": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Mutual/Membership Benefit Organizations, Other": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Not Provided": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"
		}.as_json
	end

	def search_category
		search_terms = {
			A: "Arts, Culture and Humanities",
			B: "Educational Institutions and Related Activities",
			C: "Environmental Quality, Protection and Beautification",
			D: "Animal-Related",
			E: "Health - https://www.qub.ac.uk/schools/media/Media,566209,en.jpg",
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

		@org_charities = HTTParty.get("#{url}&category=#{query}")
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

  		HTTParty.get("#{url}&city=#{query.upcase}")["data"].each do |charity|
  			@org_charities << charity
  		end
  		HTTParty.get("#{url}&zipCode=#{truncated_zip}")["data"].each do |charity|
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

		if @charity
			@charity["token_amount"] += token

			if @charity["token_amount"] == 10
				@charity["token_amount"] = 0
				@charity["is_active?"] = false
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
			@charity["time_started"] = Time.new()
		end

		@charity.save()
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

	def query
		params[:query]
	end

	def ein
		params[:ein]
	end

	def image
		category_url = {
			"Arts, Culture and Humanities": "http://culturextourism.com/wp-content/uploads/2014/06/Explore-Indigenous-Australian-Aboriginal-Art-Culture-Facts-400x210.jpg",
			"Educational Institutions and Related Activities": "http://www.topeducationdegrees.org/wp-content/uploads/2016/01/6357758756001800821152486765_State-Education-Generic-jpg.jpg",
			"Environmental Quality, Protection and Beautification": "https://static.pexels.com/photos/26559/pexels-photo-26559.jpg",
			"Animal-Related": "http://www.hillcountryalliance.org/wp-content/uploads/2014/06/WildlifeCover.jpg",
			"Health - General and Rehabilitative": "https://upload.wikimedia.org/wikipedia/commons/7/7a/Okayama_Red_Cross_Hospital.jpg",
			"Mental Health, Crisis Intervention": "https://www.qub.ac.uk/schools/media/Media,566209,en.jpg",
			"Diseases, Disorders, Medical Disciplines": "https://www.nimml.org/images/highlights/Research_Infectious_Disease_6.1.14_i.jpg",
			"Medical Research": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Crime, Legal-Related": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Employment, Job-Related": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Food, Agriculture and Nutrition": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Housing, Shelter": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Public Safety, Disaster Preparedness and Relief": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Recreation, Sports, Leisure, Athletics": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Youth Development": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Human Services - Multipurpose and Other": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"International, Foreign Affairs and National Security": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Civil Rights, Social Action, Advocacy": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Community Improvement, Capacity Building": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Philanthropy, Voluntarism and Grantmaking Foundations": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Science and Technology Research Institutes, Services": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Social Science Research Institutes, Services": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Public, Society Benefit - Multipurpose and Other": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Religion-Related, Spiritual Development": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Mutual/Membership Benefit Organizations, Other": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg",
			"Not Provided": "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"
		}.as_json
	end

	def sort_by_goal(charities)
		charities.sort_by {|x| [-x["token_amount"], -x["total_earned"]] }
	end
		
end