module RubyInstall
  def cf_ruby_install(ruby_version, ruby_source_id, ruby_path, ruby_tarball_suffix)

    %w[  zlib-devel ].each do |pkg|
      package pkg
    end

    ruby_tarball_path = File.join(node[:deployment][:setup_cache], "ruby-#{ruby_version}.tar.#{ruby_tarball_suffix}")
    cf_remote_file ruby_tarball_path do
      owner node[:deployment][:user]
      id ruby_source_id
      checksum node[:ruby][:checksums][ruby_version]
    end

    directory ruby_path do
      owner node[:deployment][:user]
      group node[:deployment][:group]
      mode "0755"
      recursive true
      action :create
    end

    bash "Install Ruby #{ruby_path}" do
      cwd File.join("", "tmp")
      user node[:deployment][:user]
      code <<-EOH
      # work around chef's decompression of source tarball before a more elegant
      # solution is found
      if [ "#{ruby_tarball_suffix}" = "bz2" ];then
        tar xf #{ruby_tarball_path}
      else
        tar xzf #{ruby_tarball_path}
      fi
      cd ruby-#{ruby_version}
      # See http://deadmemes.net/2011/10/28/rvm-install-fails-on-ubuntu-11-10/
      sed -i 's/\\(OSSL_SSL_METHOD_ENTRY(SSLv2[^3]\\)/\\/\\/\\1/g' ./ext/openssl/ossl_ssl.c
      ./configure --disable-pthread --prefix=#{ruby_path}
      make
      make install
      EOH
    end
  end

  def cf_rubygems_install(ruby_path, rubygems_version, rubygems_id, rubygems_checksum)
    rubygem_tarball_path = File.join(node[:deployment][:setup_cache], "rubygems-#{rubygems_version}.tgz")
    ENV['GEM_HOME'] = ruby_path.split('/')[0..-3].join('/')
    ENV['GEM_PATH'] = ruby_path.split('/')[0..-3].join('/') + "/gems"
    cf_remote_file rubygem_tarball_path do
      owner node[:deployment][:user]
      id rubygems_id
      checksum rubygems_checksum
    end

    bash "Install RubyGems #{ruby_path}" do
      cwd File.join("", "tmp")
      user node[:deployment][:user]
      code <<-EOH
      tar xzf #{rubygem_tarball_path}
      cd rubygems-#{rubygems_version}
      #{File.join(ruby_path, "bin", "ruby")} setup.rb
      EOH
    end
  end

  def cf_gem_install(ruby_path, gem_name, gem_version = nil)
    # The default chef installed with Ubuntu 10.04 does not support the "retries" option
    # for gem_package. It may be a good idea to add/use that option once the ubuntu
    # chef package gets updated.
    bindir = File.join(ruby_path, "bin")
    installdir = File.join(ruby_path, "lib")
    gem_package gem_name do
      version gem_version if !gem_version.nil?
      gem_binary File.join(ruby_path, "bin", "gem")
      options("--bindir #{bindir} --install-dir #{installdir}")
    end
  end
end

class Chef::Recipe
  include RubyInstall
end
