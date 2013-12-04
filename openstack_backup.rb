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
    puts "Launching backup for #{resp[:senderid]}"
  end
  mc.fsunfreeze(:filesystem => 'ALL')
end

