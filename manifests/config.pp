class psacct::config (
  $enabled,
  $logging,
  $etc_default
) {
  if $etc_default == true {
    $_enabled = bool2num($enabled)

    augeas { 'etc_default_acct':
      incl    => '/etc/default/acct',
      lens    => 'Shellvars.lns',
      context => '/files/etc/default/acct/',
      changes => [
        "set ACCT_ENABLE  '\"${_enabled}\"'",
        "set ACCT_LOGGING '\"${logging}\"'"],
    }
  }
}
