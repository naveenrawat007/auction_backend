class AuditSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:audited_change] = object.audited_changes
    data
  end
end
