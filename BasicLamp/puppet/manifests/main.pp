class { 'apache':
  mpm_module => 'prefork'
}

apache::vhost { 'lesharris.dev':
  port    => '80',
  docroot => '/var/www/lesharris',
}

# Install extensions; Configure extensions; Reload apache if changed
Package['php5-dev'] -> Php::Extension <| |> -> Php::Config <| |> ~> Service["apache2"]

include php
include php::composer

class {
  'php::cli':;
  'php::pear':;
  'php::dev':;
  'php::extension::apc':;
  'php::extension::xdebug':;
  'php::extension::mcrypt':;
}

class { '::mysql::server':
  root_password    => 'welcome1',
  override_options => { 'mysqld' => { 'max_connections' => '1024' } }
}

class {
  'php::extension::mysql':;
}

include apache::mod::php