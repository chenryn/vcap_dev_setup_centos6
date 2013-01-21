#
# Cookbook Name:: python
# Recipe:: default
#
# Copyright 2012, VMware
#
#

%w[ python-devel python-setuptools ].each do |pkg|
  package pkg
end

bash "Installing pip" do
  code "easy_install pip"
end
