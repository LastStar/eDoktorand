#!/bin/sh

cd /var/apps/edoktorand.czu.cz && ./script/runner -e production 'extend DisertThemes::Checker; send_for_check'

cd /var/apps/edoktorand.czu.cz && ./script/runner -e production 'extend DisertThemes::Checker; receive_results'
