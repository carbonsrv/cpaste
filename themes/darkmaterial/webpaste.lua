local args = {...}
local settings = args[1]
return doctype()(
	tag"head"(
		tag"title" "CPaste WebPaste",
		tag"script"[{src="//code.jquery.com/jquery-1.11.3.min.js"}](),
		tag"script"[{src="//code.jquery.com/jquery-migrate-1.2.1.min.js"}](),
		tag"script"([[
			$(document).ready(function() {
				$('#submit').click(function() {
					var sentType = "normal";
					var pasteTypes = document.getElementsByName("pasteType");
					if (pasteTypes[0].checked) sentType = "normal";
					if (pasteTypes[1].checked) sentType = "raw";
					if (pasteTypes[2].checked) sentType = "text/html";
					$.ajax({
						data: {
							c: $('textarea').val(),
							type: sentType
						},
						type: "POST",
						url: $('#submit').attr('formaction'),
						success: function(response) {
							$('#resultholder').css({
								display: "block",
								opacity: "1"
							});
							$('#result').html(response);
							$('#result').attr("href", response);
							console.log( response )
						}
					});
					return false
				});

				$('#close').click(function() {
					$('#resultholder').css({
						opacity: "0"
					});
					setTimeout(function() {
						$('#resultholder').css("display","");
					}, 200 /*ms*/);
				});
			});
		]]),
		tag"style"[{type="text/css"}]([[
			body {
				overflow: hidden;
				margin: 0px;
				width: 100%;
				height: 100%;
				background-color: #212121;
			}
			#container {
				display: flex;
				flex-direction: column;
				height: 100vh;
			}
			button {
				margin: 4px;
				padding: 8px;
				background-color: #424242;
				border: none;
				border-radius: 2px;
				color: #fff;
				text-decoration: none;
				transition: 0.2s;
			}
			button:hover {
				background-color: #616161;
			}
			button:active {
				background-color: #757575;
			}
			#submit {
				float: right;
				background-color: #311B92;
			}
			#submit:hover {
				background-color: #4527A0;
			}
			#submit:active {
				background-color: #512DA8;
			}
			.pasteTypeHolder {
				padding: 4px;
				color: #fff;
				position: absolute;
				top: 50%;
				transform: translateY(-50%);
			}
			.pasteType {
				vertical-align: text-top;
			}
			textarea {
				background-color: #111111;
				border: none;
				color: #fff;
				width: 100%;
				flex-grow: 1;
				resize: none;
				outline: 0;
			}
			#bottom_container {
				flex-grow: 0;
				position: relative;
			}
			#resultholder {
				padding: 8px;
				background-color: #424242;
				border: none;
				border-radius: 2px;
				position: fixed;
				left: 50%;
				top: 50%;
				transform: translate( -50%, -50% );
				display: none;
				opacity: 0;
				transition: 0.2s;
			}
			#result {
				color: #fff;
			}
		]])
	),
	tag"body"(
		tag"div"[{id="container"}](
			tag"textarea"[{name="c", placeholder="Hello World!"}](),
			tag"div"[{id="bottom_container"}](
				tag"button"[{id="submit",formaction=settings.url}]("Paste!"),
				tag"div"[{class="pasteTypeHolder"}](
					tag"input"[{type="radio",class="pasteType",name="pasteType",id="radio1",checked=""}],
					tag"label"[{["for"]="radio1"}]("Normal"),
					tag"input"[{type="radio",class="pasteType",name="pasteType",id="radio2"}],
					tag"label"[{["for"]="radio2"}]("Raw"),
					tag"input"[{type="radio",class="pasteType",name="pasteType",id="radio3"}],
					tag"label"[{["for"]="radio3"}]("HTML")
				)
			)
		),
		tag"div"[{id="resultholder"}](
			tag"a"[{id="result"}](""),
			tag"button"[{id="close"}]("Close")
		)
	)
):render()
