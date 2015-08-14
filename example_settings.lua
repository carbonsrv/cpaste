-- Settings
url = "http://mydomain.mytld:8081/"
redis = "127.0.0.1:6379"
expiresecs = 604800
maxpastesize = 64 * 1024 -- 64KiB
mainpage = doctype()(
	tag"head"(
		tag"title" "CPaste Server"
	),
	tag"body"(
		tag"h1" "CPaste",
		"CPaste is a micro paste service using Carbon and Redis.", tag"br",
		tag"a"[{href="http://github.com/vifino/cpaste"}]("Get it here."), tag"br",
		tag"h1" "Example Usage:",
		tag"blockquote"[{cite="http://github.com/vifino/cpaste"}](
			tag"h2" "CLI:",
			"$ cat myfile.txt | curl -F 'f=<-' "..url, tag"br",
			url.."rpPxsp6d", tag"br",
			"$ curl "..url.."raw/rpPxsp6d", tag"br",
			"<Content of myfile.txt>", tag"br",
			tag"br",
			tag"h2" "Browser:",
			"Open ", tag"a"[{href=url.."paste"}](url.."paste"), " for a web paste.", tag"br",
			"It will present you a link to the paste, similar to the CLI way.", tag"br",
			"The returned link will have syntax highlighting enabled. If you don't like that,", tag"br",
			"just replace "..url.." with "..url.."raw/ and you'll get the raw text output,", tag"br",
			"without syntax highlighting.", tag"br"
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
ret.maxpastesize = maxpastesize
return ret
