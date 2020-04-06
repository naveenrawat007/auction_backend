module Api
  module V1
    class SubscribersController < MainController

      def create
        subscriber = Subscriber.new(subscriber_params)
        if subscriber.save
          render json: {status: 201, message: "Thanks for sharing your details with us. We emailed you the guide download link."}
          Sidekiq::Client.enqueue_to_in("default",Time.now, SubscriberWorker, params[:subscriber][:email], params[:subscriber][:name])
        else
          render json: {status: 400, message: "Subscriber not created"}
        end
      end

      private

      def subscriber_params
        params.require(:subscriber).permit(:name, :phone_no, :email)
      end

    end
  end
end
