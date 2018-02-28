#!/bin/bash

export PORT=5130

cd ~/www/tasktracker2
./bin/tasktracker stop || true
./bin/tasktracker start
