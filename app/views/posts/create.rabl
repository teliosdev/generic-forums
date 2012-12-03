object @post

node :errors do |o|
  o.errors
end

node :success do |o|
  o.valid?
end
