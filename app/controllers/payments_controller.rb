class PaymentsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  before_action :authenticate_user!
  before_action :set_order

  def create
    @stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: line_items_from_order,
      mode: 'payment',
      success_url: success_payment_url(@order.id),
      cancel_url: order_url(@order)
    )

    @order.update(stripe_session_id: @stripe_session.id)

    respond_to do |format|
      format.html { redirect_to @stripe_session.url, allow_other_host: true }
      format.js
      format.turbo_stream { redirect_to @stripe_session.url, allow_other_host: true }
    end
  end

  def success
    if @order
      begin
        stripe_session = Stripe::Checkout::Session.retrieve(@order.stripe_session_id)
        payment_intent = Stripe::PaymentIntent.retrieve(stripe_session.payment_intent)

        if payment_intent.status == 'succeeded'
          @order.update(
            status: :paid,
            stripe_payment_id: payment_intent.id
          )
          flash[:notice] = "Payment successful! Your order has been processed."
        else
          flash[:alert] = "Payment was not successfully processed. Please try again or contact support."
        end
      rescue => e
        flash[:alert] = "Error retrieving payment information: #{e.message}"
      end
    else
      flash[:alert] = "Order not found. Please contact support if you believe this is an error."
    end
  end

  private
  
  def set_order
    @order = Order.find(params[:id] || params[:order_id])
    redirect_to root_path, alert: "Order not found" unless @order
  end

  def line_items_from_order
    @order.order_items.map do |item|
      {
        price_data: {
          currency: 'cad',
          product_data: {
            name: item.product.name,
            description: truncate(item.product.description, length: 100)
          },
          unit_amount: (item.bought_price * 100).to_i, # Stripe uses cents
        },
        quantity: item.quantity
      }
    end
  end
end