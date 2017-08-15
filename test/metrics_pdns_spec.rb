require_relative '../bin/metrics-pdns.rb'

describe 'PdnsGraphite', '#run' do
  before(:all) do
    PdnsGraphite.class_variable_set(:@@autorun, nil)
    @metrics = PdnsGraphite.new
  end
  context 'when no argument passed' do
    it 'it dumps tmp.txt' do
      @metrics.run
      expect(File).to exist('/tmp/tmp.txt')
    end
  end
  context 'when teardown called' do
    it 'cleans up properly' do
      @metrics.teardown
      expect(File).not_to exist('/tmp/tmp.txt')
    end
  end
end
