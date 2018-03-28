FactoryBot.define do
  factory :privilege do
    action 'read'
    weight 1
    resource '/'

    role
  end
end
