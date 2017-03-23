class CreateFollowships < ActiveRecord::Migration[5.0]
  def change
    create_table :followships do |t|
      t.integer :follower_id
      t.integer :followee_id

      t.timestamps
    end
    add_index :followships, :follower_id
    add_index :followships, :followee_id
    add_index :followships, [:follower_id, :followee_id], unique: true
  end
end
