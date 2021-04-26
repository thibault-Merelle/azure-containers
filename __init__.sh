echo "--Welcome on init.sh --"
echo "In the next steps we going to set up our project together !!"


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "nice !! your work on linux !!! "
        ostype_packages="apt"
        node_type="nodejs"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "it's okay, osX detected , great !!"
        ostype_packages="brew"
        node_type="node"
elif [[ "$OSTYPE" == "win32" ]]; then
        echo "No solutions for Win32 yet =/"
else
        echo "Sorry i don't recognize your current OS"
        exit 1
fi


if [ -x "$(command -v docker)" ]; then
    echo "Update docker"
    sudo $ostype_packages update
    echo "installing nodejs"
    sudo $ostype_packages install $node_type
else
    echo "you must Install docker\nlet see : https://docs.docker.com/get-docker/"
    exit 1
fi

if [ -x "$(command -v az)" ]; then
    echo "Update azure-cli"
    sudo az update -y

else
    echo "you must Install azure-cli to continue\nlet see : https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli"
    exit 1
fi



npm install

npm install @types/node
npm install @types/express


npm install typescript 

touch .env

read -p "Whitch port yould you work with ? [80]" myPort
case ${myPort:0:1} in
    *[!0-9]*)
        echo "not a number"
        echo "bye"
        exit 1

    '' )
        echo "$myPort selected"
        echo "PORT=$myPort" > .env

    * )
        echo "port 80 selected"
        echo "PORT=80" > .env
esac

#touch src/app.ts


#---------set up ESlinter: ---------

npx tsc --init 
#then answer questions to set up ESint

npx eslint src/app.ts #execute eslint

npx eslint src/app.ts --fix #execute ESlint --fix

 #or with package commands :

 npm run lint #Eslint fixe


 #==> you have to set up rules in .eslintrc file



#--------Docker : --------

#localy


# touch Dockerfile

# echo "FROM node:14" >> Dockerfile
# echo "WORKDIR /app" >< Dockerfile
# echo "COPY . ." >> Dockerfile
# echo "RUN npm install" >> Dockerfile
# echo "EXPOSE 3005" >> Dockerfile
# echo "CMD [ "npm", "start" ]" >> Dockerfile

# touch .dockerignore

# echo "node_modules" >> .dockerignore
# echo "npm-debug.log" >> .dockerignore

# cat .dockerignore

docker build . -t node-azure-web-app 

docker run -it -p $myPort:$myPort --name azure -d node-azure-web-app



#--------azure container registry : --------

read -p "would you like to push your image now? [Y/n]" answer
case ${answer:0:1} in
    y|Y )
        echo Yes

    #--- push the image on azure---:

    # connection
    docker login registrytestad.azurecr.io 

    # give a tag to the image
    docker tag node-azure-web-app registrytestad.azurecr.io/node-azure-web-app

    # push the image on the registry
    docker push registrytestad.azurecr.io/node-azure-web-app 

    * )
        echo No
    echo "bye"
    exit 1;
esac







#--- pull image from azure: ----

#pulling image from azure container regiostry:
# redo connection if necessary

docker pull registrytestad.azurecr.io/node-azure-web-app 

#run the image in a docker container 
docker run -it -p 3005:3005 --name azure -d node-azure-web-appregistrytestad.azurecr.io/node-azure-web-app