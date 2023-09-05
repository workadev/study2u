class CreateStaffInstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :staff_institutions, id: :uuid do |t|
      t.references :staff, type: :uuid
      t.references :institution, type: :uuid
      t.timestamps
    end
  end
end
