#NGINX Docker Container
> lifegadget/docker-nginx

## Introduction

This is meant as a way to provide the Nginx infrastructure easily and yet with full option flexibility (including compilation switches). It also supports easy integration with PHP's FPM service (see `lifegadget/docker-php` for a good FPM container) without adding bloat so you can ignore FPM if you choose to. Finally, it assumes that content for the site will be provided by the host environment rather than being built into the container.

## Usage ##

- **Basic usage:**
	
		sudo docker run -d lifegadget/nginx -p 80:80 --link PHP:PHP

	This will get you up and running with a [default server configuration](https://github.com/lifegadget/docker-nginx/blob/master/resources/nginx.conf) and pointing to default content. Not very useful but a way to see it working in conjunction with your PHP/FPM stack. To see a basic static page just point your browser to `http://localhost`. If you are using PHP then the following resource is available:

	- `/fpm/` - this should show that you have proper integration to your php/fpm service by executing the `index.php` in your PHP/FPM content's root. If you are using the default configuration of the **lifegadget/docker-php** docker container then you'll get back the familiar output of PHP's `phpinfo()`.
	- `/status` - if your FPM configuration has `pm.status_path` set to "status" then the default mapping should work and you'll see the FPM status page. If you add the parameter "full" you'll get a more complete view. This will work out-of-the-box if you're using lifegadget/docker-php.

- **Advanced usage:**

	You can progressively take over responsiblities for various parts of the configuration, including:

	- `content` - this is more than likely the place where you'll want to take control and specify a directory on the host system which represents the root of the content for your site. This will be internally hosted at `/app/content`.
	- `conf.d` - you can take over the `conf.d` directory which is used to specify [server] blocks; any file with named *.conf will be picked up and used as part of the Nginx configuration. Choosing this will mean that the [default service configuration](https://github.com/lifegadget/docker-nginx/blob/master/resources/default-server.conf) will go no longer be used.
	-  `conf` - if you want complete control over the configuration you can do this too by take over all the configuration files of Nginx. Keep in mind that you must replace all files that would typically be in this directory not just the [nginx.conf](https://github.com/lifegadget/docker-nginx/blob/master/resources/nginx.conf) file.
	-  `logs` - you can share a volume with the container for log files. This doesn't mean the host has any responsibilities but rather it can view log files that the container has created.
	- `sockets` - if you want to connect Nginx with other services via Unix sockets then you should do a volume share with nginx to have a common directory for the socket file
	
	So let's assume that the host has the following directory structure:

		/container/content # html content
		/container/conf.d  # a set of *.conf files specifying various services (FPM, NodeJS, etc.)
		/container/logs/nginx # empty directory which it will differ to container to provide content

	Then you would run the docker container with:

	````bash
	sudo docker run -d lifegadget/nginx -p 80:80 --link PHP:PHP \
		-v /container/content:/app/content \
		-v /container/conf.d:/app/conf.d \
		-v /container/logs:/app/logs
	````

## Versions ##

The branches in this repository represent the major branches of Nginx ... so all 1.6.x versions will be on the `1.6` branch and each minor version will have a tag based label. Right now the only two versions supported are 1.6.1 and 1.7.4 but the idea is to keep this current as time marches on. Feel free to PR an update if we're not keeping up.


## History ##

This was originally a fork of the *semi-official* NGINX image but that image has been shutdown in favour of the PPA-based docker official image. Since then we've been working on getting a sensible container up for folks who want to leverage FPM. The ideas and structures in this container are consistent with the other ones in our current Docker stack: 

- lifegadget/docker-php
- lifegadget/docker-couchbase

## License ##

This Dockerfile is free to use and is covered under the MIT license. 

The MIT License (MIT)

Copyright © 2014 LifeGadget Ltd, http://lifegadget.co

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
