require 'rails_helper'

RSpec.describe 'the applications show' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @pet1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @application1 = Application.create!(name:'Kelly', address: '123 test st', city: 'Boulder', state: 'CO', zip: '80016', description: 'abc', status: 'Pending')
    @pet_application = PetApplication.create!(pet_id: @pet1.id, application_id: @application1.id)
    @application2 = Application.create!(name:'Kara', address: '1234 address', city: 'Denver', state: 'CO', zip: '80016', description: 'abc', status: 'Pending')
    @pet_application2 = PetApplication.create!(pet_id: @pet2.id, application_id: @application2.id)
  end

  it 'For every pet that the application is for, I see a button to approve the application' do
    visit "/admin/applications/#{@application1.id}"
    expect(page).to have_button("Approve #{@pet1.name}")
    expect(page).to_not have_button("Approve #{@pet2.name}")
  end

  it 'Can approve applications' do
    visit "/admin/applications/#{@application1.id}"
    click_button "Approve #{@pet1.name}"
    expect(current_path).to eq("/admin/applications/#{@application1.id}")
    expect(page).to have_content("Approved pets: #{@pet1.name}")
  end

  it 'For every pet that the application is for, I see a button to reject the application' do
    visit "/admin/applications/#{@application1.id}"
    expect(page).to have_button("Reject #{@pet1.name}")
    expect(page).to_not have_button("Reject #{@pet2.name}")
  end

  it 'Can reject applications' do
    visit "/admin/applications/#{@application1.id}"
    click_button "Reject #{@pet1.name}"
    expect(current_path).to eq("/admin/applications/#{@application1.id}")
    expect(page).to have_content("Rejected pets: #{@pet1.name}")
  end

  it 'Approved Pets on one Application do not affect other Applications' do
    @application3 = Application.create!(name:'Josh', address: '14 address', city: 'Foco', state: 'CO', zip: '82016', description: 'xzy', status: 'Pending')
    @pet_application3 = PetApplication.create!(pet_id: @pet1.id, application_id: @application3.id)
    visit "/admin/applications/#{@application1.id}"
    click_button "Approve #{@pet1.name}"
    visit "/admin/applications/#{@application3.id}"
    expect(page).to have_button("Approve #{@pet1.name}")
    expect(page).to_not have_content("Approved pets: #{@pet1.name}")
  end

  it 'Rejected Pets on one Application do not affect other Applications' do
    @application3 = Application.create!(name:'Josh', address: '14 address', city: 'Foco', state: 'CO', zip: '82016', description: 'xzy', status: 'Pending')
    @pet_application3 = PetApplication.create!(pet_id: @pet1.id, application_id: @application3.id)
    visit "/admin/applications/#{@application1.id}"
    click_button "Reject #{@pet1.name}"
    visit "/admin/applications/#{@application3.id}"
    expect(page).to have_button("Reject #{@pet1.name}")
    expect(page).to_not have_content("Rejected pets: #{@pet1.name}")
  end
end
