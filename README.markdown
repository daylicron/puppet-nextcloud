# nextcloud

#### Table of contents

1. [Overview](#overview)
2. [Module Description - What the module does](#module-description)
3. [Setup - The basics of getting started with nextcloud](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nextcloud](#beginning-with-nextcloud)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Initial installation](#initial-installation)
    * [Configure your instance](#configure-your-instance)
    * [Use auto upgrade](#use-auto-upgrade)
    * [Install plugins](#install-plugins)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

<a id="overview"></a>
## Overview

The nextcloud module lets you install, configure and update a nextcloud instance. 

<a id="module-description"></a>
## Module description

This module can install a blank nextcloud without any configuration. It can in addition configure your nextcloud, do the first installation and install plugins. The scope is to maintain a nextcloud instance autonomous.

<a id="setup"></a>
## Setup

<a id="setup-requirements"></a>
### Setup requirements

This module depends on the following puppet modules:

Cloning git repositories: https://forge.puppet.com/puppetlabs/vcsrepo

Unzip nextcloud archives: https://forge.puppet.com/puppet/archive

Useful things: https://forge.puppet.com/puppetlabs/stdlib

<a id="beginning-with-nextcloud"></a>
### Beginning with nextcloud

Let's start with a blank nextcloud installation, doing no configuration at all:

~~~ puppet
class { 'nextcloud':
  version => '16.0.0',
}
~~~

<a id="usage"></a>
## Usage

All parameters can be provided via hiera too. For a full list of all parameters, see the init.pp.

You can configure you're nextcloud on different levels:

<a id="initial-installation"></a>
### Initial installation

When you're doing an initial installation from scratch, you can skip the installer if you like:

~~~ puppet
class { 'nextcloud':
  version          => '16.0.0',
  skip_nc_install  => false,
  ac_db_type       => 'mysql',
  ac_db_name       => 'nextcloud',
  ac_db_user       => 'nextcloud',
  ac_db_password   => 'yourpasswordgoeshere',
  ac_db_host       => 'localhost'
  ac_adminuser     => 'admin',
  ac_adminpw       => 'yourpasswordgoeshere',
  ac_datadirectory =>  '/mnt/storage/nextcloud_data',
}
~~~

<a id="configure-your-instance"></a>
### Configure your instance

You can configure your instance as if you would edit your config.php. Meaning you can provide every key and value pair you like inside the nc_conifg hash. Due to reasons I had to seperate the trust_domains configurarion. Nextcloud itself wants this in a particular structure which can only be provided when this option is seperated.

~~~ puppet
class { 'nextcloud':
  version          => '16.0.0',
  nc_config => {
    'datadirectory' => '/mnt/storage/nextcloud_data',
    'dbtype' => 'mysql',
    'dbhost' => 'localhost',
    'dbname' => 'nextcloud',
    'dbuser' => 'nextcloud',
    'dbpassword' => 'yourpasswordgoeshere',
  },
  nc_trust_domains => {
    0: 'yoururlgoeshere'
    1: 'maybeyouripgoeshere'
  },
}
~~~

<a id="use-auto-upgrade"></a>
### Use auto upgrade

You can let puppet upgrade your nextcloud instance when you deploy a new version.

~~~ puppet
class { 'nextcloud':
  version          => '16.0.0',
  auto_upgrade     => true,
  nc_config        => {
    'datadirectory' => '/mnt/storage/nextcloud_data',
    'dbtype' => 'mysql',
    'dbhost' => 'localhost',
    'dbname' => 'nextcloud',
    'dbuser' => 'nextcloud',
    'dbpassword' => 'yourpasswordgoeshere',
  },
  nc_trust_domains => {
    0: 'yoururlgoeshere'
    1: 'maybeyouripgoeshere'
  },
}
~~~

<a id="install-plugins"></a>
### Install plugins

!!Be aware that the official github source needs to be provided in the params.pp for this.!!

Last but not least you can install plugins too. You only need to provide the official name and version tag.

~~~ puppet
class { 'nextcloud':
  version          => '16.0.0',
  auto_upgrade     => true,
  nc_config        => {
    'datadirectory' => '/mnt/storage/nextcloud_data',
    'dbtype' => 'mysql',
    'dbhost' => 'localhost',
    'dbname' => 'nextcloud',
    'dbuser' => 'nextcloud',
    'dbpassword' => 'yourpasswordgoeshere',
  },
  nc_trust_domains => {
    0: 'yoururlgoeshere'
    1: 'maybeyouripgoeshere'
  },
  plguins          => {
    calendar => 'v1.7.0',
    contacts => 'v3.1.1',
  },
}
~~~

<a id="limitations"></a>
## Limitations

Unfortunately nextcloud is not easy to automate. Lot's of stuff is configured inside the config.php. This file is edited by nextcloud itself, administrators using the webinterface and now puppet. 

This leads to some special cases and things that have to be taken care of.

1. As mentioned before, the trust_domains parameter has to be seperated vom the nc_config hash.
2. When you provide config using the nc_config hash, you must provide the nextcloud version again. Otherwise you will run into trouble.
2.1 The worst thing about this is, that the version inside the config.php cannot be predicted, at least I found no way. This means:
When you provide '16.0.0' inside the nc_config hash as version and you do a php occ upgrade, then nextcloud will change this version to something like: '16.0.0.9'. Afterwards you must provide this new version via puppet inside the nc_config hash. Otherwise puppet will revert the version to '16.0.0' and the nextcloud webinterface forces you to rerun the upgrade.
3. Unfortunately you need to check for the different app version tags for yourself. VCSrepo does not provide an option to download the latest tag. Building this process with execs felt too ugly for me.

<a id="development"></a> 
## Development

This is my first own public puppet module. Any pull requests are very welcome. :)