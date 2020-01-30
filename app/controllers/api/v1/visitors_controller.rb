module Api
  module V1
    class VisitorsController < MainController
      def submit_question
        @visitor = Visitor.new(visitor_params)
        if @visitor.save
          render json: {message: "Request has been submitted", status: 200}, status: 200
        else
          render json: {message: "Can not save request", status: 400}, status: 200
        end
      end
      private
      def visitor_params
        params.require(:visitor).permit(:name, :phone_number, :email, :question)
      end
    end
  end
end
