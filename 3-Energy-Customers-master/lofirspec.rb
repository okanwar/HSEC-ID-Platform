require 'spec_helper'

#Once we get the exact files properly separated, these will likely be in separate spec files


describe customer_helpers do
  describe 'generate_composite_score'
      it 'returns potential savings, potential solar installation size, and CO2 reduction'
        #pass in the address and avg monthly electric bill from client
        allow(engine).to receive(:sunroof).and_return() #do I needs this?
        expect(engine.sunroof("5998 Alcala Dr, San Diego, CA, 92110", '127'))
      end
  end
  describe 'get_request'
      it 'makes a get request to Project Sunroof with customer info and returns sunlight, roofspace and savings'
      
      it 'calls composite with the output from sunroof'
        allow(engine).to receive(:composite).and_return()
        expect(engine.composite('10,000', '176', '1.3')).to eql()
      end
  end
end

 describe 'GET' index do
    describe 'view_ranking_list'
        it 'should render the index template' do
            get :index
            expect(response).to render_template('index')
        end
        it 'should rank the companies by composite score'
            page.should have_submit_button("View Ranking List")
            Customer.view_ranking_list
            expect(response).to redirect_to(rankings_path)
        end
    end
end

 describe 'GET new' do
    let!(:customer) { Customer.new }

    it 'should render the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    it 'creates a new customer' do
      expect {post :create, customer: FactoryGirl.attributes_for(:customer)
      }.to change { Customer.count }.by(1)
    end

    it 'redirects to the customer index page' do
      post :create, customer: FactoryGirl.attributes_for(:customer)
      expect(response).to redirect_to(ranking_list_path)
    end
  end

  describe 'GET #show' do
    let!(:customer) { FactoryGirl.create(:customer) }
    before(:each) do
      get :show, id: customer.id
    end

    it 'should find the customer' do
      expect(assigns(:customer)).to eql(customer)
    end

    it 'should render the show template' do
      expect(response).to render_template('show')
    end
end
