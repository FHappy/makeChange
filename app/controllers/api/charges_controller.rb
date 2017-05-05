class Api::ChargesController < ApplicationController
  def index
    render json: {
      message: 'hey'
    }
  end
  
  def create
    begin
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
    render json: {message: "Payment for #{@amount} successfully submitted"}, status: 200
    rescue Stripe::CardError => e
      # flash[:alert] = e.message
      # return {
      #   alert: e.message
      # }
      render json: {message: e.message}, status: 517
    end
    
  end
end
