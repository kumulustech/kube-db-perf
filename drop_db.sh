for n in `seq 22 3 55`; do
mongo 10.0.0.$n <<EOF
db.dropDatabase()
EOF
done
