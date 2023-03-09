#!/bin/bash

# Script de sauvegarde du $HOME

# Variables
folder_to_save=`eval echo ~laurent`
name_folder=$(echo $folder_to_save| awk '{ print $2 }' FS='/')$(date '+%Y%m%d')
save_folder="/datas/Sauvegardes/$name_folder"
taille_saver=$(df /datas|tail -1|awk '{print $4}')
taille_to_save=$(du -s $folder_to_save|awk '{print $1}')
taille_save_dixp=`expr "(($taille_to_save)*1.1)/1"|bc`
log_name=$name_folder.log

verif_user(){
# Vérification de base pour éxécuter le script
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être executer par le user root" 1>&2
   exit 1
fi
}

verif_taille(){
# Vérification de l'espace disponible
if [ "$taille_save_dixp" -gt "$taille_saver" ]; then
    echo "Erreur, espace disque insuffisant !"
    exit 1
fi
}

attribut_droits(){
# donne les droits sur le dossier de sauvegarde et les logs
chown -R laurent:laurent $save_folder
chown laurent:laurent $log_name
}

sauvegarde(){
touch $log_name
mkdir -p $save_folder
rsync -avzh $folder_to_save $save_folder --log-file=$log_name
}

main(){
verif_user
verif_taille
sauvegarde
attribut_droits
}

main
