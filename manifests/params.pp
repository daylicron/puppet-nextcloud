class nextcloud::params {
  #### Define Users and Groups
  case $facts['os']['family'] {
    'Debian': {
      $web_user  = 'www-data'
      $web_group = 'www-data'
    }
    'RedHat': {
      $web_user  = 'apache'
      $web_group = 'apache'
    }
    default: {
      fail('Currently Nextcloud Module only supports Debian and Redhat based Distros.')
    }
  }

  #### Nextcloud source
  $nc_source = 'https://download.nextcloud.com/server/releases'

  #### Define Paths
  $web_path = '/var/www'

  #### Plugin Sources
  $plugin_sources = {
    calendar_source => 'https://github.com/nextcloud/calendar.git',
    contacts_source => 'https://github.com/nextcloud/contacts.git',
    richdocuments_source => 'https://github.com/nextcloud/richdocuments.git',
    notes_source => 'https://github.com/nextcloud/notes.git',
    polls_source => 'https://github.com/nextcloud/polls.git',
    preview_source => 'https://github.com/rullzer/previewgenerator.git',
    unsplash_source => 'https://github.com/jancborchardt/unsplash.git',
  }
}
