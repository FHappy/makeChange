class DonationsChannel < ApplicationCable::Channel

  def subscribed
    stream_from 'donations'
  end
end
