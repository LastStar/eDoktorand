#!/bin/sh

cd /var/apps/edoktorand.czu.cz && ./script/runner -e production 'DisertThemes::Checker.send_for_check'
