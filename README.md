# OTBR - Virtual Appliance

[![Discord Channel](https://img.shields.io/discord/528117503952551936.svg?style=flat-square&logo=discord)](https://discord.gg/3NxYnyV)
[![GitHub issues](https://img.shields.io/github/issues/opentibiabr/canary)](https://github.com/opentibiabr/canary/issues)
[![GitHub pull request](https://img.shields.io/github/issues-pr/opentibiabr/canary)](https://github.com/opentibiabr/canary/pulls)
[![Contributors](https://img.shields.io/github/contributors/opentibiabr/canary.svg?style=flat-square)](https://github.com/opentibiabr/canary/graphs/contributors)
[![GitHub](https://img.shields.io/github/license/sircurse/otbr-va)](https://github.com/sircurse/otbr-va/blob/master/LICENSE)
![Pulls](https://img.shields.io/docker/pulls/sircurse/otbr-va)

## Project - OpenTibiaBR
OpenTibiaBR - Canary is a free and open-source MMORPG server emulator written in C++.

In the project's repo [Canary](https://github.com/opentibiabr/canary), you can see the repository history in the [releases](https://github.com/opentibiabr/canary/releases).

The [OpenTibiaBR - Global](https://github.com/opentibiabr/otservbr-global) was adapted to work with the source of the Canary, so it is the default datapack to be used with Canary distro.

The intention of this project is to serve as an automated image, including all packages, files and basic configurations that allows the deployment of the Canary server and to first run it smoothly.

To connect to the server and to take a stable experience, you can use [mehah's otclient](https://github.com/mehah/otclient) or [tibia client](https://github.com/dudantas/tibia-client/releases/latest) and if you want to edit something, check our [customized tools](https://majestyotbr.gitbook.io/opentibiabr/others/downloads/tools).

If you want edit the map, use the [own remere's map editor](https://github.com/opentibiabr/remeres-map-editor/).

You are subject to our code of conduct, read at [this link](https://github.com/opentibiabr/canary/blob/master/CODE_OF_CONDUCT.md).

### Getting **Started**

* **WARNING: PRE-REQUISITE IS TO HAVE BASIC KNOWLEDGE OF LINUX AND A DOCKER SERVER INSTALLED.**
* The container is based on Ubuntu 22.04, all the packages and necessary files was previoulsy configured.
* The deployment will require basic settings as IP addreses that will be set to your server if completele exposed.
* If running the server behind a reverse Proyx, then the IP address of your Proxy server will be used.
* The TCP port that will be configured to the HTTP(S) server needs to be previously opened.
* If running the the server with SSL enabled, it is required to have a copy of the key and certificates in order to setup the AAC server.
* The TCP ports 7171 and 7172 are mandatory to run the game protocol and needs to be previously opened.

### **Deployment of Docker Server in Ubuntu 22.04:**<br>
**LINK TO VIDEO TUTORIAL**<br>
[![IMAGE ALT TEXT](http://img.youtube.com/vi/ILST5P62924/0.jpg)](http://www.youtube.com/watch?v=ILST5P62924 "Docker server deployment")

```shell
sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg lsb-release
curl -sSL https://get.docker.com/ | CHANNEL=stable bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
```

### **Deployment of Portainer:**<br>
**LINK TO VIDEO TUTORIAL**<br>
[![IMAGE ALT TEXT](http://img.youtube.com/vi/ltLUMu5RuB8/0.jpg)](http://www.youtube.com/watch?v=ltLUMu5RuB8 "Portainer deployment")

```shell
sudo docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```
***PS: Additional steps can be executed in order to deploy a Proxy server in Docker. If so, folow the next steps. If not, jump to [Deployment of OTBR - Virtual Appliance](https://github.com/opentibiabr/otbr-va#deployment-of-otbr---virtual-appliance)***

### **Deployment of NGINX Proxy Manager:**<br>
**LINK TO VIDEO TUTORIAL**<br>
[![IMAGE ALT TEXT](http://img.youtube.com/vi/hIWAys-sq_o/0.jpg)](http://www.youtube.com/watch?v=hIWAys-sq_o "NGINX Proxy Manager deployment")


### **Deployment of Portainer - Additional Steps:**<br>
This step is only required if you want to expose your otserv under SSL encryption.<br>
**LINK TO VIDEO TUTORIAL**<br>
[![IMAGE ALT TEXT](http://img.youtube.com/vi/5fI1AAvHOSU/0.jpg)](http://www.youtube.com/watch?v=5fI1AAvHOSU "SSL configuration")

```shell
sudo docker stop portainer
sudo docker rm portainer
sudo docker run -d -p 8000:8000 -p 9443:9443 --network nginxproxymanager_default --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```

Note that some Ubuntu distributed over VPSs or if you are installing a Ubuntu fresh from a iso file, you may need to configure your user to have access external from SFTP clients like WinSCP, to do so, edit your **/etc/sudoers**, executing the following command:<br>
```
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
```
You still need to set your SFTP client to execute with sudo previleges, like the bellow configuration on advanced settings of WinSCP:
![image](https://user-images.githubusercontent.com/11935651/176328044-aac14f44-1ccb-41ae-9b2e-d7c2ae89d23f.png)
<br>After that, you should be able to open SFTP clients and edit files remotely.

### **Deployment of OTBR - Virtual Appliance:**<br>
**LINK TO VIDEO TUTORIAL**<br>
[![IMAGE ALT TEXT](http://img.youtube.com/vi/aHVCG8fOuTE/0.jpg)](http://www.youtube.com/watch?v=aHVCG8fOuTE "OTBR-VA Deployment")

Edit your MyAAC IP address to proceed with the installation:
```shell
sed -i -e '$aMYIPADDRESS' /var/www/html/install/ip.txt
```
After installed, for safety remove your install folder with the following command:
```shell
rm -r /var/www/html/install
```

### **Ueseful Commands - Virtual Appliance:**<br>
The most used process to maintain your server updated can be executed by commands from anywhere:<br>
```$ db-backup```
Force auto backup of your mysql database, the file can be found on host machine at path ***/srv/otbr/dbbkp***.<br>
```$ repo-update```
Force update of the repositories, it includes the distro/canary repository, datapack/global repository and aac/myaac repository.<br>
```$ recompile```
Force server to recompile, this process require some processing consumption, be caution while running it, once recompiled simple restart the server to apply the new binary or wait for the next server save.<br>
```$ canary-restart```
Force Canary server to restart.

### Issues

We use the [issue tracker on GitHub](https://github.com/opentibiabr/canary/issues). Keep in mind that everyone who is watching the repository gets notified by e-mail when there is an activity, so be thoughtful and avoid writing comments that aren't meant for an issue (e.g. "+1"). If you'd like for an issue to be fixed faster, you should either fix it yourself and submit a pull request, or place a bounty on the issue.

### Pull requests

Before [creating a pull request](https://github.com/opentibiabr/canary/pulls) please keep in mind:

  * Do not send Pull Request changing the map, as we can't review the changes it's better to use our [Discord](https://discord.gg/3NxYnyV) to talk about or send the map changes to the responsible for updating it.
  * Focus on fixing only one thing, mixing too much things on the same Pull Request make it harder to review, harder to test and if we need to revert the change it will remove other things together.
  * Follow the project indentation, if your editor support you can use the [editorconfig](https://editorconfig.org/) to automatic configure the indentation.
  * There are people that doesn't play the game on the official server, so explain your changes to help understand what are you changing and why.
  * Avoid opening a Pull Request to just update one line of an xml file.

### Credits to the creators of the services included or mentioned in this image

  * [Canary](https://github.com/opentibiabr/canary/graphs/contributors)
  * [MyAAC](https://github.com/otsoft/myaac/graphs/contributors)
