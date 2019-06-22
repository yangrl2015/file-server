#!/bin/bash
function add_users()
{
 local username=$1
 local password=$2
 
 echo "$username" >> /etc/vsftpd/vuser
 echo "$password" >> /etc/vsftpd/vuser
 db_load -T -t hash -f /etc/vsftpd/vuser /etc/vsftpd/vuser.db
cat >/etc/vsftpd/vuser_conf/$username<<EOF
local_root=/raid/aios-data/User/$username
anon_umask=077
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
EOF

 

}
add_users $1 $2
