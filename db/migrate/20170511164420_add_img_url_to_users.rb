class AddImgUrlToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :img_url, :string, default: "http://i.imgur.com/y4MoBvi.jpg"
  end
end
