#!/bin/bash

#SIDEKIQ_THREADS=${SIDEKIQ_THREADS:-16}
cd /home/app/webapp

#exec chpst -u root bundle exec sidekiq -t 5 -c $SIDEKIQ_THREADS \
#    2>&1 |logger -t sidekiq

exec chpst -u app bundle exec puma -C config/puma.rb \
  2>&1 |logger -t appserver
