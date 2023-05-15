FactoryBot.define do
  factory :market do
    name { Faker::Company.name }
    street { Faker::Address.street_name }
    city { Faker::Address.city }
    country { 'US' }
    state { Faker::Address.state }
    zip { Faker::Address.zip}
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end