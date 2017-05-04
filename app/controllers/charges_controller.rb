class ChargesController < ApplicationController

  def create
    binding.pry
    @amount = 575

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :source => params[token]
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
