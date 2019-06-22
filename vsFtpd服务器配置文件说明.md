# 文件服务器

## 1 vsftpd 文件服务器
###（1）配置文件说明

**vsftpd.conf**
 Example config file /etc/vsftpd/vsftpd.conf  
**（1）默认配置**  
anonymous_enable=NO //是否开启匿名访问  
local_enable=YES // 本地用户访问开启YES，本地用户（linux中的系统用户）  
write_enable=YES //是否登录用户对FTP服务文件具有写权限，属于全局设置  
**（2）匿名用户设置**  
anon_upload_enable=YES //匿名用户上传权限开启  
anon_mkdir_write_enable=YES //是否允许匿名用户创建目录  
no_anon_password=YES/NO（NO）// 匿名用户登录不需要密码  
ftp_username=ftp //匿名用户登录时用户，默认为ftp 家目录为/var/ftp  
anon_root=/var/ftp //匿名用户登录进去默认的家目录  
anon_world_readable_only=YES/NO（YES）//如果设置为YES,匿名用户可以下载文件，在本机上可以阅读，但是不能在FTP服务器上阅读。
anon_other_write_enable=YES/NO（NO）//如果设为YES，则允许匿名登入者更多于上传或者建立目录之外的权限，譬如删除或者重命名。（如果 anon_upload_enable=NO，则匿名用户不能上传文件，但可以删除或者重命名已经存在的文件；如果 anon_mkdir_write_enable=NO，则匿名用户不能上传或者新建文件夹，但可以删除或者重命名已经存在的文件夹。）默认值为NO。  
chown_uploads=YES/NO（NO）//设置是否改变匿名用户上传文件（非目录）的属主  
chown_username=username //设置匿名用户上传文件（非目录）的属主名。建议不要设置为root  
anon_umask=077 // 设置匿名登入者新增或上传档案时的umask 值。默认值为077，则新建档案的对应权限为700。  

下面2个设置不经常用  
deny_email_enable=YES/NO（NO）  
banned_email_file=/etc/vsftpd/banner_emails   

**（3）本地用户设置**  
local_enable=YES/NO（YES） // 本地用户登录是否开启  
local_root=/home/username // 本地永不登录之后的家目录  
write_enable=YES/NO（YES） // 本地用户是否允许有写权限，这个是全局设置。  
local_umask=022 // 本地用户上传、新建文件的时候的权限掩码。  
file_open_mode=0755 //本地用户上传文件的权限，默认0666  
**（4）控制用户是否允许切换到上级目录**  
chroot_list_enable=YES/NO（NO）// 是否启用下面的chroot_list限制文件中的用户不会限制自己在家目录中  
chroot_list_file=/etc/vsftpd/chroot_list // 文件中的用户不会限制自己在家目录中  
chroot_local_user=YES/NO（NO）//用于指定用户列表文件中的用户是否允许切换到上级目录。默认值为NO。  
- 当chroot_list_enable=YES，chroot_local_user=YES时，在/etc/vsftpd.chroot_list文件中列出的用户，可以切换到其他目录；未在文件中列出的用户，不能切换到其他目录。  
- 当chroot_list_enable=YES，chroot_local_user=NO时，在/etc/vsftpd.chroot_list文件中列出的用户，不能切换到其他目录；未在文件中列出的用户，可以切换到其他目录。  
- 当chroot_list_enable=NO，chroot_local_user=YES时，所有的用户均不能切换到其他目录。  
- 当chroot_list_enable=NO，chroot_local_user=NO时，所有的用户均可以切换到其他目录。  

**(5) FTP的工作方式与端口设置**
listen_port=21 // FTP服务监听端口  
connect_from_port_20=YES/NO (YES)//指定端口20进行数据传输  
ftp_data_port=20 // 主动模式下、数据传输接口  
pasv_enable=YES/NO（YES） // 是否开启被动模式  
pasv_max_port=0 // 被动开启的模式 数据连接接口最大端口  
pasv_min_port=0 // 被动开启的模式 数据连接接口最小端口  
pasv_address=127.0.0.1 // 设置外网访问的ip地址，如果不设置外网是无法访问的，和vsftpd服务在一台机子上ip地址一致。  

**（6） 与连接相关的设置**  
listen=YES/NO（YES）// 设置vsftpd服务器是否以standalone模式运行。以standalone模式运行是一种较好 的方式，此时listen必须设置为YES，此为默认值。建议不要更改，有很多与服务器运行相关的配置命令，需要在此模式下才有效。若设置为NO，则 vsftpd不是以独立的服务运行，要受到xinetd服务的管控，功能上会受到限制。  
max_clients=0 // 设置vsftpd允许的最大连接数，默认值为0，表示不受限制。若设置为100时，则同时允许有100个连接，超出的将被拒绝。只有在standalone模式运行才有效。  

max_per_ip=0 // 设置每个IP允许与FTP服务器同时建立连接的数目。默认值为0，表示不受限制。只有在standalone模式运行才有效。  

listen_address=IP地址 // 设置FTP服务器在指定的IP地址上侦听用户的FTP请求。若不设置，则对服务器绑定的所有IP地址进行侦听。只有在standalone模式运行才有效。  

setproctitle_enable=YES/NO（NO） // 设置每个与FTP服务器的连接，是否以不同的进程表现出来。默认值为NO，此时使用ps aux |grep ftp只会有一个vsftpd的进程。若设置为YES，则每个连接都会有一个vsftpd的进程。  

**(7) 虚拟用户设置**  
pam_service_name=vsftpd // pam 认证方式与/etc/pam/vsftpd对应  
guest_enable= YES/NO（NO）// 虚拟用户模式开启  
guest_username=ftp // 虚拟用户的宿主用户（本地用户）  
virtual_use_local_privs=YES/NO（NO）// 设置虚拟用户权限是否与本地用户有相同权限，如果设置为NO，则权限与匿名用户相同权限。  

dirmessage_enable=YES //是否激活目录欢迎信息,当用户cmd模式下，首次进入某个目录会显示欢迎信息  

**（8）日志文件设置**  
xferlog_enable=YES //是否启动上传下载日志，如果启用，则上传下载的日志将会记录在xferlog_file所定义的文件中  
xferlog_file=/var/log/vsftpd.log // 记录上传下载的日志。  
xferlog_std_format=YES/NO（NO）//按照标准的xferlog日志格式输出日志  
port_enable=YES //  
**（9）超时时间设置**  
accept_timeout=60 // 被动模式，数据连接超时时间  
connect_timeout=60 // 主动模式，连接超时时间  
data_connection_timeout=300 // 该参数是等待数据传输(上传/下载)的空闲时间，当FTP服务端没传输一次数据包(8kB)，就会复位这个定时时间器，即这个时间是两次数据包传输的空闲时间，如果超过这个空闲时间客户端和数据连接都会断了，且这个超时设置与下面的idle_session_timeout的互斥的，即同时设置智能一个起作用。  
idle_session_timeout=300//单位秒，这个参数是等待指令输入的空闲的时间，即两个FTP命令的之间的空闲时间，这个只会断开当前客户端的FTP命令断开，数据连接可能还能连接。  
**（10）访问速率设置**  
anon_max_rate=0 // 匿名用户数据传输的数量限制，B/s单位。  
local_max_rate=0 //  本地用户数据传输的数量限制，B/s单位。  
**（11）访问控制设置**  
tcp_wrappers=NO // YES时，通过/etc/hosts.allow和/etc/hosts.deny结合起来限制访问主机ip的限制，hosts.allow中设置可访问的主机ip /etc/hosts.deny设置不能访问的ip地址  
userlist_file=/etc/vsftpd/user_list //用户列表 限制访问的用户，每一行都是用户名，具体是访问列表，还是禁止列表具体是根据下面的组合来确定。  
userlist_enable=YES/NO（NO）//是否启用上面的用户列表  
userlist_deny=YES/NO（YES）//决定userlist_file设置的文件是否能够能录FTP服务，如果userlist_enable设置YES userlist_deny设置为NO，则user_list用户可以访问FTP，如果userlist_deny设置为YES，则user_list中用户不能访问FTP  
*特殊文件*  
/etc/vsftpd/ftpusers,这个文件专门设置不能登录FTP的用户，这个是基于PAM访问限制的，可以在/etc/pam/vsftpd中可以看到，这个比user_list优先级高  
虚拟用户配置文件：  
/etc/vsftpd/vuser: 虚拟用户对应关系，即vuser中为一行一行数据，奇数行为用户名，偶数行为对应的用户名密码。  
/etc/vsftpd/vuser_conf：目录，虚拟用户自己的配置信息，目录下是对应的用户名文件其中为对应的权限信息。  




