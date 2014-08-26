FactoryGirl.define do
  factory :user do
    first_name            "Arturo"
    last_name             "Guerrero"
    email                 "arturo.guerrero@gruposellcom.com"
    password              "foobar"
    password_confirmation "foobar"
  end
end