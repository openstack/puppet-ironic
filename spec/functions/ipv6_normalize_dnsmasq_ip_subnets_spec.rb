require 'spec_helper'

describe 'ipv6_normalize_dnsmasq_ip_subnets' do
  it { should run.with_params([{'ip_range' => '192.168.0.100,192.168.0.120'}]).and_return([{'ip_range' => '192.168.0.100,192.168.0.120'}])}
  it { should run.with_params([{'netmask' => '255.255.255.0',}]).and_return([{'netmask' => '255.255.255.0'}])}
  it { should run.with_params([{'netmask' => 'ffff:ffff:ffff:ffff::'}]).and_return([{'netmask' => 64}])}
  it { should run.with_params([{'netmask' => '64'}]).and_return([{'netmask' => '64'}])}
  it { should run.with_params([{'netmask' => 64}]).and_return([{'netmask' => 64}])}
  it { should run.with_params([{'gateway' => '192.168.0.1'}]).and_return([{'gateway' => '192.168.0.1'}])}
  it { should run.with_params([{'gateway' => 'fd00::1'}]).and_return([{}])}
  it { should run.with_params([{'netmask' => 'ffff:ffff:ffff:ffff::', 'gateway' => 'fd00::1'}]).and_return([{'netmask' => 64}])}
end
