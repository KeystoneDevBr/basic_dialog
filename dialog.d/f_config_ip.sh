#!/bin/bash
#########################################################################################
#
#   This Script was create by Fagne Tolentio Reges
#   Date: 2022-12-05
#
#   This function help us to configure Static IP Address by Netplan (Default on Ubuntu)
#   For do it, it call the Dialog navigation for colect the informations an apply the
#   new configurtaions.
#
#########################################################################################
f_config_ip(){
   #---------------------- This Function Apply the configurations   ---------------------
   f_save_settings(){
       clear;
       sudo echo "Startin applay........................................";

       #remove all networking file configuration
       sudo rm -rf /etc/netplan/* ;

       #start netplan file configuration
       sudo netplan set ethernets.enp0s3.addresses=["$address$netmask"] ;
      
       sudo netplan set ethernets.enp0s3.gateway4="$gateway" ;
      
       #sudo netplan set version=2

       sudo netplan set ethernets.enp0s3.nameservers.addresses=["$name_servers"] ;
      
       sudo netplan set ethernets.enp0s3.nameservers.search=[] ;
      
       #sudo netplan set ethernets.enp0s3.routes="- to: default"
       #sudo netplan set ethernets.enp0s3.routes="- via: $gateway"
       #sudo ip route add default via $gateway
      
       sudo netplan set renderer=networkd
      
       sudo netplan apply
       sleep 5
   }
   #------------------------------------------------------------------------------------
#########################################################################################
   # Start the navigation (the first stap is stap0)
   next_stap='stap0'
   previous_stap='stap0'

   while : ; do


       case "$next_stap" in
           #Fist stap, get the ip address.
           stap0)
               next_stap='stap1'
               address=$(dialog --stdout \
                   --max-input 15 \
                   --backtitle 'IP Configuration' \
                   --inputbox 'Enter with IP address: X.X.X.X'  0 0 "192.168.1.X")
               ;;
           stap1)
               previous_stap='stap0'
               next_stap='stap2'
               netmask=$(dialog --stdout \
                   --max-input 3 \
                   --backtitle 'IP Configuration' \
                   --inputbox 'Enter With Mask (CIDR Prefix): /X'  0 0 "/24")
               ;;
           stap2)
               previous_stap='stap1'
               next_stap='stap3'
               gateway=$(dialog --stdout \
                   --max-input 15 \
                   --backtitle 'IP Configuration' \
                   --inputbox 'Enter with IP Gateway: X.X.X.X'  0 0 "192.168.1.X")
               ;;
           stap3)
               previous_stap='stap2'
               next_stap='stap4'
               name_servers=$(dialog --stdout \
                   --max-input 31 \
                   --backtitle 'IP Configuration' \
                   --inputbox 'Enter with the Servers Names IP: X.X.X.X, \
                      You can use (,) for separate the server Names'  0 0 "8.8.8.8,8.8.4.4")
               ;;
           stap4)
               previous_stap='stap3'
               next_stap='stap5'

               can_save=$(dialog --stdout \
                   --backtitle 'IP Configuration' \
                   --title "Settings"     \
                   --cr-wrap \
                   --yesno "
                       Do you want save this sattings?:

                       IP Address:     $address
                       Gateway:        $gateway
                       DNS:            $name_servers
                  
                   " 0 0)
               ;;
           stap5)
               previous_stap='stap4'
               next_stap='stap1'
               dialog \
                   --cr-wrap \
                   --backtitle 'IP Configuration' \
                   --title "Settings"  \
                   --msgbox "
                       This settings will be saved:

                       IP Address:     $address
                       Gateway:        $gateway
                       DNS:            $name_servers

                   " 14 40
                   f_save_settings ; break
               ;;


           *)
               echo "Janela desconhecida '$next_stap'"
               echo "Abortando programa..."
               exit
       esac

       # Get the CANCEL, ESC events
       return=$?
       # Star navigation with ESC pressed
       [ $return -eq 255   ] && next_stap="stap0"      # Esc
       # Exit if CALCEL button pressed
       [ $return -eq 1 ] && clear && break             # Cancel

   done
   #------------------------------------------------------------------------------------
}
f_config_ip
#########################################################################################