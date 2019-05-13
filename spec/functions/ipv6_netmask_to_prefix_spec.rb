require 'spec_helper'

describe 'ipv6_netmask_to_prefix' do
  it { should run.with_params([{'ip_range' => '192.168.0.100,192.168.0.120'}]).and_return([{'ip_range' => '192.168.0.100,192.168.0.120'}])}
  it { should run.with_params([{'netmask' => '255.255.255.0',}]).and_return([{'netmask' => '255.255.255.0'}])}
  it { should run.with_params([{'netmask' => 'ffff:ffff:ffff:ffff::'}]).and_return([{'netmask' => 64}])}
  it { should run.with_params([{'netmask' => '64'}]).and_return([{'netmask' => '64'}])}
  it { should run.with_params([{'netmask' => 64}]).and_return([{'netmask' => 64}])}
end
