customers = [{:company_name => 'USD', :street_number => '5998', :street_name => 'Alcala Park', :city => 'San Diego',
    	   :zip_code => '92110', :electrical_utility_bill => '500', :electrical_energy_consumption => '700', :thermal_energy_consumption => '800',
    	   :composite_score => '70.0', :ranking => '', :sunlight_hours => '1,416', :roof_space => '1,900', :savings => '10000'},
      	  {:company_name => 'Central Park Tennis Club', :street_number => '5820', :street_name => '125th Ln NE', :city => 'Kirkland',
    	   :zip_code => '98033', :electrical_utility_bill => '500', :electrical_energy_consumption => '1000', :thermal_energy_consumption => '1200',
    	   :composite_score => '75.0', :ranking => '', :sunlight_hours => '1,261', :roof_space => '2,185', :savings => '8000'},
  	 ]

customers.each do |customer|
  Customer.create!(customer)
end
