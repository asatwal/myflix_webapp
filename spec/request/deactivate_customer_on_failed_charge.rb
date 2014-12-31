require 'spec_helper'

describe "Deactivate Customer On Failed Charge", :type => :request do 

  let (:event_data) do
    {
      "id" => "evt_15FZEPFgKcqrRTFp5JGmVHWC",
      "created" => 1419981413,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_15FZEPFgKcqrRTFpM4zUKuHF",
          "object" => "charge",
          "created" => 1419981413,
          "livemode" => false,
          "paid" => false,
          "amount" => 2000,
          "currency" => "usd",
          "refunded" => false,
          "captured" => false,
          "card" => {
            "id" => "card_15FZ91FgKcqrRTFpOfhXilvV",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 12,
            "exp_year" => 2015,
            "fingerprint" => "uuue6TsTqTOwV8bx",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "customer" => "cus_5Jis7HpQjzW2DV"
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_5Jis7HpQjzW2DV",
          "invoice" => nil,
          "description" => "Manual 2",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => "Manual 2",
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15FZEPFgKcqrRTFpM4zUKuHF/refunds",
            "data" => []
          },
          "statement_description" => "Manual 2"
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_5QQ4kTDrFyUJ7J",
      "api_version" => "2014-11-05"
    }
  end

  it "deactivates user with webhook from stripe for failed charge", :vcr  do
    bob = Fabricate(:user, payment_token: 'cus_5Jis7HpQjzW2DV')
    post '/stripe_events', event_data
    expect(bob.reload).to_not be_active
  end

=begin
  it "creates a payment with the webhook from stripe for success charge", :vcr  do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it "creates a payment associated with a user", :vcr  do
    bob = Fabricate(:user, payment_token: 'cus_5JfQ36ppdP5h1H')
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(bob)
  end
  
  it "creates a payment with correct amount", :vcr  do
    bob = Fabricate(:user, payment_token: 'cus_5JfQ36ppdP5h1H')
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates a payment with correct reference id", :vcr  do
    bob = Fabricate(:user, payment_token: 'cus_5JfQ36ppdP5h1H')
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq('ch_15925gFgKcqrRTFpVy8WJW4S')
  end
=end
end