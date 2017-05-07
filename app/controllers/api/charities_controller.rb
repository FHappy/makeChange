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
			suggested: sort_by_goal(@suggested),
			charities: de_dupe(@org_charities["data"])
		}

	end

	def search_category
		query = params[:query]
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

		@org_charities = HTTParty.get("#{url}&category=#{query}")
		@suggested = []

		Charity.all.each do |charity|
			if search_term == charity["category"]
				@suggested << charity
			end
		end

		render json: { suggested: sort_by_goal(@suggested), charities: de_dupe(@org_charities["data"]) }
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