#!/bin/bash
#########################################################################################
# This Script was create by Fagne Tolentio Reges
# Date: 2022-12-05
#
# This function call the Dialog Menu with meny options for configurate a VM
#
#########################################################################################
#
# VM Information Function
mv_information(){
 #----------------------- Show Information About VM-------------------------------------
 dialog \
   --backtitle "VM  $(hostname)" \
   --title "VM Information" \
   --cr-wrap \
   --msgbox "
   User:           $USER
   IP:       $(hostname -I)
   $(lsb_release -d )
   $(lsb_release -c )
   SSH Client: $SSH_CLIENT
   " 0 0
 #--------------------------------------------------------------------------------------
}
#
#Netplan Apply Function
netplan_apply(){
 #----------------------- Apply de Ip settings -----------------------------------------
   if dialog --stdout \
       --backtitle 'IP Configuration' \
       --title "IP Settings"     \
       --yesno "Do you want apply this settings?" 7 60; then
    
     # If you were select yes to apply this settings
     dialog \
       --backtitle 'IP Configuration' \
       --title "IP Settings" \
       --msgbox "The Settigns was applied" 6 44;
    
     sudo echo "Startin applay........................................";
     # Apply the current network configuration
     clear && sudo netplan apply;
     sleep 5;
   else
     # If you aborted the settings
     dialog \
       --backtitle 'IP Configuration' \
       --title "IP Settings" \
       --msgbox "This settings was aborted." 6 44;
   fi
 #--------------------------------------------------------------------------------------
}
#########################################################################################
#
#----------------------- Default Menu ---------------------------------------------------
while : ; do

   shoices=$(
     dialog --stdout               \
       --backtitle "VM  $(hostname)"  \
       --title 'Configure VM'  \
       --menu 'Select one option' \
       0 0 0                         \
       Information     'Display VM Informations'       \
       Netplan         'Show Networking Configuration' \
       Networking      'Configure Networking Settings'   \
       Shell           'Open a Shell'  \
       Reboot          'Reboot The VM' \
       Shutdown        'Turn off VM' \
       Exit            'End Section' )

   # [ $? -ne 0 ] && clear &&  break

   #If CALCEL buttons was pressed,  end this section
   [ $? = 1 ] && clear &&  break
  
   #Open a first file configuration in a netplan directory
   netplan_file="sudo vim /etc/netplan/$(ls -1 /etc/netplan/ | head -n 1)"

   case "$shoices" in
        Information)   mv_information ;; 
        Netplan)       clear && eval "$netplan_file"; netplan_apply ;;    
        Networking)    bash /etc/profile.d/dialog.d/f_config_ip.sh  ;;
        Apache)        bash /etc/profile.d/dialog.d/f_apache.sh ;;
        Shell)         clear && bash ;;
        Reboot)        clear && sudo shutdown -r now ;;
        Shutdown)      clear && sudo shutdown -h now ;;
        Exit)          clear && exit; ;;
   esac

done

echo 'Tchau'  "$USER"
#########################################################################################