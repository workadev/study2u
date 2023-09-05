class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images, id: :uuid do |t|
      t.text :image_data
      t.string :imageable_type
      t.uuid :imageable_id
      t.timestamps
    end

    add_index :images, [:imageable_type, :imageable_id]
  end
end
