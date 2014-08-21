Transformer Service
===================
A sinatra based web-service that transforms excel files into mods format.
AngularJS used for much of the front end.

Excel has been a popular tool for cataloging library meta-data.  
It is much better to store this type of data in xml following a schema.
Mods is one particular schema for doing this.

Quick Setup:
------------
  * `bundle install --path bundle`
  * `bundle exec ruby setup.rb`
    * setup will attempt to backup a db if it sees one and will complain if it sees you have not moved a backup.
  * `bundle exec ruby app.rb`
  * navigate your browser to 0.0.0.0:4567
    * login with user: `admin` & password: `admin`
  * a sample test file is included in the public folder
    * check notes section

General Operation:
------------------
  * Transformer has been overhauled.
    * The service now takes excel files.
    * Conversion is handled by a java application included with this service
  * Transformer uses sqlite and comes with a simple setup script.
  * The default login is admin:admin.
  * The admin user may create logins and assign admin designations.
  * The service allows multiple users to be logged in with each users own working space.
  * All temp space is cleared upon service exit.
  
Transformation:
---------------
  * An excel file is sent to the service
  * Excel is converted into an xml format
  * Each `<row>` element of this converted file will generate a new xml file in mods format.
  * Each xml file will be validated against the mods schema.
  * A collection will be created and stored in a zip file and posted to the GUI.
  * A list of errors are generated when there are problems and populated to the GUI.
  * A hash of mods tag associations are definable per user and saved to the database.
  
  
Ruby Requirements:
------------------
  * ruby 1.9.3
  * bundler
    * sinatra
    * nokogiri
    * uuid
    * data_mapper
    * dm-sqlite-adapter
    * rubyzip
    * rack
    * thin
  
Other Requirements:
-------------------
  * sqlite3
  * a jvm
  
Reasons for this project
------------------------
  * Provide a web-service for converting excel into xml following mods format.
  * Simplify process of converting xml files into mods.
    * Typically transformations require stylesheets and can be difficult to maintain.
    * Transformer now uses xml node manipulation for creating the mods xml.
    
Notes - Issues - TODO
--------------------
  * New code changes uses mutex to solve resource problems.
    * Ruby 1.9.3 has problems when multiple threads are both inside chdir blocks.
    * Shared resources such as the included java app create conflicts
  * Ruby gem 'roo' has an api for reading excel spreadsheets.  Will need to investigate.
  * Moved the angular test page as the main content page.
    * Older view still available as 'Alternate Page' link
    * Angular will not work for 100% of users but otherwise is really nice.
  * Browsers can duplicate ajax requests. Discovered this when quickly submitting packages from firefox.
    * Will use a nonce to stop this behavior
    * Using a nonce is good in practice to prevent replay attacks also
    * Work needed to mitigate this from the UI
  * included test file
    * the test file was created by one of our local libraries
    * you will need to update the mods definitions from the gui in order to process the file
      * this illustrates one of the types of errors that come from attempting a transformation
  * I intend to upload a sample template excel file that can be used with this service
    * it will have excel column headers similar to
    * `filename IID title title-alternate etc...`
    