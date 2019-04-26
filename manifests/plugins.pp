class nextcloud::plugins (
  Hash $plugins        = $nextcloud::plugins,
  Hash $plugin_sources = $nextcloud::params::plugin_sources,
  String $nc_version   = $nextcloud::version,
  String $web_path     = $nextcloud::web_path,
) {
  #### Clone Plugins from Git Source to App Directory
  unless empty($plugins) {
    $plugins.each |$plugin, $version| {
      vcsrepo { "clone_plugin_${plugin}":
        ensure   => present,
        path     => "${web_path}/nextcloud_${nc_version}/nextcloud/apps/${plugin}",
        provider => git,
        source   => $plugin_sources["${plugin}_source"],
        revision => $version,
      }
    }
  }
}
