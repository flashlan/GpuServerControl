@echo off
start "" /B ssh.exe -a -X -Y sandman@192.168.1.129 /home/sandman/script_srvcs/start_ollama_srv.sh;bash 