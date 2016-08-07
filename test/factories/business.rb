FactoryGirl.define do

  factory :business do
    sequence(:uuid) {|n| "#{n}-#{n+1}-#{n+2}"}
    name 'Business abc'
  end
end