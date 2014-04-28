require_relative 'spec_helper'

describe port(22) do
  it 'should be listening on port 22' do
    expect(port '22').to be_listening
  end
end
