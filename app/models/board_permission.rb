class BoardPermission < Permission
  belongs_to :board, :foreign_key => :remote_id
end
