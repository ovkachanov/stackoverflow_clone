class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :rating

      t.timestamps null: false
    end
    add_reference :votes, :votable, polymorphic: true, index: true
  end
end
