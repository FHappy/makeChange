class ChangeTimeStartedToDateTime < ActiveRecord::Migration[5.0]
  def change
    change_column :charities, :time_started, :datetime
  end
end
