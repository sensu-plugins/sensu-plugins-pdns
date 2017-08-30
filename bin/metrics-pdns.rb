#!/usr/bin/env ruby
#
# metrics-pdns.rb
#
# DESCRIPTION:
#   Extract PowerDNS recursor statistics and send them in Graphite plaintext format
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
#   metrics-pdns.rb
#
# NOTES:
#   Requires sudo permissions for the sensu user to run rec_control
#
# LICENSE:
#   <Hammad Shah>  <haashah@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin'
require 'sensu-plugin/metric/cli'
require 'English'
require 'socket'

class PdnsGraphite < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.pdns"

  option :syslog_path,
         description: 'Path to the syslog',
         long: '--syslog SYSLOG',
         default: '/var/log/messages'

  option :extra_stats,
         description: 'flag to send stats collected from syslog like qps',
         short: '-e EXTRA',
         long: '--extra EXTRA',
         default: false

  def cmd_run(cmd)
    result = `#{cmd}`.split("\n")
    if $CHILD_STATUS.exitstatus > 0
      critical "Failed to execute #{cmd}"
    end
    result
  end

  def parse_syslog
    # send signal to pdns process to dump stats
    cmd_run('sudo pkill -SIGUSR1 pdns_recursor')
    # parse stats from syslog
    metrics = cmd_run("sudo tail #{config[:syslog_path]} -n 6 | grep pdns_recursor")
    return if metrics.nil?
    metrics.each do |metric|
      next unless metric.include?('stats:')
      (_jargon, stats) = metric.split('stats:')
      keyvalues = stats.split(',')
      keyvalues.each do |keyvalue|
        key = keyvalue.strip!.scan(/\D+/)[0].strip
        key.gsub!(/[()]|\s/, '-')
        value = keyvalue.scan(/\d+/)[0]
        output([config[:scheme], key].join('.'), value)
      end
    end
  end

  def run
    metrics = cmd_run('sudo rec_control get-all')
    metrics.each do |metric|
      (key, value) = metric.split("\t")
      output([config[:scheme], key].join('.'), value)
    end
    parse_syslog if config[:extra_stats]
    ok
  end
end
