# Request Tracker

Written by stakr GbR (Jan Sebastian Siwy, Martin Spickermann, Henning Staib GbR; http://www.stakr.de/)

Source: https://github.com/stakr/tracker

Tracks all requests of controllers including a module of this plugin into database.


## Integration

Just copy or symlink the migration in "db/migration" folder of your application.

  cd /path/to/your/application
  cd db/migration
  cp ../../vendor/plugins/tracker/db/migrate/20091103203420_create_tracker_requests.rb .

or

  cd /path/to/your/application
  cd db/migration
  ln -s ../../vendor/plugins/tracker/db/migrate/20091103203420_create_tracker_requests.rb .

Perform the migration.

Include the tracker module to your controller:

  include Stakr::Tracker::Controller

Copyright (c) 2009 stakr GbR (Jan Sebastian Siwy, Martin Spickermann, Henning Staib GbR), released under the MIT license
