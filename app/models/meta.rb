class Meta < ActiveRecord::Base

  #has_many :remotes, as: :remote
  #has_many :permissions, inverse_of: :meta
  #has_many :remotes, polymorphic: true
  has_many :permissions, inverse_of: :meta

  def remotes
    remote_type.constantize.where(meta_id: id)
  end
end
