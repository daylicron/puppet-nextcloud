class nextcloud::install (
  String $version   = $nextcloud::version,
  String $nc_source = $nextcloud::nc_source,
  String $web_path  = $nextcloud::web_path,
  String $web_user  = $nextcloud::web_user,
  String $web_group = $nextcloud::web_group,
){
  #### Ensure directory path exist where nextcloud should be deployed
  file { $web_path:
    ensure => directory,
    owner  => $web_user,
    group  => $web_group,
    mode   => '0750',
  }

  file { "${web_path}/nextcloud_${version}":
    ensure  => directory,
    owner   => $web_user,
    group   => $web_group,
    mode    => '0750',
    require => File[$web_path],
  }

  #### Donwload und unzip nextcloud zip file
  archive { "install_nextcloud_${version}":
    path         => "/tmp/nextcloud-${version}.zip",
    source       => "${nc_source}/nextcloud-${version}.zip",
    extract      => true,
    extract_path => "${web_path}/nextcloud_${version}",
    creates      => "${web_path}/nextcloud_${version}/nextcloud",
    user         => $web_user,
    group        => $web_group,
    require      => File["${web_path}/nextcloud_${version}"],
  } -> file { "${web_path}/nextcloud":
    ensure => 'link',
    target => "${web_path}/nextcloud_${version}/nextcloud",
  }
}
