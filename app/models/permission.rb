class Permission < ActiveRecord::Base
  belongs_to :group
  self.inheritance_column = "_another_column"
end
