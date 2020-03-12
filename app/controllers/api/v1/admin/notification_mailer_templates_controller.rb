module Api
  module V1
    module Admin
      class NotificationMailerTemplatesController < Api::V1::MainController
        before_action :authorize_admin_request
        def index
          templates = NotificationMailerTemplate.order(:created_at).all
          render json: {templates: ActiveModelSerializers::SerializableResource.new(templates, each_serializer: NotificationMailerTemplateSerializer), status: 200}, status: 200
        end

        def update
          template = NotificationMailerTemplate.find(params[:id])
          if template
            template.update(template_params)
            render json: {messages: "Template Updated Successfully", status: 200}, status: 200
          else
            render json: {messages: "Template not found", status: 400}, status: 200
          end
        end

        private
        def template_params
          params.require(:template).permit(:body)
        end
      end
    end
  end
end
