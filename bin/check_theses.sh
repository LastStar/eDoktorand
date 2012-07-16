#!/bin/sh

cd /var/apps/edoktorand.czu.cz && ./script/runner -e production 'include DisertThemesHelper; periodic_theses_check'
