-- CPaste, micro pastebin running on Carbon
print("Morning, Ladies and Gentlemen, CPaste here.")
-- Settings:
ret = assert(loadfile("settings.lua")())
-- Web Paste
webpaste = assert(loadfile("webpaste.lua")(ret))
-- Load css
local css = ""
local f = io.open("thirdparty/highlight.css")
if f then
	print("Read thirdparty/highlight.css")
	css = f:read("*a")
	f:close()
end
-- Actual Code:
srv.Use(mw.Logger()) -- Activate logger.

getplain = mw.new(function() -- Main Retrieval of Pastes.
	local seg1 = params("seg1")
	local seg2 = params("seg2")
	local id = seg2
	local method = "pretty"
	if id == nil then
		id = seg1
	else
		method = seg1
		id = seg2
		if id == nil then
			content("No such paste.", 404, "text/plain")
			return
		end
		id = id:sub(2, -1)
	end
	if seg1 == "paste" then
		content(webpaste)
	elseif #id ~= 8 or id == nil then
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
			if method == "raw" then
				content(res, 200, "text/plain")
			elseif method == "pretty" or method == "hl" then
				if cpastemdata == "html" then
					content(res)
				elseif cpastemdata == "plain" then
					content(syntaxhl(res, hlcss), 200)
				else
					content(res, 200, cpastemdata)
				end
			else
				content("No such action. (Try 'raw' or 'pretty')", 404)
			end
		end
		con.Close()
	end
end, {redis_addr=ret.redis, url=ret.url, webpaste=webpaste, hlcss=css})

srv.GET("/:seg1", getplain)
srv.GET("/:seg1/*seg2", getplain)

srv.GET("/", mw.echo(ret.mainpage)) -- Main page.
srv.POST("/", mw.new(function() -- Putting up pastes
	local data = form("c") or form("f")
	local type = form("type") or "plain"
	local giveraw = false
	local giverawform = form("raw")
	if giverawform == "true" or giverawform == "yes" or giverawform == "y" then
		giveraw = true
	else
		giveraw = false
	end
	if data then
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
			local r, err = con.Cmd("set", "cpastemdata:"..id, type) -- Set cpastemdata:<randomid> to the metadata
			if err ~= nil then error(err) end
			local r, err = con.Cmd("expire", "cpaste:"..id, expiretime) -- Make it expire
			if err ~= nil then error(err) end
			local r, err = con.Cmd("expire", "cpastemdata:"..id, expiretime) -- Make it expire
			if err ~= nil then error(err) end
			con.Close()
			if giveraw then
				content(url.."raw/"..id.."\n", 200, "text/plain")
			else
				content(url..id.."\n", 200, "text/plain")
			end
		else
			content("Content too big. Max is "..tostring(maxpastesize).." Bytes, given "..tostring(#data).." Bytes.", 400, "text/plain")
		end
	else
		content("No content given.", 400, "text/plain")
	end
end, {url=ret.url, expiretime=ret.expiresecs, redis_addr=ret.redis, maxpastesize=ret.maxpastesize}))

print("Ready for action!")
