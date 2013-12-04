#!/usr/bin/env ruby

require 'mcollective'
include MCollective::RPC

options = rpcoptions do |parser, options|
  parser.define_head "OpenStack Backup Client"
  parser.banner = "Usage: openstack_backup [options]"
  
  parser.on('-u', '--unfreeze-after SECONDS', 'Unfreeze after n seconds') do |v|
    options[:unfreeze_after] = v.to_i
  end
end

options[:unfreeze_after] ||= 30

fsfreeze = rpcclient('fsfreeze')

fsfreeze.fsfreeze(:filesystem => 'ALL', :unfreeze_after => options[:unfreeze_after]) do |resp|
  puts "Frozen: #{resp[:senderid]}"
  puts "Launching backup for #{resp[:senderid]}"
  puts "Unfreezing #{resp[:senderid]}"
  fsfreeze.reset
  fsfreeze.identity_filter resp[:senderid]
  fsfreeze.fsunfreeze(:filesystem => 'ALL')
end

