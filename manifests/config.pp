class nextcloud::config (
  String $version                  = $nextcloud::version,
  String $web_path                 = $nextcloud::web_path,
  String $web_group                = $nextcloud::web_group,
  String $web_user                 = $nextcloud::web_user,
  Optional[Hash] $nc_config        = $nextcloud::nc_config,
  Optional[Hash] $nc_trust_domains = $nextcloud::nc_trust_domains,
  Optional[Boolean] $redis         = $nextcloud::redis,
  Optional[Hash] $redis_config     = $nextcloud::redis_config,
  Boolean $skip_nc_install         = $nextcloud::skip_nc_install,
) {
  #### Provide autoconfig if web installer should be skipped
  if $skip_nc_install {
    file { "${web_path}/nextcloud_${version}/nextcloud/config/autoconfig.php":
      ensure    => file,
      owner     => $web_user,
      group     => $web_group,
      mode      => '0640',
      show_diff => false,
      content   => epp('nextcloud/autoconfig.php.epp'),
    }
  }
  ## Ensure no autoconfig present otherwise
  else {
    file { "${web_path}/nextcloud_${version}/nextcloud/config/autoconfig.php":
      ensure => absent,
    }
  }

  #### Deploy nextcloud config only if config parameters are not empty
  unless empty($nc_config) and empty($nc_trust_domains) {
    file { "${web_path}/nextcloud_${version}/nextcloud/config/config.php":
      ensure  => file,
      owner   => $web_user,
      group   => $web_group,
      mode    => '0640',
      content => epp('nextcloud/config.php.epp')
    }
  }
}
