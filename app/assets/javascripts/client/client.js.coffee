( (expose)->

	class expose.Client

		constructor: (@host=location.host, @protocol=location.protocol)->

		getBoardList: (cb)->
			@_ajaxCall("boards", cb)

		getBoard: (id, cb)->
			@_ajaxCall("boards/#{id}", cb)

		getBoardThreads: @prototype.getBoard

		getThread: (board, id, cb)->
			@_ajaxCall("boards/#{board}/threads/#{id}", cb)

		getThreadPosts: @prototype.getThread

		getPost: (board, thread, id, cb)->
			@_ajaxCall("boards/#{board}/threads/#{thread}/#{id}", cb)

		_ajaxCall: (data, callback)->
			if typeof data == "string"
				data = { url: data }

			data.success = callback;
			data.dataType = "json"
			data.url = @_url(data.url)

			window.jQuery.ajax(data)

		_url: (path)->
			"#{@protocol}//#{@host}/#{path}.json"


)(window.Generic)
