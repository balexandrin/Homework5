#!/bin/bash

x="/tmp/myps---"$(date +%s)
touch $x
UIDflag=0
vreUID=0
vefUID=0
vssUID=0
vfsUID=0
vcwd=0
vres=0
vstatm=0
vmaps=0
vPID="a"
for i in $@
do
    case $i in
        reUID)
        vreUID=1
	UIDflag=1
        ;;
        efUID)
        vefUID=1
	UIDflag=1
        ;;
        ssUID)
        vssUID=1
	UIDflag=1
        ;;
	fsUID)
	vfsUID=1
	UIDflag=1
	;;
	strdir)
	vcwd=1
	;;
	res)
	vres=1
	;;
	fl-n-lib)
	vmaps=1
	;;
	statmem)
	vstatm=1
	;;
	PID=*)
	vPID=$(echo $i | awk -F"=" '{print $2};')
	;;
        *)
        echo "$i it is not parametr!"
        ;;
    esac
done

if (( $vPID=="a" ))
then
    j=$(ls /proc/ | egrep "^[1-9][0-9]*")
elif ! [ -d /proc//$vPID ]; 
then
    echo "No process with id = "$j
    exit
elif [ -d /proc//$vPID ];
then
    j=$vPID
fi

for i in $j
do
    if [ -d /proc/$i ];
    then
	echo -n "PID: "$i"; "$(grep PPid /proc/$i/status)"; "$(grep Name /proc/$i/status)"; executable file: "$(readlink /proc/$i/exe) >> $x
	echo -e "" >> $x

	if (( $vcwd==1 ));
	then
	    echo  -n "	Starting directory: "$(readlink /proc/$i/cwd) >> $x
	    echo -e "" >> $x
	fi

	if (( $UIDflag==1 ))
	then
	    echo -n "	UID's: " >> $x
	    j=$(cat /proc/$i/status | grep Uid)
	    if (( $vreUID==1 )); then echo -n "real UID = "$(echo $j | awk '{print $2};')"; " >> $x; fi
	    if (( $vefUID==1 )); then echo -n "effective UID = "$(echo $j | awk '{print $3};')"; " >> $x; fi
	    if (( $vssUID==1 )); then echo -n "saved set UID = "$(echo $j | awk '{print $4};')"; " >> $x; fi
	    if (( $vfsUID==1 )); then echo -n "file system UID = "$(echo $j | awk '{print $5};')"; " >> $x; fi
	    echo -e '' >> $x
	fi

	if (( $vstatm==1 ));
	then
	    echo -n "	Memory: " >> $x
	    j=$(cat /proc/$i/statm)
	    echo -n "total: "$(echo $j | awk '{print $1};')"; resident: "$(echo $j | awk '{print $2};')"; shared: "$(echo $j | awk '{print $3};')"; code segment; "$(echo $j | awk '{print $4};')"; libraries: "$(echo $j | awk '{print $5};')"; stack: "$(echo $j | awk '{print $6};')"; modified memory pages: "$(echo $j | awk '{print $7};') >> $x
	    echo -e '' >> $x
	fi

	if (( $vres==1 ));
	then
	    echo "	resources: " >> $x
	    for j in $(ls /proc/$i/fd)
	    do
		echo "		" $(readlink /proc/$i/fd/$j)"; " >> $x
	    done
	    echo -e '' >> $x
	fi

	if (( $vmaps==1 ));
	then
	    echo "	files and libraries:" >> $x
	    for j in $(cat /proc/856/maps | awk '{print $6};')
	    do
		echo "		"$j >> $x
	    done
	    echo -e '' >> $x
	fi


    fi
done

cat $x
rm $x