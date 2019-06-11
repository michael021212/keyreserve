class TwilioApi
  include Singleton

  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new ENV['TWILIO_API_SID'], ENV['TWILIO_API_SECRET']
  end

  def self.send_sms(to, code)
    begin
      TwilioApi.instance.client.api.account.messages.create(
        from: ENV['TWILIO_TEL'],
        to: to,
        body: "KS BOOKING 認証コード: #{code}"
      )
    rescue => e
      puts e.message
    end
  end
end

