class CreateActivityService
  include ApplicationHelper
  attr_reader :resource, :act_type

  def initialize(resource, type)
	  @resource = resource
   	@act_type = type
 	end

  def process!
    act = Activity.create(resource: resource, act_type: act_type)
  end
end
