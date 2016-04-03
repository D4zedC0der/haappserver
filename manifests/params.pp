class haappserver::params {
  $app_user   = "appuser"
  $app_group  = "users"
  $user_shell = "/bin/bash"
  $app_root   = "/var/www"
  $web_root   = "/"
  $listen_port   = "8080"
  $nginx_docroot = "/var/www"
  $web_listen_port = "80"
  $pool_members = undef
}
