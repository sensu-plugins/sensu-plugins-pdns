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

  def run
    metrics = `sudo rec_control get-all`.split("\n")
    if $CHILD_STATUS.exitstatus > 0
      critical 'Failed to dump pdns statistics. Check that the pdns process is running!'
    end
    metrics.each do |metric|
      (key, value) = metric.split("\t")
      output([config[:scheme], key].join('.'), value)
    end
    ok
  end
end
