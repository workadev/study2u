class ChangeStateToBeForeignKey < ActiveRecord::Migration[7.0]
  def change
    remove_column :institutions, :state
    add_reference :institutions, :state, type: :uuid
  end
end
