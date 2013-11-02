class Permission < ActiveRecord::Base
  belongs_to :group
  belongs_to :meta, inverse_of: :permissions
  self.inheritance_column = "_another_column"
end
