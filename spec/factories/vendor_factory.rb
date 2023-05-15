FactoryBot.define do
  factory :market do
    name { Faker::Commerce.vendor }
    description { Faker::Marketing.buzzwords }
    contact_name { Faker::Name.first_name }
    contact_phone { Faker::PhoneNumber.cell_phone }
    credit_accepted { Faker::Boolean.boolean(true_ratio: 0.5) }
  end
end