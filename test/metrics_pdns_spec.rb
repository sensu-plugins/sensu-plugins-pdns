require_relative '../bin/metrics-pdns.rb'

describe 'PdnsGraphite', '#run' do
  before(:all) do
    PdnsGraphite.class_variable_set(:@@autorun, nil)
    @metrics = PdnsGraphite.new
  end
  it 'verifies cmd_run()' do
    begin
      expect { @metrics.cmd_run('ls -al /opt').to output.to_stdout }
    end
  end
  it 'returns ok' do
    begin
      @metrics.run
    rescue SystemExit => e
      expect(e.status).to eq 0
    end
  end
  it 'verifies --extra flag' do
    begin
      args = %w[--syslog /var/log/syslog --extra true]
      @metrics = PdnsGraphite.new(args)
      @metrics.run
    rescue SystemExit => e
      expect(e.status).to eq 0
    end
  end
end
