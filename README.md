HostVolume based MongoDB containers
===================================
process:
To start a database, you should just have to do something like:

  ./mongo_manage_pod.sh restart 0

Where the 0 is actually the number of the database replica set that you want to create.  Using restart rather than start or stop will stop the database (if it exists), delete anything in the minion node local disks ()

files:

mongo_manage_pod.sh [start/stop/restart] {0-11}
  This script will take two options start/stop or restart, and the db replica set you want to restart. Note that restart will _ERASE_ the database contents of the minion /mnt/nvme* directores associated with these mongo machines.

mongo_replica_start.sh {0-11}
  once the PODs/Services are running we can take the 3 standalone Mongo instances and create a replica set.  This script will do so, and will stagger the replicas "modulo 3" across the 3 target machines.

load_run_mongo0_long.sh
  This is a variant of the previous script, but requires a workload-mongo* set of files (described below). It will run a 16/32/64/128 thread test against the database. Note that the w=XXX parameter is a write management parameter, set to 0 or 1, it tends to fail and deadlock the mongo replica secondaries.

mongo-nvme.json.tmpl
  A template (sed replacement) for the mongo nvme/shared storage model pod.  The three replacement items are:
    DB_NUMBER a number from 1-36 for 3 node 3 way replicated databases
    VOL_NUMBER a number from 1-12 for the 3 nodes NVME disk partitions
    DB_TARGET a kubernetes node label (one of kube-minion-{1,2,3})

mongo-svc.json.tmpl
  A template (sed replacement) for the mongo nvme/shared storage model service.  The service is needed in order to associate host name to accessible IP for the mongo db replication service.  Parameters are:
    DB_NUMBER a number from 0-35, the individual db instance
    DB_CLUSTER_IP a number from 0-35 +20 to be used as the access IP for the databases

mongo_db_create.sh {0-11}
  This script will take a single parameter (the database replica set) and create the three pods and services from the .tmpl files (defined above).


YCSB extensions:
workload-mongo-perf-load
  The extension to workloada to load a larger dataset. 1000000 records of 5 800 byte fields.

workload-mongo-perf-run
  The extension to workloada to run against a portion of the dataset. 200000 operations out of the total 1000000 possible records to sort across.
