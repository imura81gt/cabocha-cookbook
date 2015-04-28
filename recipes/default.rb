#
# Cookbook Name:: cabocha
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'build-essential::default'

include_recipe 'mecab'
include_recipe 'cabocha::crfpp'

package "tar"

cabocha_force_recompile = node['cabocha']['source']['force_recompile']
# tar.bz2 upload to /tmp

src_filepath = "#{Chef::Config[:file_cache_path]}/#{node['cabocha']['source']['filename']}"
cookbook_file node['cabocha']['source']['filename'] do
  owner 'root'
  group 'root'
  mode '0644'
  path src_filepath
  action :create_if_missing
end

# unarchive
bash "unarchive_source" do
  cwd  ::File.dirname(src_filepath)
  code <<-EOH
  tar jxf #{::File.basename(src_filepath)} -C #{::File.dirname(src_filepath)}
  EOH

  not_if { 
    ::File.directory?("#{Chef::Config['file_cache_path'] || '/tmp'}/cabocha-#{node['cabocha']['version']}") 
  }

end

# compile
bash "compile_source" do
  cwd  ::File.dirname(src_filepath) 
  code <<-EOH
    cd cabocha-#{node['cabocha']['version']} &&
    make distclean
    ./configure #{node['cabocha']['source']['configure_flags'].join(' ')} &&
    make && make install
    ldconfig
  EOH

  ## 強制コンパイルフラグが付いているか、インストールされていない時に実行する
  not_if do
    cabocha_force_recompile == false && File.exist?("/usr/local/bin/cabocha")
  end

end
