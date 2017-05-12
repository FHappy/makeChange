class Charity < ApplicationRecord
	has_many :donations
	has_many :users, through: :donations
	has_many :comments

end


