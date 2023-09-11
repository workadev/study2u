class CreateMajorInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :major_interests, id: :uuid do |t|
      t.references :major, :interest, type: :uuid
      t.timestamps
    end

    add_index :major_interests, [:major_id, :interest_id], unique: :true
  end
end
