#!/bin/bash

PS3='Please enter your choice: '
options=("First build of Wekan" "Pull latest changes and rebuild" "Rebuild Wekan only" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "First build of Wekan")
            echo "Installing Wekan dependencies."
            #sudo rm -rf /usr/local/lib/node_modules
            #sudo rm -rf ~/.npm
            # g++
            #-------
            sudo apt -y install build-essential capnproto npm git curl
            sudo npm -g install n
            ## Using Node.js 6.12 with Meteor 1.6
            sudo n 6.12
            ## Latest npm with Meteor 1.6
            sudo npm -g install npm@5.6.0
            sudo npm -g install node-gyp
            #sudo npm -g install node-pre-gyp
            # Latest fibers with Meteor 1.6
            sudo npm -g install fibers@2.0.0
            # You need to install Meteor, if it's not yet installed
            curl https://install.meteor.com | bash
            mkdir ~/repos
            cd ~/repos
            git clone https://github.com/wekan/wekan.git
            cd wekan
            git checkout meteor-1.6
            break
            ;;
        "Pull latest changes and rebuild")
            echo "Pulling latest changes."
            cd ~/repos/wekan
            git pull
            cd ~/repos
            break
            ;;
        "Rebuild Wekan only")
            echo "Building Wekan."
            #cd ~/repos/wekan
            #mkdir -p ~/repos/wekan/packages
            #cd ~/repos/wekan/packages
            #rm -rf kadira-flow-router
            #rm -rf meteor-useraccounts-core
            #git clone https://github.com/wekan/flow-router.git kadira-flow-router
            #git clone https://github.com/meteor-useraccounts/core.git meteor-useraccounts-core
            #sed -i 's/api\.versionsFrom/\/\/api.versionsFrom/' ~/repos/wekan/packages/meteor-useraccounts-core/package.js
            cd ~/repos/wekan
            rm -rf node_modules
            meteor npm install
            rm -rf .build
            meteor build .build --directory
            cp -f fix-download-unicode/cfs_access-point.txt .build/bundle/programs/server/packages/cfs_access-point.js
            sed -i "s|build\/Release\/bson|browser_build\/bson|g" ~/repos/wekan/.build/bundle/programs/server/npm/node_modules/meteor/cfs_gridfs/node_modules/mongodb/node_modules/bson/ext/index.js
            sed -i "s|build\/Release\/bson|browser_build\/bson|g" ~/.meteor/packages/cfs_gridfs/.0.0.33.jt3hlz.gcqsl++os.linux.x86_64+web.browser+web.cordova/npm/node_modules/mongodb/node_modules/bson/ext/index.js
            cd ~/repos/wekan/.build/bundle/programs/server/npm/node_modules/meteor/npm-bcrypt
            rm -rf node_modules/bcrypt
            meteor npm install bcrypt
            #meteor npm install --save bcrypt
            cd ~/repos/wekan/.build/bundle/programs/server
            rm -rf node_modules
            meteor npm install
            meteor npm install bcrypt
            #meteor npm install --save bcrypt
            cd ~/repos
            echo Done.
            break
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
