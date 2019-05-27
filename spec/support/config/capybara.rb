RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
                                   chrome_options: {
                                     args: %w(headless disable-gpu window-size=1680,1050),
                                   },
                                   )
  )
end
