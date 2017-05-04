Rails.configuration.stripe = {
  :publishable_key => ENV['pk_test_fFmUsXgVwn5RCnwp1MyNVcyL'],
  :secret_key => ENV['sk_test_fqgNuBatn5LvVZ7luRXX4Pb2']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]