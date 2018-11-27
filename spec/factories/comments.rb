FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.word }
    user
    submission

    to_submission
    trait :to_comment do
      association(:parent, factory: :comment)
    end
    trait :to_submission do
      association(:parent, factory: :submission)
    end
  end
end
