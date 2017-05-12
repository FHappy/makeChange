class AddLongitudeAndLatitudeToCharities < ActiveRecord::Migration[5.0]
  def change
  	add_column :charities, :longitude, :float
  	add_column :charities, :latitude, :float
  end
end
