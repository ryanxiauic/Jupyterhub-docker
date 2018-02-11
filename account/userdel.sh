#!/bin/bash

# Delete lecturers group
groupdel lecturers
groupdel py2017a
groupdel py2017b

# Delete lecturer users
while IFS=, read NAME PW; do
    echo "Delete lecturer $NAME"
    userdel $NAME
	rm -rf /home/$NAME
done < <(egrep -v '^#' data/lecturers.list)

# Delete regular users
while IFS=, read NAME PW; do
    echo "Delete student $NAME"
	userdel $NAME
	rm -rf /home/$NAME
done < <(egrep -v '^#' data/pya.list)

while IFS=, read NAME PW; do
    echo "Delete student $NAME"
	userdel $NAME
	rm -rf /home/$NAME
done < <(egrep -v '^#' data/pyb.list)