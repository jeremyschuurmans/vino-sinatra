# Welcome to Vino!

Vino is about good wine and good friends. It is a social wine journal that allows you to keep a record of wines you love, and share them with others. It is built in Ruby and utilizes Sinatra, ActiveRecord, BootstrapCDN (as well as custom HTML and CSS), and bcrypt.


## Installation


Clone this repo to your machine, cd into the appropriate directory, run ``bundle install`` to install required gems, and you should be good to go. Vino has a thorough test suite, so you can optionally run ``rspec`` to make sure all tests are passing before attempting to use.


## To Run Locally


Run ``shotgun`` in root directory. The default port is 9393.

Open your browser and navigate to http://localhost:9393/. Application landing page will appear.


## File Structure


``config.ru`` - Specifies files to use and run.

``/config`` - Contains ``environment.rb``, which establishes database connection.

``/app`` - Contains Sinatra MVC files for app.

``/db`` - Contains database and migration files.

``/public`` - Contains custom CSS and UI assets.


## Routes and Features


``/`` - Landing page, will direct you to log in or sign up.

``/wines`` - Shows all wines created by all users.

``/wines/new`` - Shows a form for creating new wine entries. Once a user creates a wine, they are redirected to the main show page.

``/wines/edit`` - Shows a form for editing a wine entry.

``/users/show`` - User profile page. Shows all wines created by user, and includes links to delete or edit wine entries.


## Contributing


Bug reports and pull requests are welcome on GitHub at https://github.com/JMSchuurmans/vino or by email to schuurm@ns.codes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License


The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


## Disclaimer


Vino is a personal student project and as such is intended solely for educational purposes. I have made efforts to follow fair use guidelines in my use of all material under copyright.
