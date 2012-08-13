json.array!(@boards.select { |b| can? :read, b }) do |json, board|
  json.partial! "partials/board_info", :board => board
end
