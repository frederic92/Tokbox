class AddDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_time, :string
    add_column :users, :level, :string
    add_column :users, :description, :string
    add_column :users, :github_link, :string
    add_column :users, :twitter_link, :string
  end
end
