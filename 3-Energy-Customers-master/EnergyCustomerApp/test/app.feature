Feature: Interact with front-end dashboard to input data and deliver results

	As Dr. Codd (or someone on his team)
	So that I can find out if a potential customer would be a good candidate or not
	I want to input a company's specifications

Background: 3 main options on front-end dashboard

    Given the following 3 options exist on the homepage
    
    --EnergyCustomerApp--
    (1) New Customer
    (2) Ranking List
    (3) Home'
    
Scenario: Input customer details
    When I choose option (1)
    Then I should see a new interface where I can input customer details
    And I fill in the fields
    And I press the submit button
    Then I should arrive at a summary page with delivery of my results
    And I should see a summary of my specifications
    
Scenario: View ranking list

    When I choose option (2)
    Then I should see a new page with a list of companies/residential addresses ranked by composite score
    And I should see an explanation of how this composite score is calculated
    
Scenario: Scenario: Home
    When I choose option (3)
    Then I should see the welcome page
    
    
    
    
    
    
    
	
