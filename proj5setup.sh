#!/bin/bash
# Created by Stephan Kaminsky to help with the setup of project 5 :D
echo -e "-------------------------------------\n|Project 5 Setup by Stephan Kaminsky|\n-------------------------------------\n"
echo "[INPUT]: Please enter your Bitbucket Login:"
read -p ">" bblogin
echo -e "\n[INPUT]: Please enter your Bitbucket Repo for the project (Ex: proj5-xxx). Do NOT add .git:"
read -p ">" bbrepo
baseaddr="bitbucket.org/"$bblogin
fulladdr=$baseaddr"/"$bbrepo
echo -e "\n[INPUT]: Please confirm that the information is correct. If it is not, exit the script and relaunch it!"
echo ""
echo $fulladdr
echo ""
read -n 1 -p "Press any key to continue..."
echo "[INFO]: Running go setup... (This may take a while)"
go get github.com/61c-teach/sp18-proj5
echo "[INFO]: Going into the staff project directory..."
cd $GOPATH/src/github.com/61c-teach/sp18-proj5
echo "[INFO]: Setting up the environment."
source env.sh
echo "[INFO]: Testing the starter code to confirm everything is working..."
go test
echo "[INFO]: You can ignore any warnings. Just confirm that it passed."
echo "[INFO]: Setting up your directory..."
mkdir -p $GOPATH/src/$baseaddr
echo "[INFO]: Going to your directory..."
cd $GOPATH/src/$baseaddr
if [ -d "$bbrepo" ]; then
  rm -fr $bbrepo
fi
mkdir -p $bbrepo
echo "[INFO]: Going to your project directory..."
cd $bbrepo
echo "[INFO]: Downloading the starter files..."
wget https://inst.eecs.berkeley.edu/~cs61c/sp18/projs/05-01/proj5-starter.tar
echo "[INFO]: Unpacking the starter files..."
tar -xf proj5-starter.tar
echo "[INPUT]: Do you want to use ssh or https for accessing your git repo? Default is ssh. (ssh/https)"
read -p ">" originchoice
while [[ x$originchoice != xssh && x$originchoice != xhttps ]]
do
    echo "[ERROR]: Please ONLY enter either 'ssh' or 'https'!"
    read -p ">" originchoice
done
if [ "$originchoice" = "https" ]; then
    originrepo="https://"$bblogin"@"$fulladdr".git"
else
    originrepo="git@bitbucket.org:"$bblogin"/"$bbrepo".git"
fi
echo "[INFO]: Initializing repository $originrepo..."
#until git clone "https://"$bblogin"@"$fulladdr".git"; do sleep 1; done;
git init
git remote add origin $originrepo
echo "[INFO]: Making initial commit..."
git add --all
git commit -m "Initial commit"
echo "[INFO]: Pushing initial commit to master..."
until git push origin master; do sleep 1; done;
echo "[INFO]: Done!"
printf %"$COLUMNS"s |tr " " "-"
echo "[INFO]: Please note you will have to run 'source env.sh' every time you start a new session."
echo "[INFO]: To test your project, just run 'go test' in your project directory. You will get an output like this:"
printf %"$COLUMNS"s |tr " " "-"
go test
printf %"$COLUMNS"s |tr " " "-"
echo "[Success]: Setup is complete!"