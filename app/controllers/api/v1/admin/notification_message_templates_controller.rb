module Api
  module V1
    module Admin
      class NotificationMessageTemplatesController < Api::V1::MainController
        before_action :authorize_admin_request
        def index
          if params[:search_str].blank? == false
            templates = NotificationMessageTemplate.where("lower(title) LIKE :search", search: "%#{params[:search_str].downcase}%").order(:created_at)
          else
            templates = NotificationMessageTemplate.order(:created_at).all
          end
          render json: {templates: ActiveModelSerializers::SerializableResource.new(templates, each_serializer: NotificationMessageTemplateSerializer), status: 200}, status: 200
        end

        def update
          template = NotificationMessageTemplate.find(params[:id])
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
