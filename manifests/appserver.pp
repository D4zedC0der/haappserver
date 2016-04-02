class haappserver::appserver (

  $app_user   = $::haappserver::params::app_user,
  $app_group  = $::haappserver::params::app_group,
  $user_shell = $::haappserver::params::user_shell,
  $app_root   = $::haappserver::params::app_root,
  $web_root   = $::haappserver::params::web_root,
  $listen_port = $::haappserver::params::listen_port,

) inherits ::haappserver::params {

  include golang

  group { "$::haappserver::appserver::app_group":
    ensure => "present",
  }

  user { "$::haappserver::appserver::app_user":
    ensure     => "present",
    groups     => "$::haappserver::appserver::app_group",
    shell      => "$::haappserver::appserver::user_shell",
    managehome => true,
    require    => Group["$::haappserver::appserver::app_group"],
  }

  file { "$::haappserver::appserver::app_root":
    ensure   => "directory",
    owner    => "$::haappserver::appserver::app_user",
    group    => "$::haappserver::appserver::app_group",
    mode     => "750",
    require  => [Group["$::haappserver::appserver::app_group"], User["$::haappserver::appserver::app_user"]],
  }

  file { "$::haappserver::appserver::app_root/get_hostname.go":
    ensure     => "file",
    owner      => "$::haappserver::appserver::app_user",
    group      => "$::haappserver::appserver::app_group",
    mode       => "750",
    content    => template ("haappserver/appserver/get_hostname.go"),
    require    => [ Group["$::haappserver::appserver::app_group"], User["$::haappserver::appserver::app_user"], File["$::haappserver::appserver::app_root"] ],
  }

  class { 'firewall': }

  firewall { '123 open port for app':
    dport => "$::haappserver::appserver::listen_port",
    proto => "tcp",
    action => "accept",
  }


}
