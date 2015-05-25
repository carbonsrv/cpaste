-- CPaste, micro pastebin running on Carbon
print("Morning, Ladies and Gentlemen, CPaste here.")
-- Settings:
ret = dofile("settings.lua")
-- Actual Code:
srv.Use(mw.Logger()) -- Activate logger.

srv.GET("/:id", mw.new(function() -- Main Retrieval of Pastes.
	local id = params("id") -- Get ID
	if #id ~= 8 then
		content("No such paste.", 404, "text/plain")
	else
		local con, err = redis.connectTimeout(redis_addr, 10) -- Connect to Redis
		if err ~= nil then error(err) end
		local res,err = con.Cmd("get", "cpaste:"..id).String() -- Get cpaste:<ID>
		if err ~= nil then error(err) end
		local cpastemdata, err = con.Cmd("get", "cpastemdata:"..id).String()
		if err ~= nil then error(err) end
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
			if cpastemdata == "plain" then
				content(res, 200, "text/plain")
			else
				content(res)
			end
		end
		con.Close()
	end
end, {redis_addr=ret.redis}))

srv.GET("/", mw.echo(ret.mainpage)) -- Main page.
srv.POST("/", mw.new(function() -- Putting up pastes
	local data = form("f")
	if not data then
		data = form("c")
	end
	local plain = true
	if not form("html") then
		plain = false
	end
	if not data then
		if #data <= maxpastesize then
			math.randomseed(unixtime())
			local id = ""
			local stringtable={}
			for i=1,8 do
				local n = math.random(48, 122)
				if (n < 58 or n > 64) and (n < 91 or n > 96) then
					id = id .. string.char(n)
				else
					id = id .. string.char(math.random(97, 122))
				end
			end
			local con, err = redis.connectTimeout(redis_addr, 10) -- Connect to Redis
			if err ~= nil then error(err) end
			local r, err = con.Cmd("set", "cpaste:"..id, data) -- Set cpaste:<randomid> to data
			if err ~= nil then error(err) end
			local r, err = con.Cmd("set", "cpastemdata:"..id, plain and "plain" or "html") -- Set cpastemdate:<randomid> to the metadata
			if err ~= nil then error(err) end
			local r, err = con.Cmd("expire", "cpaste:"..id, expiretime) -- Make it expire
			if err ~= nil then error(err) end
			local r, err = con.Cmd("expire", "cpastemdata:"..id, expiretime) -- Make it expire
			if err ~= nil then error(err) end
			con.Close()
			content(url..id.."\n", 200, "text/plain")
		else
			content("Content too big. Max is "..tostring(maxpastesize).." Bytes, given "..tostring(#data).." Bytes.", 400, "text/plain")
		end
	else
		content("No content given.", 400, "text/plain")
	end
end, {url=ret.url, expiretime=ret.expiresecs, redis_addr=ret.redis, maxpastesize=ret.maxpastesize}))
