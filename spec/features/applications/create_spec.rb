require 'rails_helper'

RSpec.describe 'application creation' do

  describe 'the application new' do
    it 'renders the new form' do
      visit "/applications/new"

      expect(page).to have_content('New Application')
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Address')
      expect(find('form')).to have_content('City')
      expect(find('form')).to have_content('State')
    end
  end

  describe 'the application create' do
    context 'given valid data' do
      it 'creates the application and redirects to the application show page' do
        visit "/applications/new"

        fill_in 'Name', with: 'Kelly'
        fill_in 'Address', with: '123 test st'
        fill_in 'City', with: 'Aurora'
        fill_in 'State', with: 'CO'
        fill_in 'Zip', with: '80016'
        click_button 'Save'
        application = Application.find_by(name: 'Kelly')
        expect(page).to have_current_path("/applications/#{application.id}")
        expect(page).to have_content('Kelly')
      end
    end

    context 'given invalid data' do
      it 're-renders the new form' do
        visit "/applications/new"
        fill_in "Name", with: "Kara"
        click_button 'Save'
        expect(page).to have_current_path("/applications/new")
        expect(page).to have_content("Error: Name can't be blank, Address can't be blank, City can't be blank, State can't be blank, Zip can't be blank, Description can't be blank")
      end
    end
  end
end
