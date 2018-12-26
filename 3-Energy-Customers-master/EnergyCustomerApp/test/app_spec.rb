require 'spec_helper'

#Once we get the exact files properly separated, these will likely be in separate spec files

describe Frontend do
    describe 'view_ranking_list'
        it 'displays the full list of ranked companies'
            page.should have_submit_button("View Ranking List")
            Customer.view_ranking_list
            expect(response).to redirect_to(rankings_path)
        end
    end
end

describe Engine do
  describe 'sunroof'
      it 'returns potential savings, potential solar installation size, and CO2 reduction'
        #pass in the address and avg monthly electric bill from client
        allow(engine).to receive(:sunroof).and_return() #do I needs this?
        expect(engine.sunroof("5998 Alcala Dr, San Diego, CA, 92110", '127'))
      end
  end
  describe 'composite'
      it 'calls composite with the output from sunroof'
        allow(engine).to receive(:composite).and_return()
        expect(engine.composite('10,000', '176', '1.3')).to eql()
      end
  end
  describe 'display_ranking'
      it 'translates the companys composite score and overall ranking to the front end'
        allow(engine).to receive(:display_ranking).and_return()
        expect(engine.display_ranking('69', '1'))
      end
  end
end

describe Composite do
  describe 'generate_score' do
      it 'accurately scores company based on composite algorithm' do
        #generate_score takes in potential savings ($), potential solar installation size (sq. feet)
        #and CO2 reduction (metric tons). Determine value after creating algorithm
        expect(composite.generate_score('10,000', '176', '1.3')).to eql('69')
      end
  end
  describe 'rank_company'
      it 'correctly ranks the company relative to the rest of the database' do
         expect(composite.rank_company('69')).to eql('5')
      end
  end
end


    
    
    
    
	
