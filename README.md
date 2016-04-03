# haappserver
Puppet code to make it easier to serve High Availability, scalable web pages.

## Classes
This module contains two main classes.
- haappserver::appserver
- haappserver::nginxlb

Use the `haappserver::appserver` for nodes where the application is to be deployed and the `haappserver::nginxlb` to install nginx on a node and configure it as a load balancer (round robin).

## Installation

To install this module, create a directory called "haappserver" in the modules directory of your puppet-server/master and clone/download the contents of this git repo to that location.

## Quick Start
Defaults are in place for all but one argument (pool_members) and so it is very easy to get up and running. Below is an example of the minimum configuration required in your "site.pp" or equiv.

```
node 'appserv1', 'appserv2' {
  class { "haappserver::appserver": }
}

node 'webhead' {

  class { "haappserver::nginxlb" :
    pool_members => ["appserv1:8080","appserv2:8080"]
  }

}
```

NB the defaults assume that your applications are binding to port 8080, yet the NGinx Load Balancer will listen on port 80 for inbound traffic by default. All of these defaults can be overridden.

Below is an example output from the basic/simple installation (above) using an application which simply reports the hostname of the application server used to serve the http request:

```
[root@pmaster manifests]# telnet webhead 80
Trying 192.168.0.22...
Connected to webhead.
Escape character is '^]'.
GET / HTTP/1.0

HTTP/1.1 200 OK
Server: nginx/1.8.1
Date: Sat, 02 Apr 2016 21:22:28 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 39
Connection: close

Hi there, This is served from appserv1!Connection closed by foreign host.
[root@pmaster manifests]# telnet webhead 80
Trying 192.168.0.22...
Connected to webhead.
Escape character is '^]'.
GET / HTTP/1.0

HTTP/1.1 200 OK
Server: nginx/1.8.1
Date: Sat, 02 Apr 2016 21:22:40 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 39
Connection: close

Hi there, This is served from appserv2!Connection closed by foreign host.
[root@pmaster manifests]# telnet webhead 80
Trying 192.168.0.22...
Connected to webhead.
Escape character is '^]'.
GET / HTTP/1.0

HTTP/1.1 200 OK
Server: nginx/1.8.1
Date: Sat, 02 Apr 2016 21:22:55 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 39
Connection: close

Hi there, This is served from appserv1!Connection closed by foreign host.
[root@pmaster manifests]#
```

## Class Details

### haappserver::appserver

This class will set up your application server and currently comes with (as a built in part of the module) an application to respond to an HTTP GET request with some text reporting the hostname of the application server. It will also open up firewall ports.

The class parameters are:
* `$app_user` - This is the name of the user who will own the app when it is deployed (defaults to appuser).
* `$app_group` - This is the group that the user will be part of (defaults to users).
* `$app_shell` - This is the users default shell (defaults to /bin/bash).
* `$app_root` - This is the location where the application will be deployed to (defaults to /var/www).
* `$listen_port` - This is the port that the application will bind to on the app servers (defaults to 8080). 

### haappserver::nginxlb

This class will set up a nginx webserver on the node. It will be configured to load balance between the `$pool_members` and listen on `$web_listen_port` (which will be allowed through the firewall).

The class parameters are:
* `$pool_members`    - This is a list of hosts/IP Addresses and ports through which to load balance, in a round robin fashion.
* `$web_listen_port` - This is the port with which nginx will listen on for end user connections.
* `$nginx_docroot`   - This is the nginx_docroot. It is largely irrelevant as we aren't serving content from this node, but is included so that it can be altered (e.g. to avoid a clash with other docroots).

