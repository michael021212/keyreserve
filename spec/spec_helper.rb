require 'simplecov'

if ENV['circle_artifacts']
  dir = file.join(env['circle_artifacts'], 'coverage')
  simplecov.coverage_dir(dir)
end
SimpleCov.start 'rails'

RSpec.configure do |config|

  # テスト実行前にseedデータの挿入
  config.before :suite do
    fixture_paths = "#{Rails.root}/db/fixtures/test"
    SeedFu.seed(fixture_paths)
  end

  # focusタグがあればそれだけ実行、なければ全spec実行
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # specをランダム実行
  config.order = :random

end
