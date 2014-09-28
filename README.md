#NGINX Docker Container
> lifegadget/docker-nginx

## Introduction

This is meant as a way to provide the Nginx infrastructure easily and yet with full option flexibility (including compilation switches). It also supports easy integration with PHP's FPM service (see `lifegadget/docker-php` for a good FPM container) without adding bloat so you can ignore FPM if you choose to. Finally, it assumes that content for the site will be provided by the host environment rather than being built into the container.

## Usage ##

- **Basic usage:**
	
		sudo docker run -d lifegadget/nginx -p 80:80 --link PHP:PHP

	This will get you up and running with a [default server configuration](https://github.com/lifegadget/docker-nginx/blob/master/resources/nginx.conf) and pointing to default content. Not very useful but a way to see it working in conjunction with your PHP/FPM stack. To see a basic static page just point your browser to `http://localhost`. If you are using PHP then the following resource is available:

	- `/fpm` - this should show that you have proper integration to your php/fpm service by executing the `index.php` in your PHP/FPM content's root. If you are using the default configuration of the **lifegadget/docker-php** docker container then you'll get back the familiar output of PHP's `phpinfo()`.
		> Note: the default config of **lifegadget/docker-php** also provides `/fpm/status` as a path to the FPM status page

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
