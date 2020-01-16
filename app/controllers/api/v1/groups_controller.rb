module Api
  module V1
    class GroupsController < MainController
      before_action :authorize_request
      def index
        @groups = @current_user.groups
        render json: {groups: ActiveModelSerializers::SerializableResource.new(@groups, each_serializer: GroupSerializer), status: 200}, status: 200
      end

      def show_messages
        @group = @current_user.groups.find_by(id: params[:group_id])
        if @group
          @messages = @group.messages.order(create_at: :desc)
          render json: {messages: ActiveModelSerializers::SerializableResource.new(@messages, each_serializer: MessageSerializer), status: 200}, status: 200
        else
          render json: {message: "Group not found", status: 400}, status: 200
        end
      end

      def create_messages
        @group = @current_user.groups.find_by(id: params[:group_id])
        if @group
          @messages = @group.messages.create(user_id: @current_user.id, content: params[:content])
          render json: {messages: ActiveModelSerializers::SerializableResource.new(@messages, each_serializer: MessageSerializer), status: 200}, status: 200
        else
          render json: {message: "Group not found", status: 400}, status: 200
        end
      end
    end
  end
end
