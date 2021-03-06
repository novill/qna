class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :value, default: 0, null: false
      t.belongs_to :votable, polymorphic: true
      t.timestamps
    end
  end
end
