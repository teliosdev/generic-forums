( (expose)->

	class expose.Client

		constructor: (@host=location.host, @protocol=location.protocol)->

		getBoardList: (cb)->
			@_ajaxCall("boards", cb)

		getBoard: (id, cb)->
			@_ajaxCall("boards/#{id}", cb)

		getBoardThreads: @prototype.getBoard

		getThread: (board, id, cb, opts={})->
			data = {}
			data.url = "boards/#{board}/threads/#{id}"
			data.data = opts
			@_ajaxCall(data, cb)

		getThreadPosts: @prototype.getThread

		getPost: (board, thread, id, cb, opts={})->
			data = {}
			data.url = "boards/#{board}/threads/#{thread}/posts/#{id}"
			data.data = opts
			@_ajaxCall(data, cb)

		_getToken: (auth, cb)->
			data = { url: "sessions", type: "POST" }
			data.data = { session: { name: auth.name, password: auth.password } }
			@_ajaxCall data, (d)->
				return false if d.status isnt undefined
				console.log d
				cb(d.token)

		testToken: (auth, cb)->
			data = { url: "boards/1/threads/new" }
			@_getToken auth, (token)=>
				data.data = { session: token }
				@_ajaxCall data, (d)->
					console.warn d

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
