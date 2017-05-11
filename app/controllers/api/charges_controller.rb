class Api::ChargesController < ApplicationController
  def index
    render json: {
      message: 'hey'
    }
  end
  
  def create
    begin
    @amount = 545
    
    token = params["charge"]["token"]

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :source => token
    )

    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => @amount,
      :description => 'makeChange donation',
      :currency => 'usd',
      :transfer_group => "{TO_CHARITIES}"
    )
    @tokens = (@amount / 500) * 5
    current_user["token_amount"] += @tokens
    current_user.save()

    render json: {message: "Payment for #{@amount} successfully submitted"}, status: 200

    rescue Stripe::CardError => e
      render json: {message: e.message}, status: 517
    end 
  end


  def goal_completion
    ein = params["ein"]
    @charity = Charity.find(ein: ein)
    charityName = @charity["charityName"]

    transfer = Stripe::Transfer.create({
      :amount => 545,
      :currency => "usd",
      :destination => ENV["makeMyDonation_uid"],
      :transfer_group => "{TO_CHARITIES}",
      :partnerId => ENV["stripe_connect_client_id"],
      :ein => ein,
      :charityName => charityName
    })
  end
  
end
