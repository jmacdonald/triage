class AssociateSystemsWithUsers < ActiveRecord::Migration
  def change
    add_column :systems, :user_id, :integer
  end
end
