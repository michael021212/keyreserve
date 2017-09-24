FactoryGirl.define do
  factory :payment do
    user nil
    corporation nil
    facility nil
    credit_card nil
    price "MyString"
    token "MyString"
    deleted_at "2017-09-23 16:18:12"
  end
end
