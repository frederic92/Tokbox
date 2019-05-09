class RemoveLastTimeFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :last_time, :string
  end
end
