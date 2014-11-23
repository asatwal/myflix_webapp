require 'spec_helper'

describe StripeWrapper do

  describe StripeWrapper::Charge do


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
        it 'charge not successfull', :vcr do
          expect(charge.error_message).to eq('Your card was declined.')
        end
      end

    end
  end
end