#!/bin/env bash

#Single User Install into ~/.rvm
curl -kL get.rvm.io | bash -s stable

# Multi-User Mode into /usr/local/rvm
#  curl -kL get.rvm.io | sudo bash -s stable

# Load RVM:

source ~/.rvm/scripts/rvm

# Multi-user should autoload this as well
# /etc/profile.d/rvm.sh 

#Find the requirements (follow the instructions):

rvm requirements

# Install ruby:

rvm install 1.9.3
rvm gemset create custom
