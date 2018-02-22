#!/bin/bash

export PORT=5120

cd ~/www/tasktracker
./bin/tasktracker stop || true
./bin/tasktracker start
