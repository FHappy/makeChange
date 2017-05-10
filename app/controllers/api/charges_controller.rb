class Api::ChargesController < ApplicationController
  def index
    render json: {
      message: 'hey'
    }
  end
  
  def create
    begin
    @amount = 575
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
    @tokens = (@amount / 500) * 5
    current_user["token_amount"] += @tokens
    current_user.save()

    render json: {message: "Payment for #{@amount} successfully submitted"}, status: 200

    rescue Stripe::CardError => e
      render json: {message: e.message}, status: 517
    end
    
  end
end
