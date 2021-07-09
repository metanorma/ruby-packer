# Copyright (c) 2017 Minqi Pan <pmq2001@gmail.com>
# 
# This file is part of Ruby Compiler, distributed under the MIT License
# For full terms see the included LICENSE file

class Compiler
  VERSION = '0.6.1'
  PRJ_ROOT = File.expand_path('../../..', __FILE__)
  VENDOR_DIR = File.expand_path('vendor', PRJ_ROOT)
  MEMFS = '/__ruby_packer_memfs__'
end
