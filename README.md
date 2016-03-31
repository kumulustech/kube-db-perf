HostVolume based MongoDB containers
===================================
process:

The process should be:
1) verify host names in all of the .sh scripts, there 
are a few places where the default is something like 
'kube-masterX' or 'kube-minion-X' that should be adjusted

2) There is a concept of an offset built into the launch 
tools, which is there to support spreading the database
across multiple minions.  Select a minion with the appropriate
storage type.

3) you should then be able to launch the tests by running the nvme_test.sh script

files:

mongo_manage_pod.sh [start/stop/restart] {0-11}
  This script will take two options start/stop or restart, and the db replica set you want to restart. Note that restart will _ERASE_ the database contents of the minion /mnt/nvmeX directores associated with these mongo machines.

load_run_mongo0_nvme.sh
  This script should launch a load phase, and the a set of tests based on the 
number of database worker threads, but requires a workload-mongoX set of files 
(described below). It will run a battery of tests including 1, 2, 4, 6, and 12 
databases and 16, 32, and 64 thread test against the database. 

Note that the w=XXX parameter is a write management parameter, set to 0 or 1, 
it tends to fail and deadlock in a replicated mongo configuration, in which 
case it should be set to majority.

mongo-nvme.json.tmpl
  A template (sed replacement) for the mongo nvme/shared storage model pod. 
The three replacement items are:
    DB_NUMBER a number from 1-36 for 3 node 3 way replicated databases
    VOL_NUMBER a number from 1-12 for the 3 nodes NVME disk partitions
    DB_TARGET a kubernetes node label (one of kube-minion-{1,2,3})

mongo-svc.json.tmpl
  A template (sed replacement) for the mongo nvme/shared storage model 
service.  The service is needed in order to associate host name to 
accessible IP for the mongo db replication service.  Parameters are:
    DB_NUMBER a number from 0-35, the individual db instance
    DB_CLUSTER_IP a number from 0-35 +20 to be used as the access IP for the databases

mongo_db_create.sh {0-11}
  This script will take a single parameter (the database replica set) 
and create the three pods and services from the .tmpl files (defined above).

YCSB extensions:
workload-mongo-perf-load
  The extension to workloada to load a larger dataset. 1000000 records of 5 800 byte fields.

workload-mongo-perf-run
  The extension to workloada to run against a portion of the dataset. 200000 operations out of the total 1000000 possible records to sort across.
