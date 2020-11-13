# roger-skyline-1_42

__*This school 42 project is the second project of the network administration branch. This project is about installing a server on a Virtual Machine, discovering the basics of system and network administration, and getting to know how to configure a web server, and lots of other services.*__

## Configuration

I tried to *automatize* the creation and the configuration of the VM as much as I could, in 3 steps:

### Step 1: using a shell script to easily add a VM in VirtualBox

* Run the script *test_script.sh*: `./test_script.sh`
* It will ask for the name of the VM (e.g. "new_VM"), the size of the hard drive (e.g. 8 GB), of the RAM (e.g. 4 GB) and the VRAM (e.g. 16 MB).
* The new VM is now added in VirtualBox:
![img1](https://user-images.githubusercontent.com/67087093/99071884-457b1500-25b3-11eb-97b5-0b24585c0b12.png)

The new VM can now be launched in order to install Debian.

### Step 2: using a preseed configuration file to automatize the installation of Debian

#### What is a preseed configuration file?

A preseed configuration file contains all the instructions that will be needed by the installer, for each part of the installation: keyboard configuration, creation of a new user, partitioning...

Among all these instructions, the following will particularly make the step 3 easier:
- The packages openssh-server and sudo are installed
- A non-root user pertaining to the group sudo has been created
- The file /etc/apt/sources.list is configured so that new packages can be installed instantly without having to do any further changes to this file

Please refer to the file *preseed.cfg* for more details.

#### How to install Debian automatically using this file?

* To install Debian using a preseed configuration file, choose the option *« Advanced »* then *« Automated install ».*
![img2](https://user-images.githubusercontent.com/67087093/99072032-87a45680-25b3-11eb-813a-af2f012112b0.png)
![img3](https://user-images.githubusercontent.com/67087093/99072077-9db21700-25b3-11eb-97bb-cbbf99258fbd.png)
* Then you should indicate at the bottom of the page a URL to your file. After you pressed enter, the installation will be made automatically, without you having to type anything.
![img4](https://user-images.githubusercontent.com/67087093/99072257-f5508280-25b3-11eb-9e4d-e08e0c43a53d.png)

### Step 3: automatizing the configuration of the server with Ansible

#### What is Ansible?

Ansible is an open source *automation tool* that can be used for *configuration management*, among other things. It connects to your remote server via SSH and automatically carries out its tasks on this server.

Tasks are automatized thanks to scripts that are written in *YAML* and that contains all the tasks Ansible will need to do. These tasks are based on Ansible *modules*, which are standalone scripts that do some work on the remote server.

Here is an example of two tasks, the first one installs zsh on the remote server, and the second one changes the default shell of the user agardina to zsh:

![Example of two tasks](https://user-images.githubusercontent.com/67087093/99091505-4a01f680-25d0-11eb-8ab8-75a5a05320cf.png)

Since there a are a lot of tasks to do, they are grouped inside "roles", in order to have a clear organization. For instance, there is a role for the SSH configuration, another one for the Apache2 configuration, etc. Each role contains the "sub" tasks to do.

All the roles are listed in the *playbook*, which is the main configuration file which also contains the information needed by Ansible to be able to work, such as the host to configure, or some variables that will be used during the configuration.

The *playbook* is basically the scenario Ansible will have to follow.

Please refer to the file *ansible/playbook.yml* for more details.

#### List of roles (main tasks to be done)

This list corresponds to the requirements of the project.

- Find the SSH port configured on the remote machine (if it is the first configuration attempt the SSH port is 22, if not it is 2222)
- Install and configure zsh
- Configure SSH
- Install and configure apache2
- Deploy the website to the web server (the example website used in this project can be found [here](https://github.com/agardina/rs1-website))
- Install and configure PSAD (Port Scan Attack Detector)
- Install and configure iptables (firewall)
- Install and configure fail2ban (to prevent DOS attacks, among othet things)
- Deactivate a few useless services
- Add scripts to update packages automatically with cron
- Configure network

Please refer to the files in the folder *ansible/roles/* for more details.

#### Configure our remote server with Ansible

* When the VM has rebooted, login as root or as the user you created. 
* Then find the IP address of the VM using the command `ip addr` (e.g. 192.168.1.49)
* Add it to your Ansible *hosts* file on your local machine. The *hosts* file contains the list of the remote servers on which you want to perform actions.
![img5](https://user-images.githubusercontent.com/67087093/99089903-2e95ec00-25ce-11eb-94d8-da7734caba1d.png)
* Copy the SSH public key of your local machine to your remote server: 
`ssh-copy-id -i ~/.ssh/id_rsa.pub user@server_IP_address`
* You are now ready to configure your server automatically with Ansible using the following command:
`ansible-playbook -i path/to/your/ansible/hosts/file path/to/your/Ansible/playbook`