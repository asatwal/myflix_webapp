module StripeWrapper

  class Charge

    attr_reader :error_message, :response

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin 
        charge = Stripe::Charge.create(
          card:        options[:card],
          amount:      options[:amount],
          description: options[:description],
          currency:    'gbp')

        new(response: charge)

      rescue Stripe::CardError => e

        new(error_message: e.message)
      end
    end

    def success?
      response.present?
    end
  end

  class Customer

    attr_reader :error_message, :response

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin 
        customer = Stripe::Customer.create(
          card:        options[:card],
          plan:        'Base',
          email:       options[:user].email_address)

        new(response: customer)

      rescue Stripe::CardError => e

        new(error_message: e.message)
      end
    end

    def success?
      response.present?
    end
  end

end