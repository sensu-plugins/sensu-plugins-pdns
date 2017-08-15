require_relative '../bin/metrics-pdns.rb'
require_relative 'spec_helper.rb'

RSpec.describe PdnsGraphite do
  it 'check that plugin dumps tmp.txt' do
    metrics = PdnsGraphite.new
    metrics.run
    expect(File).to exist('/tmp/tmp.txt')
  end
end
