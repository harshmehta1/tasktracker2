#!/bin/bash

export PORT=5130

cd ~/www/tasktracker2
./bin/tasktracker2 stop || true
./bin/tasktracker2 start
