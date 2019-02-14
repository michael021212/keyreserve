RSpec.configure do |config|
  # テスト実行後にアップロードされたファイルを削除
  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{ Rails.root }/spec/test_uploads/"])
  end
end
