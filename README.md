HostVolume based MongoDB containers
===================================
assumptions:

nodes are named master, and minion-[0-9]
  - changing node names will require editing most of the shell scripts
  - mostly this requires replacing 'minion' with the new name
  - note that the name expectes a -{minion#} so more edits may be necessecary
  if the minion names are not ordinal.
database disks are mounted in /mnt/nvme* on the minion nodes
while replicated databases are not supported by this code, there is a concept
of distributing the load across up to three minion machines, and the disks are
expected to be mapped equivalently across the nodes (e.g. replica 1 will always
use disk 1, etc.).

process:
To launch a database test, you should just have to do something like:

  ./launch_db_mongo.sh 1

Where the 1 is actually the number of the databases that you want to create.
 - note that 1,2,4,6, and 12 are the only current acceptable values.
This will:
 - run the db_mysql.sh script, to first delete and then create the databases
 - clean up previous iostat data if any exists on the minion and ensure a current
 iostat capture script exists
 - launch a screen session that includes an rc file for the number of databases
 being tested in the particular run.  the screenrc file kicks off a 'load and run'
 operation per database.
 - when the screen session finishes (all of the database tests complete), the run
 file outputs are captured, and to a certain extent pre-processed into csv files
 along with the iostat data into a directory in the /root directory on the master.

files:

mongo_manage_pod.sh [start stop] {0-11}
  This script will take two options start or stop, and the db replica set you
  want to restart.

load_run_mongo0_nvme.sh
  This script will launch a load phase, and the a set of tests based on the
  number of database worker threads. It will run a battery of tests including
  1, 2, 4, 6, and 12 databases and 16, 32, and 64 thread test against the database.

Note that the w=XXX parameter is a write management parameter, set to 0 or 1,
it tends to fail and deadlock in a replicated mongo configuration, in general it
should be set to majority.

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
  This script will take a single parameter (the database replica set) and create
  the kubernetes pod and service (via sed replacement of the templates)

db_mysql.sh
  This script is a sequencing script so that the right database values are applied
  to spread the databases across multiple possible backend storage devices (1,2,4,12)

iostat_capture.sh
  This script will start two iostat processes per database, one for 1s data, one
  for 10s data, and will return the process ids, so that the tests can be terminated
  at the end of the YCSB test run.

get_rw_ts.sh
  Clean up the YCSB output run data file to remove extraneous data and update the
  timestamps to a time-series appropriate timestamp.

iostat_clean.sh
  Re-format the iostat output into a single csv line with a time-series appropraite
  timestamp.

YCSB extensions:
workload-mongo-perf-load
  The extension to workloada to load a larger dataset. 10000000 records of 5 800 byte fields.

workload-mongo-perf-run
  The extension to workloada to run against a portion of the dataset. 2000000 operations out of the total 10000000 possible records to sort across.
