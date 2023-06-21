class AddUsersToLabel < ActiveRecord::Migration[6.0]
  def change
    add_reference :labels, :user, foreign_key: true, null: false
  end
end
