class AddCurrentQualificationAndNationalityToStaffs < ActiveRecord::Migration[7.0]
  def change
    add_reference :staffs, :current_qualification, type: :uuid
    add_column :staffs, :nationality, :string
  end
end
