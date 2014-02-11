conqueso-chef
=============

The chef cookbook for deploying conqueso.

This cookbook has three options in mind for the end user:

1 - Standalone developer of the cookbook

2 - Someone who is preparing images (either AMIs or VMs etc) and has a remote database 

3 - A developer of both the server and the cookbook (so someone who wants to grab the latest code from source control)


Attributes
----------
* `['conqueso']['sha256sum']` - The output of a sha256sum of the conqueso server zip file to prevent redownloads during convergence.
* `['conqueso']['version']` - The version of the conqueso server to download.
* `['conqueso']['http']['port']` - The port the conqueso server runs on.
* `['conqueso']['db']['type']` - The type of the backend to use (CASE SENSITIVE!).
* `['conqueso']['db']['host']` - The hostname or ipaddress where the host can be found.
* `['conqueso']['db']['port']` - The port your backend is listening on.
* `['conqueso']['db']['databaseName']` - The name of the database conqueso should use.
* `['conqueso']['db']['user']` - The db user the conqueso server should connect as.
* `['conqueso']['db']['password']` - The password for the user you're connecting as.
* `['conqueso']['pollintervalsecs']` - The polling interval it should use.
* `['conqueso']['logging']['dir']` - The directory that will contain the conqueso log file.
* `['conqueso']['logging']['file']` - The log file name it should use.
* `['conqueso']['logging']['level']` - The log level conqueso should run at.
* `['conqueso']['install']['mysqlserver']` - Should we install the mysql server.
* `['conqueso']['install']['mysqlclient']` - Should we install the mysql client.
* `['conqueso']['start']` - Post installation, should conqueso be started.
