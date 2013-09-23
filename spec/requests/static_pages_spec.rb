require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Delve" }

  describe "Home page" do

    it "should have the content 'Delve'" do
      visit '/static_pages/home'
      expect(page).to have_content('Welcome to Delve')
    end

    it "should have the title 'Delve'" do
      visit '/static_pages/home'
      expect(page).to have_title(base_title)
    end

    it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end

  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('How to get help')
    end

    it "should have the title 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_title("#{base_title} | Help")
    end

  end

  describe "About page" do

    it "should have the content 'About Me'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Me')
    end

    it "should have the title 'About Me'" do
      visit '/static_pages/about'
      expect(page).to have_title("#{base_title} | About Me")
    end

  end

end
