class CreateInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :interests, id: :uuid do |t|
      t.string :name
      t.text :icon_data
      t.string :icon_color
      t.timestamps
    end
  end
end
