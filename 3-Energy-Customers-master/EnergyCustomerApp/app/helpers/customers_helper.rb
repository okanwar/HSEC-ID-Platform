require 'net/http'

module CustomersHelper
    
    def get_request

        google_url = "https://www.google.com/get/sunroof#a="
        google_end_url = "&b=" + "#{@customer.electrical_utility_bill}"+ "&f=buy&np=12&p=1"
        google_street_number = @customer.street_number
        google_space = "%20"
        if @customer.street_name.include? " "
            street_name_array = @customer.street_name.split(' ')
            google_street_name_1 = street_name_array[0]
            google_street_name_2 = street_name_array[1]
            current_url = google_url + google_street_number + google_space + google_street_name_1 + google_space + google_street_name_2 + google_space
        else
            google_street_name_1 = @customer.street_name
            current_url = google_url + google_street_number + google_space + google_street_name_1 + google_space
        end
        
        if @customer.city.include? " "
            city_name_array = @customer.city.split(' ')
            google_city_1 = city_name_array[0]
            google_city_2 = city_name_array[1]
            current_url += google_city_1 + google_space + google_city_2 + google_space
        else
            google_city_1 = @customer.city
            current_url += google_city_1 + google_space
        end
        google_state = @customer.state + google_space
        google_zip = @customer.zip_code
        url = URI.parse(current_url + google_state + google_zip + google_end_url)
        request = Net::HTTP.get(url)
        response = Net::HTTP.get_response(url)

        sunlight_array = response.body.scan(/\d,?\d,?\d* \bhours of usable sunlight per year\b/)
        hrs_array = sunlight_array[0].scan(/\d,?\d,?\d*/)
        @customer.sunlight_hours = hrs_array[0]
        update(@customer)
        roofspace_array = response.body.scan(/\d,?\d,?\d* \bsq feet available for solar panels\b/)
        sqft_array = roofspace_array[0].scan(/\d,?\d,?\d*/)
        @customer.roof_space = sqft_array[0]

        savings_array = response.body.scan(/\d,?\d,?\d* \bsavings\b/)
        payback_array = savings_array[0].scan(/\d,?\d,?\d*/)
        @customer.savings = payback_array[0]
        # @customer.save!
    end

    def generate_composite_score
        get_request
        # data comes from U.S. Energy Information Administration (2012) or Google Project Sunroof   
        max_thermal = 3000 # natural gas consumption/month, therms
        min_thermal = 500 # natural gas consumption/month, therms
        max_electrical = 212.0 # MWh/month
        min_electrical = 20.0 # MWh/month
        electrical_unit_conversion = 0.001 
        max_sunlight_hrs = 2500.0 # available sunlight hours/year
        min_sunlight_hrs = 750.0 # available sunlight hrs/year
        max_roofspace = 400000 # sq ft of roofspace available for solar panels
        min_roofspace = 750.0 # sq ft of roofspace available for solar panels 
        max_twenty_yr_savings = 120000 # in dollars
        min_twenty_yr_savings = 0.0  # in dollars
        weight_thermal = 30.0
        weight_electrical = 30.0
        weight_sunlight_hrs = 20.0 
        weight_roofspace = 15.0
        weight_twenty_yr_savings = 5.0
        score_array = Array.new
        
        # sunlight hours score
        if @customer.sunlight_hours.to_f < min_sunlight_hrs
            sunlight_hrs_score = 0
            score_array.push(sunlight_hrs_score)

        elsif @customer.sunlight_hours.to_f > max_sunlight_hrs
            sunlight_hrs_score = 20
            score_array.push(sunlight_hrs_score)
        else
            sunlight_hrs_score = @customer.sunlight_hours.to_f/max_sunlight_hrs * weight_sunlight_hrs
            score_array.push(sunlight_hrs_score)
        end 
        
        # roofspace score
        if @customer.roof_space.to_f < min_roofspace
            roofspace_score = 0
            score_array.push(roofspace_score)

        elsif @customer.roof_space.to_f > max_roofspace
            roofspace_score = 15
            score_array.push(electric_score)
        else
            roofspace_score = @customer.roof_space.to_f/max_roofspace * weight_roofspace
            score_array.push(roofspace_score)
        end
        
        # twenty year savings score
        if @customer.savings.to_f < min_twenty_yr_savings
            twenty_yr_savings_score = 0
            score_array.push(twenty_yr_savings_score)

        elsif @customer.savings.to_f > max_twenty_yr_savings
            twenty_yr_savings_score = 5
            score_array.push(twenty_yr_savings_score)
        else
            twenty_yr_savings_score = @customer.savings.to_f/max_twenty_yr_savings * weight_twenty_yr_savings
            score_array.push(twenty_yr_savings_score)
        end

        # electric energy consumption
        electric_mwh = @customer.electrical_energy_consumption.to_f * electrical_unit_conversion
        if electric_mwh < min_electrical
            electric_score = 0
            score_array.push(electric_score)

        elsif electric_mwh > max_electrical
            electric_score = 30
            score_array.push(electric_score)
        else
            electric_score = electric_mwh/max_electrical * weight_electrical
            score_array.push(electric_score)
        end
        # thermal energy consumption
        if @customer.thermal_energy_consumption.to_f < min_thermal
            thermal_score = 0
            score_array.push(thermal_score)
        elsif @customer.thermal_energy_consumption.to_f > max_thermal
            thermal_score = 30
            score_array.push(thermal_score)
        else
            thermal_score = @customer.thermal_energy_consumption.to_f/max_thermal * weight_thermal
            score_array.push(thermal_score)
        end

        composite_score = score_array.inject(0){|sum,x| sum + x }
        return composite_score
    end   
end
