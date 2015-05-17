# cpaste
CPaste is a micro paste service using Carbon and Redis

# Example Usage
```sh
$ cat myfile.txt | curl -F 'f=<-' mydomain.mytld:8081
http://mydomain.mytld:8081/get/rpPxsp6d
$ curl http://mydomain.mytld:8081/get/rpPxsp6d
<Content of myfile.txt>
```

# Setup
Tweak `cpaste.conf` to your liking, look at [Carbon](https://github.com/vifino/carbon) for the options. 
Most likely you only want to change the port.

Copy `example_settings.lua` to `settings.lua`, change everything you need to change in there.

Make sure [Redis](http://redis.io/) runs on the specified address in `settings.lua`

Get [Carbon](https://github.com/vifino/carbon) itself and run `carbon --config=cpaste.conf` in the source directory.
