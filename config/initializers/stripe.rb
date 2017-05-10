Rails.configuration.stripe = {
  # :publishable_key => ENV['pk_test_BXvvyNNCdq2c7PKLgIoHDvnw'],
  # :secret_key => ENV['sk_test_VMkXZrajoyfxdGbjLZ8l329p']
  :publishable_key => ENV["stripe_publishable_key"],
  :secret_key => ENV["stripe_api_key"]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]