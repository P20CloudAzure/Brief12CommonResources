#!/bin/bash
nomuser=Brief12-groupe
echo "Nombre de user"
read nbuser


Create_user (){
	echo $componomuser
}

Nombre_user (){
	f=1
	while [ $f -le $nbuser ]
	do	
		componomuser=$nomuser$f
		Create_user
		f=$((f+1))
	done
}

MAIN(){
	Create_user
	Nombre_user
}

MAIN
