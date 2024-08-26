@echo off
mode con: cols=92 lines=40
start "" /B ssh.exe -a -X -Y sandman@192.168.1.129 /home/sandman/script_srvcs/nvidia-smi.sh;bash 