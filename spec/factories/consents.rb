# spec/factories/consents.rb
FactoryBot.define do
  factory :consent do
    association :patient
    granted_to  { "nurse@hospital.com" }
    granted     { true }
  end
end