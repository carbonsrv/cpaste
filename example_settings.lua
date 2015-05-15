-- Settings
url = "http://mydomain.mytld:8081/get/"
redis = "127.0.0.1:6379"
expiresecs = 604800
mainpage = doctype()(
	tag"head"(
		tag"title" "CPaste Server"
	),
	tag"body"(
		tag"h1" "CPaste",
		"CPaste is a micro paste service using Carbon and Redis",
		tag"h1" "Example Usage",
		tag"blockquote"[{cite="http://github.com/vifino/cpaste"}](
		"$ cat myfile.txt | curl -F 'f=<-' "..url, tag"br",
		url.."rpPxsp6d", tag"br",
		"$ curl "..url.."rpPxsp6d", tag"br",
		"<Content of myfile.txt>", tag"br"
		)
	)
)
-- End

-- Things required to make this stuff actually work! \o/
local ret = {}
ret.url = url
ret.expiresecs = expiresecs
ret.mainpage = mainpage
ret.redis = redis
return ret
