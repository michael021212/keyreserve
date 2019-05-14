FactoryBot.define do
  factory :facility_dropin_plan do
    facility
    plan
    guide_mail_title { 'テストメール' }
    guide_mail_content { 'テストメールだよー！' }
  end
end
