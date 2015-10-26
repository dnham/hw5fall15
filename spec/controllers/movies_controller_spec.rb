require 'spec_helper'
require 'rails_helper'
 
describe MoviesController do
  describe 'searching TMDb' do
    it 'should call the model method that performs TMDb search' do
      @fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      fake_results = [double('movie1'), double('movie2')]
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
      #	look	for	controller	method	to	assign	@movies	
	  expect(assigns(:tmdb_movies)).to eq fake_results
    end
  end
end