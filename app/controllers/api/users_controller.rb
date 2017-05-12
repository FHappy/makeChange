class Api::UsersController < ApplicationController
	def current
		@user = current_user
		@user_charities = @user.charities.uniq

		render json: { 
			user: @user, 
			charities: @user_charities, 
			userHomeBackgroundImage: ActionController::Base.helpers.asset_path("background/userHands.png"), 
			image: image,
			logo: ActionController::Base.helpers.asset_path("logo.png")
		}
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
			# Housing icon missing
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
end