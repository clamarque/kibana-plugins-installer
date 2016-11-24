# kibana-plugins-installer
A short script for automatically install plugins for kibana 5   
##Quick start
This script allows to automatically install plugins for kibana. The architecture of kibana 5 is as follows:

/kibana-5.0.0-YOUR-OS/   
|-- bin   
|-- config   
|-- data   
|-- node   
|-- node_modules   
|-- optimize   
|-- plugins   
|-- src   
|-- webpackShims   
|-- ...   

For the script to work, you need to add two directories: **logs** and **plugins_backup** 

/kibana-5.0.0-YOUR-OS/   
|-- bin   
|-- config   
|-- data   
|-- **logs**   
|-- node   
|-- node_modules   
|-- optimize   
|-- plugins  
|-- **plugins_backup**   
|-- src   
|-- webpackShims   
|-- ...   

then run the command:   

`$ node kibana-plugins-installer.js`   

**NOTE:** Ideally, you must create a recurring task (crontab) to run this script every 1 minute for example.

##How to use

It is enough simply to deposit the archive which contains the plugin with as extension: .tmp.zip in the folder **plugins**   
The script go copy the archive with the current date in the folder **plugins_backup**. Then, this one, will rename the archive in .zip, remove the plugin (if existing) and install it.   
You can find the log of plugin in the folder **logs**

**NOTE:** Don't forget to change the path in the script and adapt the installation and removal commands (**cmdRemove**, **cmdInstall**) according to your environment !


