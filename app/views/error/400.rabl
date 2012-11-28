node :status do
	response.status
end

if flash[:errors]
	node :errors do
		flash[:errors]
	end
end
