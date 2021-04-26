mkdir myserver

cd myserver

git clone .....

# if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#         # ...
# elif [[ "$OSTYPE" == "darwin"* ]]; then
#         # Mac OSX
# elif [[ "$OSTYPE" == "cygwin" ]]; then
#         # POSIX compatibility layer and Linux environment emulation for Windows
# elif [[ "$OSTYPE" == "msys" ]]; then
#         # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
# elif [[ "$OSTYPE" == "win32" ]]; then
#         # I'm not sure this can happen.
# elif [[ "$OSTYPE" == "freebsd"* ]]; then
#         # ...
# else
#         # Unknown.
# fi




sudo apt update && sudo apt install nodejs

npm install

npm install @types/node
npm install @types/express


npm install typescript 

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
    #if you need to install docker :

        #https://docs.docker.com/engine/install/ubuntu/
            # sudo apt-get update

            # sudo apt-get install docker-ce docker-ce-cli containerd.io



# touch Dockerfile

# echo "FROM node:14" > Dockerfile
# echo "WORKDIR /app" > Dockerfile
# echo "COPY . ." > Dockerfile
# echo "RUN npm install" > Dockerfile
# echo "EXPOSE 3005" > Dockerfile
# echo "CMD [ "npm", "start" ]" > Dockerfile

# touch .dockerignore

# echo "node_modules" > .dockerignore
# echo "npm-debug.log" > .dockerignore

# cat .dockerignore

docker build . -t node-azure-web-app 

docker run -it -p 3005:3005 --name azure -d node-azure-web-app



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