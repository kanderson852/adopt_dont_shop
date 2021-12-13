require "rails_helper"

describe 'application show page' do
  before do

    @shelter1 = Shelter.create!(foster_program: true, name:"Humane Society", city: "Fort Collins", rank: 2)
    @pet1 = @shelter1.pets.create!(adoptable: true, age: 1, breed:"Dachshund", name:"Rusko")
    @pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Beagle", name:"Rosie")
    @application1 = Application.create!(name:'Kelly', address: '123 test st', city: 'Boulder', state: 'CO', zip: '80016')
    # @pet_application = PetApplication.create!(pet_id: @pet1.id, application_id: @application1.id)
    visit "/applications/#{@application1.id}"
  end
  it ' I see name, address, description, status' do
    within "#application-#{@application1.id}" do
      expect(page).to have_content(@application1.name)
      expect(page).to have_content(@application1.address)
      expect(page).to have_content(@application1.city)
      expect(page).to have_content(@application1.zip)
      expect(page).to have_content(@application1.state)
      expect(page).to have_content(@application1.description)
      expect(page).to have_content(@application1.status)
    end
  end
  it 'Links to all pets' do
    fill_in 'Pet name', with: "#{@pet1.name}"
    click_button "Submit"
    click_button "Adopt this Pet"
    expect(page).to have_link("#{@pet1.name}", href: "/pets/#{@pet1.id}")
    click_link "#{@pet1.name}"
    expect(current_path).to eq("/pets/#{@pet1.id}")
  end

  it 'I can search for pets to add to this application' do
    expect(page).to have_content("Add a Pet to this Application")
    fill_in 'Pet name', with: "#{@pet1.name}"
    click_button "Submit"
    expect(current_path).to eq("/applications/#{@application1.id}")
    expect(page).to have_content("#{@pet1.name}")
    fill_in 'Pet name', with: "#{@pet2.name}"
    click_button "Submit"
    expect(current_path).to eq("/applications/#{@application1.id}")
    expect(page).to have_content("#{@pet2.name}")
  end

  it 'Add a Pet to an Application' do
    fill_in 'Pet name', with: "#{@pet2.name}"
    click_button "Submit"
    expect(page).to have_button("Adopt this Pet")
    click_button "Adopt this Pet"
    expect(current_path).to eq("/applications/#{@application1.id}")
    expect(page).to have_content("Pets on this Application: #{@pet2.name}")
  end

  it 'After I have added pets I see a field for why I would make a good home and a button to submit application' do
    expect(page).to_not have_button("Submit this Application")
    expect(page).to_not have_content("Why this applicant would make a good owner for these pet(s)")
    fill_in 'Pet name', with: "#{@pet2.name}"
    click_button "Submit"
    click_button "Adopt this Pet"
    expect(page).to have_button("Submit this Application")
    expect(page).to have_content("Why this applicant would make a good owner for these pet(s)")
    fill_in :description, with: "I love animals"
    click_button "Submit this Application"
    expect(current_path).to eq("/applications/#{@application1.id}")
    expect(page).to have_content("Status: Pending")
    expect(page).to_not have_content("Status: in progress")
    expect(page).to_not have_content("Add a Pet to this Application")
  end
end
