Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    # Define subscriber behavior based on the event object
    # event.class       => Stripe::Event
    # event.type        => "charge.succeeded"
    # event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>

    user = User.where(payment_token: event.data.object.customer).first

    Payment.create(user: user, amount: event.data.object.amount, reference_id: event.data.object.id)
  end

  events.subscribe 'charge.failed' do |event|
    # Define subscriber behavior based on the event object
    # event.class       => Stripe::Event
    # event.type        => "charge.failed"
    # event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>

    user = User.where(payment_token: event.data.object.customer).first

    user.deactivate!
  end


  events.all do |event|
    # Handle all event types - logging, etc.
  end
end
