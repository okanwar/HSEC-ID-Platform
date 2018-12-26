#require 'test_helper'
require "spec_helper"
require "rails_helper"

#class CustomersControllerTest < ActionDispatch::IntegrationTest
describe CustomersController, :type => :controller do #the spec for CustomersController
    describe 'GET index' do
        it 'should render the new template' do
            get :index
            expect(response).to render_template('index')
            expect(Foo.find(1)).to eq foo
            expect(Customer.find_by(ranking: 'Central Park Tennis Club')).to eq '1'
        end
    end
    
    describe 'GET new' do
        let!(:customer) { Customer.new }
        it 'should render the new template' do
            get :new
            expect(response).to render_template('new')
        end
    end
     
    describe 'GET #show' do
        it 'should find the customer' do
          get :show, id: 1 
          expect(assigns(:customer)).to eql(Customer.last)
          expect(response).to render_template('show')        
        end
    end 
end
 
