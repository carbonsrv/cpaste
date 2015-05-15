srv.Use(mw.Logger()) -- Activate logger.

srv.GET("/get", mw.echoText("Usage: /get/<ID>")) -- Small usage hint

srv.GET("/get/:id", mw.new(function() -- Main Retrieval of Pastes.
	local id = params("id") -- Get ID
	if id ~= nil then
		local con, err = redis.connectTimeout("127.0.0.1:6379", 10) -- Connect to Redis
		if err ~= nil then error(err) end
		local res,err = con.Cmd("get", "cpaste:"..id).String() -- Get cpaste:<ID>
		if res == "<nil>" then
			content(doctype()(
				tag"body"(
					tag"h1" "No such paste."
				)
			))
		end
		con.Close()
		content(res)
	else
		content("No ID? pls.")
	end
end))
