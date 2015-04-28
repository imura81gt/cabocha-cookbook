#
# Cookbook Name:: cabocha
# Recipe:: crfpp
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'build-essential::default'

include_recipe 'mecab'
include_recipe 'cabocha::crfpp'

package "tar"

# tar.gz upload to /tmp

src_filepath = "#{Chef::Config[:file_cache_path]}/#{node['cabocha']['crfpp']['source']['filename']}"

crfpp_force_recompile = node['cabocha']['crfpp']['source']['force_recompile']

cookbook_file node['cabocha']['crfpp']['source']['filename'] do
  owner 'root'
  group 'root'
  mode '0644'
  path src_filepath
  action :create_if_missing
end

package "tar"

# unarchive
bash "unarchive_source" do
  cwd  ::File.dirname(src_filepath)
  code <<-EOH
  tar xzf #{::File.basename(src_filepath)} -C #{::File.dirname(src_filepath)}
  EOH

  not_if { ::File.directory?("#{Chef::Config['file_cache_path'] || '/tmp'}/CRF++-#{node['cabocha']['crfpp']['version']}") }
end

# compile
bash "compile_source" do
  cwd  ::File.dirname(src_filepath) 
  code <<-EOH
    cd CRF++-#{node['cabocha']['crfpp']['version']} &&
    make distclean
    ./configure #{node['cabocha']['crfpp']['source']['configure_flags'].join(' ')} &&
    make && make install
    ldconfig
  EOH

  ## 強制コンパイルフラグが付いているか、インストールされていない時に実行する
  not_if do
    crfpp_force_recompile == false && File.exist?("/usr/local/lib/libcrfpp.so") 
  end

end
