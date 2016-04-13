HostVolume based DB containers
===================================
There are two sub-branches which contain all of the create and launch
scripts for both mongo and mysql databases.

Clone this repository to your master:

    apt-get install git -y

or

    yum install git -y

then either grab the mongo branch:

    git clone https://github.com/kumulustech/kube-db-perf -b mysql-single

or

    git clone https://github.com/kumulustech/kube-db-perf -b mongo-single

or if you've already cloned this repository:

    git checkout mongo-single

then read the copy the data in the branch into your /root directory, and
read the README.md file in your /root directory.
