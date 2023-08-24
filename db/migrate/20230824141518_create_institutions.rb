class CreateInstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :institutions, id: :uuid do |t|
      t.string :name, :type, :size, :area, :ownership, :short_desc, :description, :post_code, :address, :reputation, :city, :state, :country, :status, :latitude, :longitude
      t.text :logo_data
      t.timestamps
    end
  end
end
