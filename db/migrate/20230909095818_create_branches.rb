class CreateBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :branches, id: :uuid do |t|
      t.references :major, type: :uuid
      t.string :name
      t.timestamps
    end
  end
end
