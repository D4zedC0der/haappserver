class haappserver::nginxlb (

  $nginx_docroot   = $::haappserver::params::nginx_docroot,
  $web_listen_port = $::haappserver::params::web_listen_port,
  $pool_members    = $::haappserver::params::pool_members,

) inherits ::haappserver::params {

  class { 'nginx': }

  nginx::resource::upstream { 'display_serving_host':
    members => $::haappserver::nginxlb::pool_members,
  }

  nginx::resource::location { "$::haappserver::nginxlb::web_root":
    proxy => 'http://display_serving_host/' ,
    vhost => 'webhead',
  }

  nginx::resource::vhost {'webhead':
    www_root                 => "$::haappserver::nginxlb::nginx_docroot",
    listen_port              => "$::haappserver::nginxlb::web_listen_port",
    use_default_location     => false,
  }

  class { 'firewall': }

  firewall { '123 open port for web':
    dport => "$::haappserver::nginxlb::web_listen_port",
    proto => "tcp",
    action => "accept",
  }


}
