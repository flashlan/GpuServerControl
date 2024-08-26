@echo off
start "" /B ssh.exe -a -X -Y sandman@192.168.1.129 /home/sandman/script_srvcs/stop_sd_srv.sh;bash 