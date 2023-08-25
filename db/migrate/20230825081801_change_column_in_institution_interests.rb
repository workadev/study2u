class ChangeColumnInInstitutionInterests < ActiveRecord::Migration[7.0]
  def change
    remove_column :institution_interests, :interest_id
    remove_column :institution_interests, :institution_id
    add_reference :institution_interests, :interest, type: :uuid
    add_reference :institution_interests, :institution, type: :uuid
  end
end
