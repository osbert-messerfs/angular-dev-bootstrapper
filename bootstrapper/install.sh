#!/bin/bash
if [ $1 ]; then
	appName=$1
else
	appName=demo
fi

echo [BOOTSTRAPPER] App Name: $appName

scriptDirectory=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
rootDirectory=$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )
appDirectory=$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )/$appName
echo [BOOTSTRAPPER] App Directory: $appDirectory
cd $rootDirectory

echo [BOOTSTRAPPER] Installing Express...
express --ejs $appName



echo [BOOTSTRAPPER] Remove unnecessary files...
rm -rf $appDirectory/public/images
rm -rf $appDirectory/public/javascripts
rm -rf $appDirectory/public/stylesheets
rm -rf $appDirectory/routes

echo [BOOTSTRAPPER] Copying package.json, Gruntfile.js, bower.json
cp $scriptDirectory/package.json $appDirectory/package.json
cp $scriptDirectory/Gruntfile.js $appDirectory/Gruntfile.js
cp $scriptDirectory/bower.json $appDirectory/bower.json
mkdir -p $appDirectory/scripts
cp $scriptDirectory/scripts/watch.bat $appDirectory/scripts/watch.bat
cp $scriptDirectory/scripts/nodemon.bat $appDirectory/scripts/nodemon.bat
mkdir -p $appDirectory/src/html
mkdir -p $appDirectory/src/js
mkdir -p $appDirectory/src/css
cp $scriptDirectory/app.js $appDirectory/app.js
cp $scriptDirectory/main/html/index.html $appDirectory/src/html/index.html
cp $scriptDirectory/main/js/app.js $appDirectory/src/js/app.js
cp $scriptDirectory/main/js/heroic.js $appDirectory/src/js/heroic.js
cp $scriptDirectory/main/css/style.css $appDirectory/src/css/style.css
find $appDirectory/src -type d -exec chmod 755 {} \;
find $appDirectory/src -type f -exec chmod 666 {} \;

echo [BOOTSTRAPPER] Entering App Directory and install npm
cd $appDirectory
npm install
echo [BOOTSTRAPPER] install bower
bower install

echo [BOOTSTRAPPER] call grunt bowercopy
grunt bowercopy

echo [BOOTSTRAPPER] copy htmls
grunt copy:html
grunt copy:css
grunt uglify:js
