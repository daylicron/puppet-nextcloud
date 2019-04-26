# Class: nextcloud
# ===========================
#
# Class to install and update a Nextcloud instance.
#
# Parameters
# ----------.
#
# * `version` [String]
# Specify the nextcloud version you want to use
#
# * `nc_source` [String]
# Specify the url to download the nextcloud zip from
#
# * `auto_upgrade` [Boolean]
# Specify if puppet should upgrade your nextcloud instance during version bump
#
# * `web_user` [String]
# Specify the runuser of your webserver
#
# * `web_group` [String]
# Specify the rungroup of your webserver
# 
# * `web_path` [String]
# Specify the directory you would like to put nextcloud
#
# * `nc_config_path` [String]
# Specify the path to your Nextcloud config file
#
# * `skip_nc_install` [Boolean]
# Specify if you would like to skip Nextcloud installer by using autoconfig.php
# (requires $ac_* parameters)
#
# * `ac_db_type` [String]
# Specify your database type for autoconfig
#
# * `ac_db_name` [String]
# Specify your database name for autoconfig
#
# * `ac_db_user` [String]
# Specify your database user for autoconfig
#
# * `ac_db_password` [String]
# Specify your database password for autoconfig
#
# * `ac_db_host` [String]
# Specify your database host for autoconfig
#
# * `ac_adminuser` [String]
# Specify your admin username for autoconfig
#
# * `ac_adminpw` [String]
# Specify your admin user password for autoconfig
#
# * `ac_datadirectory` [String]
# Specify your Nextcloud data directory for autoconfig
#
# * `nc_config` [Hash]
# Specify your Nextcloud config
#
# * `nc_trust_domains` [Hash]
# Specify the trusted nextcloud domains for the nextcloud config
#
# * `redis` [Boolean]
# Set to true, when you use redis and want to configure it
#
# * `redis_config` [Hash]
# Specify your redis config
#
# * `plugins` [Hash]
# Specify your plugins, including github version tag, for initial setup or upgrade
#
#
# Examples
# --------
# @initial installation 
#    class { 'nextcloud':
#      version          => '16.0.0',
#      skip_nc_install  => false,
#      ac_db_type       => 'mysql',
#      ac_db_name       => 'nextcloud',
#      ac_db_user       => 'nextcloud',
#      ac_db_password   => 'yourpasswordgoeshere',
#      ac_db_host       => 'localhost'
#      ac_adminuser     => 'admin',
#      ac_adminpw       => 'yourpasswordgoeshere',
#      ac_datadirectory =>  '/mnt/storage/nextcloud_data',
#    }
#
# @save your config 
#    class { 'nextcloud':
#      version   => '16.0.6',
#      nc_config => {
#       'datadirectory' => '/mnt/storage/nextcloud_data',
#       'dbtype' => 'mysql',
#       'dbhost' => 'localhost',
#       'dbname' => 'nextcloud',
#       'dbuser' => 'nextcloud',
#       'dbpassword' => 'yourpasswordgoeshere',
#      },
#    }
#
# Authors
# -------
#
# daylicron@github
#
#
class nextcloud (
  String $version,
  String $nc_source                    = $nextcloud::params::nc_source,
  Boolean $auto_upgrade                = false,
  String $web_user                     = $nextcloud::params::web_user,
  String $web_group                    = $nextcloud::params::web_group,
  String $web_path                     = $nextcloud::params::web_path,
  Boolean $skip_nc_install             = false,
  Optional[String] $ac_db_type         = undef,
  Optional[String] $ac_db_name         = undef,
  Optional[String] $ac_db_user         = undef,
  Optional[String] $ac_db_password     = undef,
  Optional[String] $ac_db_host         = undef,
  Optional[String] $ac_db_table_prefix = undef,
  Optional[String] $ac_adminuser       = undef,
  Optional[String] $ac_adminpw         = undef,
  Optional[String] $ac_datadirectory   = undef,
  Optional[Hash] $nc_config            = undef,
  Optional[Hash] $nc_trust_domains     = undef,
  Optional[Boolean] $redis             = false,
  Optional[Hash] $redis_config         = undef,
  Optional[Hash] $plugins              = undef,
) inherits nextcloud::params {
  include nextcloud::install
  include nextcloud::plugins
  include nextcloud::config
  include nextcloud::upgrade

  Class['nextcloud::install']
  -> Class['nextcloud::plugins']
  -> Class['nextcloud::config']
  -> Class['nextcloud::upgrade']
}
