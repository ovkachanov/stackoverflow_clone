class AddIndexToAnswer < ActiveRecord::Migration
  def change
    add_index :answers, :question_id
  end
end
