#!/bin/bash

# Based on: http://www.richud.com/wiki/Ubuntu_Fluxbox_GUI_with_x11vnc_and_Xvfb

main() {
    #. /disp_funcs.sh #source display functions
    log_i "Starting xvfb virtual display..."
    launch_xvfb
    log_i "Starting window manager..."
    launch_window_manager
    log_i "Starting jupyter notebooks"
    run_jupyter
    log_i "Starting VNC server..."
    run_vnc_server
    keep_alive
}


trap control_c SIGINT SIGTERM SIGHUP
source /disp_funcs.sh
main
export DISPLAY=':1.0'
Xvfb :1 -screen 0 1400x900x24 > /dev/null 2>&1 &
echo "alias python='python3.6'" >> ~/.bashrc && source ~/.bashrc

exit
