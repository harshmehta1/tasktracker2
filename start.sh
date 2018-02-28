#!/bin/bash

export PORT=5130

cd ~/www/tasktracker
./bin/tasktracker stop || true
./bin/tasktracker start
