require 'net/http'

class CustomersController < ApplicationController
    include CustomersHelper
    
    def index
        @customers = Customer.all.order(:composite_score).reverse_order
        rank = 1
        @customers.each do |customer|
           customer.ranking = rank
           rank = rank + 1
           customer.save!
        end
    end
    
    def show # look up movie by unique ID 
        #id = session[:id]
        #@customer = Customer.find(params[:id]) #Customer.find_by(company_name: "Amazon")
        # id = Customer.find_by(params[:company_name]).select(:id)
        if params.has_key?(:id)
            @customer = Customer.find(params[:id])
        else
            @customer = Customer.last
        end
        # @customer = Customer.find_by(params[:electrical_utility_bill])

    end

    def new 
        @customer = Customer.new
        #@customer.id = params[:id]
    end
    
    def edit
       @customer = Customer.find(params[:id]) 
    end
    
    def create
       if Customer.exists?(company_name: params[:company_name])
           redirect_to edit_customers_path(@customer)
       else
           @customer = Customer.create!(customer_params) #initializing rails model with respective attributes
       end
                
       #@customer = Customer.new(customer_params)
       if @customer.save
          #composite_array = generate_composite_score
          @customer.composite_score = generate_composite_score
          @customer.save!
          #redirect_to customers_path(@customer.id)
          redirect_to customers_path(@customer)
          flash[:notice] = "#{@customer.company_name} Successfully Saved!"
       else
         render 'new'
       end
    end
    
    def update 
        @customer = Customer.find(params[:id])
        
        if @customer.update(customer_params)
            redirect_to @customer
        else
            render 'edit_customers_path'
        end
    end
    
#    def destroy
#      @customer = Customer.find_by(company_name: params[:company_name])
#       @customer.destroy
#        
#       redirect_to customers_path
#    end

    def customer_params
       params.require(:customer).permit(
         :company_name, :street_number, :street_name, :city, :state, :zip_code, :electrical_utility_bill, :electrical_energy_consumption, 
         :thermal_energy_consumption, :composite_score, :ranking)
       end
    end
