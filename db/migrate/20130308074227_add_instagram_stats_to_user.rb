class AddInstagramStatsToUser < ActiveRecord::Migration
  def change
    add_column :users, :bio, :string
    add_column :users, :website, :string
    add_column :users, :profile_picture, :string
    add_column :users, :full_name, :string
    add_column :users, :instagram_id, :integer
  end
end
