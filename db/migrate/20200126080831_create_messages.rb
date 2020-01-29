class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :to_name
      t.string :to_email
      t.string :title
      t.string :contents
      t.integer :user_id
      t.integer :day_id

      t.timestamps
    end
  end
end
