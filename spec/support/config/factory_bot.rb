RSpec.configure do |config|
  # FactoryBotの呼び出し簡略化
  config.include FactoryBot::Syntax::Methods

  config.before :all do
    FactoryBot.reload
  end
end
