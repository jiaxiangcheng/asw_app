# VHS username factory
FactoryBot.define do
  factory :user do
    provider { "google_oauth2" }
    uid { Faker::Number.number(10) }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    token { Faker::Lorem.characters(30) }
    about { Faker::FamousLastWords.last_words }
    created_at { Faker::Time.backward }
    updated_at { Faker::Time.forward }
  end
end
