#! /usr/bin/env ruby
#
# <metrics-pdns.rb>
#
# DESCRIPTION:
# simple ruby script to extract PowerDNS recursor statistics and send them in Graphite PlainText format

#
# OUTPUT:
#   plain text metric data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   <Hammad Shah>  <haashah@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin'
require 'sensu-plugin/metric/cli'

class PdnsGraphite < Sensu::Plugin::Metric::CLI::Graphite
  option :dump_file,
         description: 'name of file to dump powerDNS stats to',
         short: '-d DUMPFILE',
         long: '--dump DUMPFILE',
         default: 'tmp.txt'

  def output(*args)
    unless args.empty?
      args[2] = Time.now.to_is if args[2].nil?
      puts "#{`hostname -f`.chomp}-- #{args[0..2].join("\s")}"
    end
  end

  def run
    # dump powerdns statistics using rec control
    # TODO: @haashah only extract user specified metrics.
    system "sudo rec_control get-all > /tmp/#{config[:dump_file]}"

    if $CHILD_STATUS.exitstatus > 0
      puts 'failed to dump pdns statistics. check pdns process is running!'
      exit 2
    end

    File.readlines("/tmp/#{config[:dump_file]}").each do |line|
      output line.split[0], line.split[1]
    end

    # time to cleanup dump file
    system "sudo rm -rf /tmp/#{config[:dump_file]}"
  end
end
