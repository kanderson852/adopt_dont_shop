PetApplication.destroy_all
Application.destroy_all
Pet.destroy_all
Shelter.destroy_all

@shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
@pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
@pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
@pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)


@shelter1 = Shelter.create!(foster_program: true, name:"Humane Society", city: "Fort Collins", rank: 2)
@pet1 = @shelter1.pets.create!(adoptable: true, age: 1, breed:"Dachshund", name:"Rusko")
@pet2 = @shelter1.pets.create!(adoptable: true, age: 3, breed:"Beagle", name:"Rosie")
@application1 = Application.create!(name:'Kelly', address: '123 test st', city: 'Boulder', state: 'CO', zip: '80016', description: "Application Description", status: 'in progress' )
@pet_application = PetApplication.create!(pet_id: @pet1.id, application_id: @application1.id)
