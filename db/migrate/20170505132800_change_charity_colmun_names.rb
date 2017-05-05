class ChangeCharityColmunNames < ActiveRecord::Migration[5.0]
  def change
  	rename_column :charities, :zip_code, :zipCode
  	rename_column :charities, :name, :charityName
  	rename_column :charities, :mission_statement, :missionStatement
  	add_column :charities, :website, :string
  	change_column :charities, :ein, :string
  end
end
