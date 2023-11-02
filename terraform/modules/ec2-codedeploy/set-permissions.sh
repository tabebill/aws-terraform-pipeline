#!/bin/bash

# Make deployment scripts executable
chmod +x /modules/ec2-codedeploy/set_permissions.sh
chmod +x /modules/ec2-codedeploy/before_install.sh
chmod +x /modules/ec2-codedeploy/after_install.sh
chmod +x /modules/ec2-codedeploy/application_stop.sh
chmod +x /modules/ec2-codedeploy/application_start.sh