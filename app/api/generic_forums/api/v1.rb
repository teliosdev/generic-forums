class GenericForums::API::V1 < Grape::API

  version 'v1', using: :path, cascade: false
  format :json

  desc "Formats a string to show what it would look like."
  params do
    optional :type, type: String, desc: "The formatting to use.",
      default: :markdown
    requires :body, type: String, desc: "The text to format."
  end
  post 'format' do
    {
      format: params[:type],
      body: GenericDataFormatter.format(params[:type], params[:body])
    }
  end

  desc "Gets information about routes."
  get 'routes' do
    GenericForums::API.routes
  end
end
