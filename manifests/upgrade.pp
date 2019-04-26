class nextcloud::upgrade (
  String $version       = $nextcloud::version,
  String $web_path      = $nextcloud::web_path,
  String $web_user      = $nextcloud::web_user,
  String $web_group     = $nextcloud::web_group,
  Boolean $auto_upgrade = $nextcloud::auto_upgrade,
){
  if $auto_upgrade {
    #### Define Variables
    $nc_path = "${web_path}/nextcloud_${version}/nextcloud"

    #### Perform Upgrade
    exec { 'nc_own_dir':
      path        => '/usr/bin:/usr/sbin:/bin',
      command     => "chown -R ${web_user}:${web_group} ${nc_path}",
      refreshonly => true,
      subscribe   => Archive["install_nextcloud_${version}"],
    } ~> exec { 'nc_dir_perm':
      path        => '/usr/bin:/usr/sbin:/bin',
      command     => "find ${nc_path} -type d -exec chmod 750 {} \;",
      refreshonly => true,
    } ~> exec { 'nc_file_perm':
      path        => '/usr/bin:/usr/sbin:/bin',
      command     => "find ${nc_path} -type f -exec chmod 640 {} \;",
      refreshonly => true,
    } ~> exec { 'nc_do_upgrade':
      path        => "${nc_path}:/usr/bin:/usr/sbin:/bin",
      cwd         => $nc_path,
      command     => "sudo -u ${web_user} php occ upgrade",
      logoutput   => true,
      refreshonly => true,
    }
  }
}
