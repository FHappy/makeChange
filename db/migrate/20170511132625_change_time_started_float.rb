class ChangeTimeStartedFloat < ActiveRecord::Migration[5.0]
  def change
  	remove_column :charities, :time_started
  	add_column :charities, :time_started, :float
  end
end
