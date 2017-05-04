class ChargesController < ApplicationController
  def index
    render json: {
      message: 'hey'
    }
  end
  
  def create
    binding.pry
    @amount = 575

    Stripe.api_key = "sk_test_VMkXZrajoyfxdGbjLZ8l329p"

    token = params["charge"]["token"]

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :source => token
    )

    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => @amount,
      :description => 'makeChange donation',
      :currency => 'usd'
    )

    # rescue Stripe::CardError => e
    #   flash[:error] = e.message
    #   redirect_to new_charge_path
  end
end
