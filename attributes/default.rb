# cabocha
default['cabocha']['version'] = "0.69"
default['cabocha']['source']['filename']  = "cabocha-" + default['cabocha']['version'] + ".tar.bz2"
default['cabocha']['source']['configure_flags']  = ["--with-charset=utf8", ""]
default['cabocha']['source']['force_recompile']  = false

# crppp
default['cabocha']['crfpp']['version'] = "0.58"
default['cabocha']['crfpp']['source']['filename'] = "CRF++-" +  default['cabocha']['crfpp']['version'] + ".tar.gz"
default['cabocha']['crfpp']['source']['configure_flags'] = ["--with-charset=utf8", ""]
default['cabocha']['crfpp']['source']['force_recompile']  = false

