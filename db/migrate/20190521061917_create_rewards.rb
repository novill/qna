class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.string :title
      t.belongs_to :question
      t.belongs_to :user

      t.timestamps
    end
  end
end
