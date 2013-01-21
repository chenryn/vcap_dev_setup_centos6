vcap_dev_setup_centos6
======================

port cloudfoundry/vcap/dev_setup to CentOS6

* change bin/vcap_dev_setup to use root privileges and yum command.
* change cookbooks to use chef on CentOS6.
* add proxy env support to maven install in uaa cookbook.

TODO
====

* PostgreSQL cookbook haven't been changed now.
* php cookbook haven't been changed now.
* echo cookbook haven't been changed now.
* filesystem cookbook haven't been changed now.

BUGS
====

* If build vcap by rvm, the rubygems env may be wrong when your install ruby and start~
