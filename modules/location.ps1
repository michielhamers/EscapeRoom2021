## gather all scripts that are related to location
#so is this the local test
#network / nas based test
#is this a windows based ssystem
#is this a mac / unix based system
function determineglobalvar(){
    #default $IsMacOS
    #default $IsMacOS 
    
}
function mountsynnas(){
    mount_smbfs //admin@syn-nas/ER/2021 ./mntpoint
 }
 function unmountsynnas(){
     # mount_smbfs //admin@syn-nas/ER/2021 ./mntpoint
     umount ./mntpoint
  }
 