#!/usr/bin/env ruby

require 'mcollective'
include MCollective::RPC

mc = rpcclient('fsfreeze')
mc.discovery_method = 'mc'

all_nodes = mc.discover.clone

all_nodes.in_groups_of(5) do |nodes|
  mc.reset
  mc.discover :nodes => nodes.compact

  mc.fsfreeze(:filesystem => 'ALL') do |resp|
    puts "Frozen: #{resp[:senderid]}"
    puts "Launching backup for #{resp[:senderid]}"
    puts "Unfreezing #{resp[:senderid]}"
    mc.reset
    mc.identity_filter resp[:senderid]
    mc.fsunfreeze(:filesystem => 'ALL')
  end
end

