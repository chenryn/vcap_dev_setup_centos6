vcap_dev_setup_centos6
======================

port cloudfoundry/vcap/dev_setup to CentOS6

* change bin/vcap_dev_setup to use root privileges and yum command
* change cookbooks to use chef on CentOS6.

BUGS
====

* PostgreSQL cookbook haven't been changed now.
* If build vcap by rvm, the rubygems env may be wrong~
