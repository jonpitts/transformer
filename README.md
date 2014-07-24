Transformer Service
===================
An experimental sinatra based web-service that transforms excel generated xml files into mods format.

Excel has been a popular tool for cataloging library meta-data.  
It is much better to store this type of data in xml following a schema.
Mods is one particular schema for doing this.

General Operation:
------------------
  
  * Transformer uses sqlite and comes with a simple setup script.
  * The default login is admin:admin.
  * The admin user may create logins and assign admin designations.
  * The service allows multiple users to be logged in with each users own working space.
  * The service assumes xml files passed to it are created from excel exports.
  * All temp space is cleared upon service exit.
  
Transformation:
---------------
  * Transformer comes with sample xml files.
  * Each <row> element will generate a new xml file in mods format.
  * Each xml file will be validated against the mods schema.
  * A collection will be created and stored in a zip file and posted to the GUI.
  * A list of errors are generated when there are problems and populated to the GUI.
  * A hash of mods tag associations are definable per user and saved to the database.
  
  
Ruby Requirements:
------------------
  * ruby 1.9.3
  * sinatra
  * nokogiri
  * uuid
  * data_mapper
  * dm-sqlite-adapter
  * rubyzip
  
Other Requirements:
-------------------
  * sqlite3
  
Reasons for this project
------------------------
  * Provide a web-service for converting xml into mods.
  * Simplify process of converting xml files into mods.
    * Typically transformations require stylesheets and can be difficult to maintain.
    * Transformer relies on erb templates instead which can be modified and added to.
  