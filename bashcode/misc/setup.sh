#!/bin/bash

FILE="/dev/ttyS0"
sudo stty --file=$FILE ixon ixoff -parodd parenb cs8 -cstopb ispeed 19200 ospeed 19200 

