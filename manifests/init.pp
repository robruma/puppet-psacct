class psacct (
  $enabled     = $psacct::params::enabled,
  $logging     = $psacct::params::logging,
  $etc_default = $psacct::params::etc_default,
  $logfile     = $psacct::params::logfile,
  $packages    = $psacct::params::packages,
  $service     = $psacct::params::service
) inherits psacct::params {

  validate_bool($enabled)
  validate_bool($etc_default)

  class { 'psacct::install':
    enabled  => $enabled,
    packages => $packages,
  }

  class { 'psacct::config':
    enabled     => $enabled,
    logging     => $logging,
    etc_default => $etc_default,
  }

  class { 'psacct::service':
    enabled => $enabled,
    service => $service,
    logfile => $logfile,
  }

  if $enabled {
    anchor { 'psacct::begin': ; }
      -> Class['psacct::install']
      -> Class['psacct::config']
      ~> Class['psacct::service']
      -> anchor { 'psacct::end': ; }
  } else {
    anchor { 'psacct::begin': ; }
      -> Class['psacct::service']
      -> Class['psacct::config']
      -> Class['psacct::install']
      -> anchor { 'psacct::end': ; }
  }
}
