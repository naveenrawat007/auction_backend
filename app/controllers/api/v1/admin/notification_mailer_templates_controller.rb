module Api
  module V1
    module Admin
      class NotificationMailerTemplatesController < Api::V1::MainController
        before_action :authorize_admin_request
        def index
          if params[:search_str].blank? == false
            templates = NotificationMailerTemplate.where("lower(title) LIKE :search", search: "%#{params[:search_str].downcase}%").order(:created_at)
          else
            templates = NotificationMailerTemplate.order(:created_at).all
          end
          render json: {templates: ActiveModelSerializers::SerializableResource.new(templates, each_serializer: NotificationMailerTemplateSerializer), status: 200}, status: 200
        end

        def update
          template = NotificationMailerTemplate.find(params[:id])
          if template
            template.update(template_params)
            render json: {message: "Template Updated Successfully", status: 200}, status: 200
          else
            render json: {message: "Template not found", status: 400}, status: 200
          end
        end

        def send_test_mail
          mailer_template = NotificationMailerTemplate.find_by(id: params[:id])
          if mailer_template
            if params[:emial].blank? == false
              Sidekiq::Client.enqueue_to_in("default", Time.now, TestMailSendOutWorker, mailer_template.id, params[:email])
              render json: {message: "Mail has been sent.", status: 200}, status: 200
            else
              render json: {message: "Email is blank.", status: 400}, status: 200
            end
          else
            render json: {message: "Mail Template is found.", status: 400}, status: 200
          end
        end

        private
        def template_params
          params.require(:template).permit(:body, :title)
        end
      end
    end
  end
end
