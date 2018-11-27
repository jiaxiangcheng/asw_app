FactoryBot.define do
  factory :submission do
    title { Faker::Lorem.word }
    url { "" }
    text { Faker::Lorem.sentence }
    created_at { Faker::Time.backward }
    updated_at { Faker::Time.forward }
    user
  end
end
