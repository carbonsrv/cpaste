-- CPaste, micro pastebin running on Carbon
-- Settings:
url = dofile("settings.lua")
-- Actual Code:
srv.Use(mw.Logger()) -- Activate logger.

srv.GET("/get", mw.echoText("Usage: /get/<ID>")) -- Small usage hint

srv.GET("/get/:id", mw.new(function() -- Main Retrieval of Pastes.
	local id = params("id") -- Get ID
	local con, err = redis.connectTimeout("127.0.0.1:6379", 10) -- Connect to Redis
	if err ~= nil then error(err) end
	local res,err = con.Cmd("get", "cpaste:"..id).String() -- Get cpaste:<ID>
	if res == "<nil>" then
		content(doctype()(
			tag"head"(
				tag"title" "CPaste"
			),
			tag"body"(
				"No such paste."
			)
		))
	else
		content(res)
	end
	con.Close()
end))

srv.POST("/", mw.new(function() -- TBD, putting up pastes
	local data = form("f")
	if data ~= "" then
		math.randomseed(os.time())
		local id = ""
		local week = 604800
		local stringtable={}
		for i=1,8 do
			local n = math.random(48, 122)
			if (n < 58 or n > 64) and (n < 91 or n > 96) then
				id = id .. string.char(n)
			else
				id = id .. string.char(math.random(97, 122))
			end
		end
		local con, err = redis.connectTimeout("127.0.0.1:6379", 10) -- Connect to Redis
		if err ~= nil then error(err) end
		local r,err = con.Cmd("set", "cpaste:"..id, data) -- Set cpaste:<randomid> to data
		if err ~= nil then error(err) end
		local r,err = con.Cmd("expire", "cpaste:"..id, week) -- Make it expire
		if err ~= nil then error(err) end
		con.Close()
		content(url..id.."\n")
	else
		content("No content given.")
	end
end, {["url"]=url}))
