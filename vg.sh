#!/bin/bash
export VAGRANT_DEFAULT_PROVIDER=openvz
export VAGRANT_LOG=DEBUG
/usr/bin/time bundle exec vagrant $*
