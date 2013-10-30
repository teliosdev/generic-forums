class Category < ActiveRecord::Base

  belongs_to :parent, class_name: "Category", inverse_of: :children
  has_many :children, class_name: "Category",
    foreign_key: "parent_id", dependent: :restrict_with_error,
    inverse_of: :parent

  include Shared::Metable
end
