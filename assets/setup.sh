#!/bin/bash

# ===================== Configure VNC ===================== #
# Local debug
# echo $1 >> /opt/setup.sh.output
# echo $2 >> /opt/setup.sh.output

Xvfb $2 -screen 0 1366x768x16 &
x11vnc -passwd TestVNC -display $2 -N -forever &
echo "exec $1" > ~/.xinitrc && chmod +x ~/.xinitrc

# ================= Configure SQLDeveloper ================= #
echo 'AddVMOption -Dide.user.dir=/data' >> /opt/sqldeveloper/sqldeveloper/bin/sqldeveloper.conf
# JavaHome should be automatically set, if not then 
# echo SetJavaHome /usr/lib/jvm/java-11-openjdk >> /opt/sqldeveloper/sqldeveloper/bin/sqldeveloper.conf
