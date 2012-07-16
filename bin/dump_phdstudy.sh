#!/bin/sh

if [ $# -eq 1 ] then
  filename=$1
else
  filename=`date "+%Y-%m-%d.sql"`
fi
echo "# filename is $filename"

echo "# dumping phdstudy_production"
/usr/local/bin/mysqldump -h10.70.1.75 --compact -uw3b -pw3b3000  phdstudy_production > "/dumps/$filename"

echo "# compresing dump"
cd /dumps; /usr/bin/tar -czf "$filename.tgz" "$filename"
