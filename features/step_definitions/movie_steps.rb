# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end
 
 # Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table| 
  movies_table.hashes.each do |movie|
    Movie.find_or_create_by(title: movie[:title], rating: movie[:rating], release_date: movie[:release_date])
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  #remove this statement after implementing the test step
  ratings = arg1.split ", "
  #uncheck all the boxes
  all('input[type=checkbox]').each do |checkbox|
    uncheck(checkbox[:id])
  end
  ratings.map! do |rating|
      rating = "ratings_" + rating
  end
  ratings.each do |rating|
      page.check(rating)
  end
  click_button "ratings_submit"
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    ratings = arg1.split ", "
    result=true
    all("tr").each do |tr|
        found = false
        ratings.each do |rating|
            if tr.has_content?(rating) && !found
                found = true
            end
        end
        if !found
            result = false
        end
    end  
  expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
    count = 0
    result = true
    all("tr").each do |tr|
        count+=1
    end
    if count != 11
        result = false
    end
    expect(result).to be_truthy
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end
 
 When /^I have sorted movies alphabetically$/ do\
  if page.has_link?('Movie Title') 
    page.click_link('Movie Title')
  end
 end
 
 Then(/^I should see "(.*?)" before "(.*?)"$/) do |movie1, movie2|
    result = true
    count = 0
    all("tr").each do |tr|
        if tr.has_content?(movie1)
            count = 1
            result = true
        elsif tr.has_content?(movie2) && count == 0
            result = false
        end
    end
    expect(result).to be_truthy
 end
  
 When /^I have sorted movies by release date/ do\
  if page.has_link?('Release Date') 
    page.click_link('Release Date')
  end
 end
 
 Then(/^I should see "(.*?)" date before "(.*?)" date$/) do |date1, date2|
    result = true
    count = 0
    all("tr").each do |tr|
        if tr.has_content?(date1)
            count = 1
            result = true
        elsif tr.has_content?(date2) && count == 0
            result = false
        end
    end
    expect(result).to be_truthy
 end
 
 
 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end






