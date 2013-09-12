#!/bin/sh
echo "...attempting to kill"
kill -9 $(cat ~/Documents/github_workspace/learnster/tmp/pids/server.pid)