require 'spec_helper'

describe "Create Payment On Success Charge", :type => :request do 

  let (:event_data) do
    {
      "id" => "evt_15925gFgKcqrRTFpzQJDS1v7",
      "created" => 1418424052,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_15925gFgKcqrRTFpVy8WJW4S",
          "object" => "charge",
          "created" => 1418424052,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "gbp",
          "refunded" => false,
          "captured" => true,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15925gFgKcqrRTFpVy8WJW4S/refunds",
            "data" => [

            ]
          },
          "card" => {
            "id" => "card_15925eFgKcqrRTFpRkKFQT79",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 12,
            "exp_year" => 2014,
            "fingerprint" => "DgDX42sUUB2CWCll",
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
            "customer" => "cus_5JfQ36ppdP5h1H"
          },
          "balance_transaction" => "txn_15925gFgKcqrRTFpFZ15pfZx",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_5JfQ36ppdP5h1H",
          "invoice" => "in_15925gFgKcqrRTFpcFgKoiO3",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {
          },
          "statement_description" => "MyFliX Base",
          "fraud_details" => {
          },
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_5JfQanMRLqxUMj",
      "api_version" => "2014-11-05"
    }
  end


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
end