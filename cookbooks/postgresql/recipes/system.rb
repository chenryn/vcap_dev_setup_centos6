#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2011, VMware
#
#
#

/\s*\d*.\d*\s*/ =~ "#{node[:postgresql][:system_version]}"
pg_major_version = $&.strip
pg_port = "#{node[:postgresql][:system_port]}"
cf_pg_install(pg_major_version, pg_port)
