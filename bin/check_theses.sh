#!/bin/sh

cd /var/apps/new.edoktorand.czu.cz/current && ./script/runner -e production 'extend DisertThemes::Checker; send_for_check'

cd /var/apps/new.edoktorand.czu.cz/current && ./script/runner -e production 'extend DisertThemes::Checker; receive_results'
