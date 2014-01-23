echo -e "\e[1;33m[REHAB-BOX]: Before Puppet Shell. Executing.\e[0m";

sudo apt-get update --fix-missing && apt-get install puppet --assume-yes
