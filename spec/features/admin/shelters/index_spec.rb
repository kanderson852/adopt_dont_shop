require 'rails_helper'

RSpec.describe 'the shelters index' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @pet1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
  end

  it 'lists all the shelter names' do
    visit "/admin/shelters"
    expect(page).to have_content(@shelter_1.name)
    expect(page).to have_content(@shelter_2.name)
    expect(page).to have_content(@shelter_3.name)
    expect(@shelter_2.name).to appear_before(@shelter_3.name)
    expect(@shelter_3.name).to appear_before(@shelter_1.name)
  end

  it 'I see the name of every shelter that has a pending application' do
    @application1 = Application.create!(name:'Kelly', address: '123 test st', city: 'Boulder', state: 'CO', zip: '80016', description: 'abc', status: 'Pending')
    @pet_application = PetApplication.create!(pet_id: @pet1.id, application_id: @application1.id)
    @application2 = Application.create!(name:'Kara', address: '1234 address', city: 'Denver', state: 'CO', zip: '80016', description: 'xyz', status: 'Pending')
    @pet_application2 = PetApplication.create!(pet_id: @pet2.id, application_id: @application2.id)
    visit "/admin/shelters"
    expect(page).to have_content("Shelters with pending Applications: #{@shelter_1.name}")
  end
end
