#!/bin/bash

# Add lecturers group
groupadd lecturers
groupadd users
groupadd py2018

# Add lecturer users
while IFS=, read NAME PW; do
    echo "Creating lecturer $NAME"
    if [ -z $PW ]; then
        useradd -s "/bin/bash" -m -N -g users -G sudo,adm,lecturers $NAME
		echo "$NAME password unset"
    else
        useradd -s "/bin/bash" -m -N -g users -G sudo,adm,lecturers -p "$PW" $NAME
		echo "$NAME:$PW" | chpasswd
    fi
done < <(egrep -v '^#' /root/account/lecturers.list)

# Add regular users
while IFS=, read NAME PW; do
    echo "Creating student $NAME"
    if [ -z $PW ]; then
        useradd -s "/bin/bash" -m -N -g users -G py2018 $NAME
		echo "$NAME password unset"
    else
        useradd -s "/bin/bash" -m -N -g users -G py2018 -p "$PW" $NAME
		echo "$NAME:$PW" | chpasswd
    fi
done < <(egrep -v '^#' /root/account/students.list)
