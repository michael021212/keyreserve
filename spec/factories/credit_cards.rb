FactoryGirl.define do
  factory :credit_card do
    user nil
    card_no "MyString"
    sequence 1
    kind 1
    holder_name "MyString"
    stripe_card_id "MyString"
    deleted_at "2017-09-23 16:16:37"
  end
end
