Transformer Service
===================
A sinatra based web-service that transforms Excel files into MODS format.
AngularJS used for much of the front end.

Excel has been a popular tool for cataloging library meta-data.  
It is much better to store this type of data in XML following a schema.
MODS is one particular schema for doing this.

[Transformer Wiki](https://github.com/jonpitts/transformer/wiki)

Quick Setup:
------------
  * `bundle install --path bundle`
  * `bundle exec ruby setup.rb`
    * setup will attempt to backup a db if it sees one and will complain if it sees you have not moved a backup.
  * `bundle exec ruby app.rb`
  * navigate your browser to 0.0.0.0:4567
    * login with user: `admin` & password: `admin`
  * files included in `public/test/`
    * template file for using right away
    * sample test files to test mapping and transformations


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
  * A hash of mods tag associations are definable per user and saved to the database.
    * User may reset tags to get new tag definitions and reset default associations
  
  * sample template file
    * a good starting point
    * red columns are required and blue are repeatable
      * other columns may be repeatable but probably not necessary
      * only one name primary in mods
      * mods validation will tell you if you created a problem, so experiment.
    * due to heuristic obstacles some columns need to follow others
      * name-personal-primary-date must follow name-personal-primary
    * this will help illustrate the type of information found in mods format
    * the red columns are typically top-level and required elements found in mods
      * filename is not mods but required for naming the transformations
  
Transformation:
---------------
  * An excel file is sent to the service
  * Excel is converted into an xml format
  * Each `<row>` element of this converted file will generate a new xml file in mods format.
  * Each xml file will be validated against the mods schema.
  * A collection will be created and stored in a zip file and posted to the GUI.
  * A list of errors are generated when there are problems and populated to the GUI.
  
Ruby Requirements:
------------------
  * ruby 1.9.3, ruby 2.0.0
  * bundler
    * sinatra
    * nokogiri
      * gem download is compatible with nix systems.
      * special installation with windows is required
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
  * installation works fine on nix systems
  * windows installation may require some extra attention with gem builds
    * personal experience with nokogiri on windows is not optimal
  
Reasons for this project
------------------------
  * Provide a web-service for converting excel into xml following mods format.
  * Simplify process of converting xml files into mods.
    * Typically transformations require stylesheets and can be difficult to maintain.
    * Transformer now uses xml node manipulation for creating the mods xml.
    
Notes - Issues - TODO
---------------------
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
  * Duplicate Column headers
    * Originally had users specify unique column headers.
    * Made some changes to handle duplicate column headers behind the scenes.
    * Duplicate column headers such as `subject` now generate output.
  * TODO - improve node building heuristics
  * TODO - check input size on mods associations and report problems to user
