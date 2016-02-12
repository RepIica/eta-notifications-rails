class CustomersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_customer, only: [:show, :notify_start, :notify_deliver]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @customers = Customer.all
  end

  def show
  end

  def notify_start
    message = 'Your clothes will be sent and will be deliverred in 20 minutes'
    notify(message)
  end
    
  def notify_deliver
    message = 'Your clothes have been delivered'
    notify(message)
  end

  private

  def notify(message)
    MessageSender.new.send_message(@customer.phone_number, message)
    redirect_to customers_url
  end

  def load_customer
    @customer = Customer.find(params[:id])
  end

  def record_not_found
    render 'shared/404', status: 404, layout: false
  end
end
