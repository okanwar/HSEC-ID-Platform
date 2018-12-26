class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :company_name
      t.string :street_number
      t.string :street_name
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :electrical_utility_bill
      t.string :electrical_energy_consumption
      t.string :thermal_energy_consumption
      t.string :composite_score
      t.string :ranking
      t.string :sunlight_hours
      t.string :roof_space
      t.string :savings

      t.timestamps
    end
  end
end
