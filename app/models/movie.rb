class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_in_tmdb (string)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    matching_movies = Tmdb::Movie.find(string) 
    movieArr = []
    matching_movies.each do |movie|
      movieDetails = Tmdb::Movie.detail(movie.id)
      hash = {:tmdb_id => movie.id, :title => movieDetails["title"], :rating => "G", :release_date => movieDetails["release_date"]}
      movieArr.push(hash)
    end
    return movieArr
  end
  
  def self.create_from_tmdb(movie_id)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    movieDetails = Tmdb::Movie.detail(movie_id)
    movie = Movie.create!(:title => movieDetails["title"], :rating => "G", :description => movieDetails["overview"], :release_date => movieDetails["release_date"])
  end
end
