require_relative '../bin/metrics-pdns.rb'

describe 'PdnsGraphite', '#run' do
  before(:all) do
    PdnsGraphite.class_variable_set(:@@autorun, nil)
    args = %w[--syslog /var/log/syslog]
    @metrics = PdnsGraphite.new(args)
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
      exit_code = e.status
    end
    expect(exit_code).to eq 0
  end
end
