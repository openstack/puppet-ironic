require 'spec_helper_acceptance'

describe 'basic ironic' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include openstack_integration
      include openstack_integration::repos
      include openstack_integration::apache
      include openstack_integration::rabbitmq
      include openstack_integration::mysql
      include openstack_integration::keystone
      include openstack_integration::ironic
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    if os[:family].casecmp('RedHat') == 0
      # Ironic API port
      describe port(6385) do
        it { is_expected.to be_listening }
      end
      # Inspector API port
      describe port(5050) do
        it { is_expected.to be_listening.with('tcp') }
      end
    else # Inspector is not packaged, so only test Ironic
      # Ironic API port
      describe port(6385) do
        it { is_expected.to be_listening }
      end
    end

  end
end
