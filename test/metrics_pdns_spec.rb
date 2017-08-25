require_relative '../bin/metrics-pdns.rb'

describe 'PdnsGraphite', '#run' do
  before(:all) do
    PdnsGraphite.class_variable_set(:@@autorun, nil)
    @metrics = PdnsGraphite.new
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
