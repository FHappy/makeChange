Rails.configuration.stripe = {
  :publishable_key => ENV['pk_test_BXvvyNNCdq2c7PKLgIoHDvnw'],
  :secret_key => ENV['sk_test_VMkXZrajoyfxdGbjLZ8l329p']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]