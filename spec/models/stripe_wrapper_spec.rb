require 'spec_helper'

describe StripeWrapper do

  let(:token) do
    # Create a stripe token
    token = Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 11,
        :exp_year => 2018,
        :cvc => "314"
      },
    ).id
  end

  describe StripeWrapper::Charge do

    describe '.charge' do
      let(:charge) do
        charge = StripeWrapper::Charge.create(
          card:   token,
          amount: 315,
          description: 'Valid test charge'
          )
      end

      context 'with a valid card' do
        let(:card_number) {'4242424242424242'}
        it 'charges successfully', :vcr do
          expect(charge).to be_success
        end

        it 'charges correct amount', :vcr do
          expect(charge.response.amount).to eq(315)
        end

        it 'charges in correct currency', :vcr do
          expect(charge.response.currency).to eq('gbp')
        end
      end

      context 'with an invalid card' do
        let(:card_number) {'4000000000000002'}
        it 'charge not successfull', :vcr do
          expect(charge).to_not be_success
        end
        it 'expected error message returned', :vcr do
          expect(charge.error_message).to eq('Your card was declined.')
        end
      end
    end
  end

  describe StripeWrapper::Customer do

    describe '.create' do

      let(:customer) do

        bob = Fabricate(:user, email_address: 'bob_stripe_test@bob.com')

        customer = StripeWrapper::Customer.create(
          card:   token,
          user:   bob
          )
      end

      context 'with valid card' do

        let(:card_number) {'4242424242424242'}

        it 'creates customer successfully', :vcr do
          expect(customer).to be_success
        end

        it 'creates customer payment token successfully', :vcr do
          expect(customer.payment_token).to be_present
        end
      end

      context 'with an invalid card' do

        let(:card_number) {'4000000000000002'}

        it 'does not create customer', :vcr do
          expect(customer).not_to be_success
        end
        it 'expected error message returned', :vcr do
          expect(customer.error_message).to eq('Your card was declined.')
        end
      end
    end
  end

end