class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos, id: :uuid do |t|
      t.text :video_data
      t.string :videoable_type
      t.uuid :videoable_id
      t.timestamps
    end

    add_index :videos, [:videoable_type, :videoable_id]
  end
end
