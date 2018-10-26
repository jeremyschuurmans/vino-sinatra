require 'spec_helper'
require 'pry'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("VINO")
    end
  end

  describe "Signup Page" do
    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to vino index' do
      params = {
        :name => "Yukihiro Matzumoto",
        :username => "matz",
        :email => "matz@rubycentral.org",
        :password => "objectsobjectsobjects"
      }
      post '/signup', params
      expect(last_response.location).to include("/wines")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :name => "Yukihiro Matzumoto",
        :username => "",
        :email => "matz@rubycentral.org",
        :password => "objectsobjectsobjects"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :name => "Yukihiro Matzumoto",
        :username => "matz",
        :email => "",
        :password => "objectsobjectsobjects"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :name => "Yukihiro Matzumoto",
        :username => "matz",
        :email => "matz@rubycentral.org",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      user = User.create(:name => "Yukihiro Matzumoto", :username => "matz", :email => "matz@rubycentral.org", :password => "objectsobjectsobjects")
      params = {
        :name => "Yukihiro Matzumoto",
        :username => "matz",
        :email => "matz@rubycentral.org",
        :password => "objectsobjectsobjects"
      }
      post '/signup', params
      get '/signup'
      expect(last_response.location).to include('/wines')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the wines index after login' do
      user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
      params = {
        :username => "hpotter",
        :password => "quidditch"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome,")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
      params = {
        :username => "hpotter",
        :password => "quidditch"
      }
      post '/login', params
      get '/login'
      expect(last_response.location).to include("/wines")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
      params = {
        :username => "hpotter",
        :password => "quidditch"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /wines if user not logged in' do
      get '/wines'
      expect(last_response.location).to include("/login")
    end

    it 'does load /wines if user is logged in' do
      user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")

      visit '/login'

      fill_in(:username, :with => "hpotter")
      fill_in(:password, :with => "quidditch")
      click_button 'submit'
      expect(page.current_path).to eq('/wines')
    end
  end

  describe 'user show page' do
    it 'shows wines owned by a single user' do
      user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
      wine1 = Wine.create(:name => "Charles & Charles Rose",
                          :winery => "Charles & Charles",
                          :vintage => "2017",
                          :origin => "Columbia Valley, Washington",
                          :price => "$12",
                          :rating => 9,
                          :tasting_notes => "This wine is a pretty, pale-salmon color. Aromas of strawberry bubblegum, herb, tropical fruit and citrus peel lead to dry fruit flavors, full of papaya, guava and pink-grapefruit notes with a tart finish. It flat-out delivers.",
                          :other_notes => "Excellent on hot summer days.",
                          :user_id => user.id)
      wine2 = Wine.create(:name => "Charles & Charles Cabernet Blend",
                          :winery => "Charles & Charles",
                          :vintage => "2015",
                          :origin => "Columbia Valley, Washington",
                          :price => "$13",
                          :rating => 9,
                          :tasting_notes => "Bold, rich and textured but not over the top – it remains wonderfully restrained and focused. Aromas of black cherry, blackberry, and earthy, savory notes of tobacco and herbs, vanilla, and cocoa. A full mouthfeel with a long and supple finish. It's an intense dark blue / purple in color with tremendous purity, depth, and focus. Tannins are elegant, and refined.",
                          :other_notes => "Great with grilled meats",
                          :user_id => user.id)
      get "/users/#{user.slug}"
      expect(last_response.body).to include("Charles & Charles Rose")
      expect(last_response.body).to include("Charles & Charles Cabernet Blend")
    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the wines index if logged in' do
        user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
        wine1 = Wine.create(:name => "Charles & Charles Rose",
                            :winery => "Charles & Charles",
                            :vintage => "2017",
                            :origin => "Columbia Valley, Washington",
                            :price => "$12",
                            :rating => 9,
                            :tasting_notes => "This wine is a pretty, pale-salmon color. Aromas of strawberry bubblegum, herb, tropical fruit and citrus peel lead to dry fruit flavors, full of papaya, guava and pink-grapefruit notes with a tart finish. It flat-out delivers.",
                            :other_notes => "Excellent on hot summer days.",
                            :user_id => user.id)
        user2 = User.create(:name => "Ron Weasley", :username => "rweasley", :email => "ron@hogwarts.edu", :password => "scabbers789")
        wine2 = Wine.create(:name => "Charles & Charles Cabernet Blend",
                            :winery => "Charles & Charles",
                            :vintage => "2015",
                            :origin => "Columbia Valley, Washington",
                            :price => "$13",
                            :rating => 9,
                            :tasting_notes => "Bold, rich and textured but not over the top – it remains wonderfully restrained and focused. Aromas of black cherry, blackberry, and earthy, savory notes of tobacco and herbs, vanilla, and cocoa. A full mouthfeel with a long and supple finish. It's an intense dark blue / purple in color with tremendous purity, depth, and focus. Tannins are elegant, and refined.",
                            :other_notes => "Great with grilled meats",
                            :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "hpotter")
        fill_in(:password, :with => "quidditch")
        click_button 'submit'
        visit "/wines"
        expect(page.body).to include(wine1.origin)
        expect(page.body).to include(wine2.origin)
      end
    end

    context 'logged out' do
      it 'does not let a user view the wines index if not logged in' do
        get '/wines'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new wine form if logged in' do
        user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")

        visit '/login'

        fill_in(:username, :with => "hpotter")
        fill_in(:password, :with => "quidditch")
        click_button 'submit'
        visit '/wines/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a wine if they are logged in' do
        user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
        visit '/login'

        fill_in(:username, :with => "hpotter")
        fill_in(:password, :with => "quidditch")
        click_button 'submit'

        visit '/wines/new'

        fill_in(:name, :with => "Charles & Charles Rose")
        fill_in(:winery, :with => "Charles & Charles")
        fill_in(:vintage, :with => "2017")
        fill_in(:origin, :with => "Columbia Valley, Washington")
        fill_in(:price, :with => "$12")
        fill_in(:rating, :with => 9)
        fill_in(:tasting_notes, :with => "This wine is a pretty, pale-salmon color. Aromas of strawberry bubblegum, herb, tropical fruit and citrus peel lead to dry fruit flavors, full of papaya, guava and pink-grapefruit notes with a tart finish. It flat-out delivers.")
        fill_in(:other_notes, :with => "Excellent on hot summer days.")
        click_button 'submit'

        user = User.find_by(:username => "hpotter")
        wine = Wine.find_by(:name => "Charles & Charles Rose")
        expect(wine).to be_instance_of(Wine)
        expect(wine.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user journal wines from another user' do
        user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
        user2 = User.create(:name => "Ron Weasley", :username => "rweasley", :email => "ron@hogwarts.edu", :password => "scabbers789")

        visit '/login'

        fill_in(:username, :with => "hpotter")
        fill_in(:password, :with => "quidditch")
        click_button 'submit'

        visit '/wines/new'

        fill_in(:name, :with => "Charles & Charles Rose")
        fill_in(:winery, :with => "Charles & Charles")
        fill_in(:vintage, :with => "2017")
        fill_in(:origin, :with => "Columbia Valley, Washington")
        fill_in(:price, :with => "$12")
        fill_in(:rating, :with => 9)
        fill_in(:tasting_notes, :with => "This wine is a pretty, pale-salmon color. Aromas of strawberry bubblegum, herb, tropical fruit and citrus peel lead to dry fruit flavors, full of papaya, guava and pink-grapefruit notes with a tart finish. It flat-out delivers.")
        fill_in(:other_notes, :with => "Excellent on hot summer days.")
        click_button 'submit'

        user = User.find_by(:id => user.id)
        user2 = User.find_by(:id => user2.id)
        wine = Wine.find_by(:name => "Charles & Charles Rose")
        expect(wine).to be_instance_of(Wine)
        expect(wine.user_id).to eq(user.id)
        expect(wine.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a blank journal entry' do
        user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")

        visit '/login'

        fill_in(:username, :with => "hpotter")
        fill_in(:password, :with => "quidditch")
        click_button 'submit'

        visit '/wines/new'

        fill_in(:name, :with => "")
        fill_in(:winery, :with => "")
        fill_in(:vintage, :with => "")
        fill_in(:origin, :with => "")
        fill_in(:price, :with => "")
        fill_in(:rating, :with => "")
        fill_in(:tasting_notes, :with => "")
        fill_in(:other_notes, :with => "")
        click_button 'submit'

        expect(Wine.find_by(:name => "")).to eq(nil)
        expect(page.current_path).to eq("/wines/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new wine form if not logged in' do
        get '/wines/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single wine entry' do

        user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
        wine = Wine.create(:name => "Borsao Garnacha",
                           :winery => "Borsao",
                           :vintage => "2016",
                           :origin => "Spain",
                           :price => "$9",
                           :rating => 6,
                           :tasting_notes => "Both on the nose and palate, this Garnacha is mildly angular and pinching, with a sense of rawness brought on by hard tannins. Its foxy plum flavors are jumpy and nervy, finishing peppery and jagged.",
                           :other_notes => "Would pair well with dark chocolate")

        visit '/login'

        fill_in(:username, :with => "hpotter")
        fill_in(:password, :with => "quidditch")
        click_button 'submit'

        visit "/wines/#{wine.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("DELETE WINE")
        expect(page.body).to include(wine.tasting_notes)
        expect(page.body).to include("EDIT WINE")
      end
    end

    context 'logged out' do
      it 'does not let a user view a wine' do
        user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
        wine = Wine.create(:name => "Borsao Garnacha",
                           :winery => "Borsao",
                           :vintage => "2016",
                           :origin => "Spain",
                           :price => "$9",
                           :rating => 6,
                           :tasting_notes => "Both on the nose and palate, this Garnacha is mildly angular and pinching, with a sense of rawness brought on by hard tannins. Its foxy plum flavors are jumpy and nervy, finishing peppery and jagged.",
                           :other_notes => "Would pair well with dark chocolate",
                           :user_id => user.id)
        get "/wines/#{wine.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view wine edit form if they are logged in' do
        user = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
        wine = Wine.create(:name => "Borsao Garnacha",
                           :winery => "Borsao",
                           :vintage => "2016",
                           :origin => "Spain",
                           :price => "$9",
                           :rating => 6,
                           :tasting_notes => "Both on the nose and palate, this Garnacha is mildly angular and pinching, with a sense of rawness brought on by hard tannins. Its foxy plum flavors are jumpy and nervy, finishing peppery and jagged.",
                           :other_notes => "Would pair well with dark chocolate",
                           :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "hpotter")
        fill_in(:password, :with => "quidditch")
        click_button 'submit'
        visit '/wines/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(wine.tasting_notes)
      end

      it 'does not let a user edit a wine they did not create' do
        user1 = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
        wine1 = Wine.create(:name => "Borsao Garnacha",
                            :winery => "Borsao",
                            :vintage => "2016",
                            :origin => "Spain",
                            :price => "$9",
                            :rating => 6,
                            :tasting_notes => "Both on the nose and palate, this Garnacha is mildly angular and pinching, with a sense of rawness brought on by hard tannins. Its foxy plum flavors are jumpy and nervy, finishing peppery and jagged.",
                            :other_notes => "Would pair well with dark chocolate",
                            :user_id => user1.id)

        user2 = User.create(:name => "Ron Weasley", :username => "rweasley", :email => "ron@hogwarts.edu", :password => "scabbers789")
        wine2 = Wine.create(:name => "Charles & Charles Cabernet Blend",
                            :winery => "Charles & Charles",
                            :vintage => "2015",
                            :origin => "Columbia Valley, Washington",
                            :price => "$13",
                            :rating => 9,
                            :tasting_notes => "Bold, rich and textured but not over the top – it remains wonderfully restrained and focused. Aromas of black cherry, blackberry, and earthy, savory notes of tobacco and herbs, vanilla, and cocoa. A full mouthfeel with a long and supple finish. It's an intense dark blue / purple in color with tremendous purity, depth, and focus. Tannins are elegant, and refined.",
                            :other_notes => "Great with grilled meats",
                            :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "hpotter")
        fill_in(:password, :with => "quidditch")
        click_button 'submit'
        visit "/wines/#{wine2.id}/edit"
        expect(page.current_path).to include('/wines')
      end

      it 'lets a user edit their own wine if they are logged in' do
        user = User.create(:name => "Ron Weasley", :username => "rweasley", :email => "ron@hogwarts.edu", :password => "scabbers789")
        wine = Wine.create(:name => "Charles & Charles Cabernet Blend",
                           :winery => "Charles & Charles",
                           :vintage => "2015",
                           :origin => "Columbia Valley, Washington",
                           :price => "$13",
                           :rating => 9,
                           :tasting_notes => "Bold, rich and textured but not over the top – it remains wonderfully restrained and focused. Aromas of black cherry, blackberry, and earthy, savory notes of tobacco and herbs, vanilla, and cocoa. A full mouthfeel with a long and supple finish. It's an intense dark blue / purple in color with tremendous purity, depth, and focus. Tannins are elegant, and refined.",
                           :other_notes => "Great with grilled meats",
                           :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "rweasley")
        fill_in(:password, :with => "scabbers789")
        click_button 'submit'
        visit '/wines/1/edit'

        fill_in(:origin, :with => "Columbia Valley, WA, USA")

        click_button 'submit'
        expect(Wine.find_by(:origin => "Columbia Valley, WA, USA")).to be_instance_of(Wine)
        expect(Wine.find_by(:origin => "Columbia Valley, Washington")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text field with blank content' do
        user = User.create(:name => "Ron Weasley", :username => "rweasley", :email => "ron@hogwarts.edu", :password => "scabbers789")
        wine = Wine.create(:name => "Charles & Charles Cabernet Blend",
                           :winery => "Charles & Charles",
                           :vintage => "2015",
                           :origin => "Columbia Valley, Washington",
                           :price => "$13",
                           :rating => 9,
                           :tasting_notes => "Bold, rich and textured but not over the top – it remains wonderfully restrained and focused. Aromas of black cherry, blackberry, and earthy, savory notes of tobacco and herbs, vanilla, and cocoa. A full mouthfeel with a long and supple finish. It's an intense dark blue / purple in color with tremendous purity, depth, and focus. Tannins are elegant, and refined.",
                           :other_notes => "Great with grilled meats",
                           :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "rweasley")
        fill_in(:password, :with => "scabbers789")
        click_button 'submit'
        visit '/wines/1/edit'

        fill_in(:origin, :with => "")

        click_button 'submit'
        expect(Wine.find_by(:origin => "Columbia Valley, WA, USA")).to be(nil)
        expect(page.current_path).to eq("/wines/1/edit")
      end
    end

    context "logged out" do
      it 'does not load -- requests user to login' do
        get '/wines/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own wine if they are logged in' do
        user = User.create(:name => "Ron Weasley", :username => "rweasley", :email => "ron@hogwarts.edu", :password => "scabbers789")
        wine = Wine.create(:name => "Charles & Charles Cabernet Blend",
                           :winery => "Charles & Charles",
                           :vintage => "2015",
                           :origin => "Columbia Valley, Washington",
                           :price => "$13",
                           :rating => 9,
                           :tasting_notes => "Bold, rich and textured but not over the top – it remains wonderfully restrained and focused. Aromas of black cherry, blackberry, and earthy, savory notes of tobacco and herbs, vanilla, and cocoa. A full mouthfeel with a long and supple finish. It's an intense dark blue / purple in color with tremendous purity, depth, and focus. Tannins are elegant, and refined.",
                           :other_notes => "Great with grilled meats",
                           :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "rweasley")
        fill_in(:password, :with => "scabbers789")
        click_button 'submit'
        visit 'wines/1'
        click_button "DELETE WINE"
        expect(page.status_code).to eq(200)
        expect(Wine.find_by(:origin => "Columbia Valley, Washington")).to eq(nil)
      end

      it 'does not let a user delete a wine they did not create' do
        user1 = User.create(:name => "Harry Potter", :username => "hpotter", :email => "harry@hogwarts.edu", :password => "quidditch")
        wine1 = Wine.create(:name => "Borsao Garnacha",
                            :winery => "Borsao",
                            :vintage => "2016",
                            :origin => "Spain",
                            :price => "$9",
                            :rating => 6,
                            :tasting_notes => "Both on the nose and palate, this Garnacha is mildly angular and pinching, with a sense of rawness brought on by hard tannins. Its foxy plum flavors are jumpy and nervy, finishing peppery and jagged.",
                            :other_notes => "Would pair well with dark chocolate",
                            :user_id => user1.id)

        user2 = User.create(:name => "Ron Weasley", :username => "rweasley", :email => "ron@hogwarts.edu", :password => "scabbers789")
        wine2 = Wine.create(:name => "Charles & Charles Cabernet Blend",
                            :winery => "Charles & Charles",
                            :vintage => "2015",
                            :origin => "Columbia Valley, Washington",
                            :price => "$13",
                            :rating => 9,
                            :tasting_notes => "Bold, rich and textured but not over the top – it remains wonderfully restrained and focused. Aromas of black cherry, blackberry, and earthy, savory notes of tobacco and herbs, vanilla, and cocoa. A full mouthfeel with a long and supple finish. It's an intense dark blue / purple in color with tremendous purity, depth, and focus. Tannins are elegant, and refined.",
                            :other_notes => "Great with grilled meats",
                            :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "hpotter")
        fill_in(:password, :with => "quidditch")
        click_button 'submit'
        visit "wines/#{wine2.id}"
        click_button "DELETE WINE"
        expect(page.status_code).to eq(200)
        expect(Wine.find_by(:origin => "Columbia Valley, Washington")).to be_instance_of(Wine)
        expect(page.current_path).to include('/wines')
      end
    end

    context "logged out" do
      it 'does not load let user delete a wine if not logged in' do
        wine = Wine.create(:name => "Borsao Garnacha",
                            :winery => "Borsao",
                            :vintage => "2016",
                            :origin => "Spain",
                            :price => "$9",
                            :rating => 6,
                            :tasting_notes => "Both on the nose and palate, this Garnacha is mildly angular and pinching, with a sense of rawness brought on by hard tannins. Its foxy plum flavors are jumpy and nervy, finishing peppery and jagged.",
                            :other_notes => "Would pair well with dark chocolate",
                            :user_id => 1)
        visit '/wines/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end
end
