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

Make sure [Redis](http://redis.io/) runs on the default port (`6379`), didn't make an option to change that yet.

Get [Carbon](https://github.com/vifino/carbon) itself and run `carbon --config=cpaste.conf` in the source directory.
