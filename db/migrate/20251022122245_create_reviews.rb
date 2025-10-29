class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :rating,  null: false
      t.text    :content, null: false
      t.references :user,    null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
    add_index :reviews, [:listing_id, :user_id]
  end
end
