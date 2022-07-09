require 'spec_helper_acceptance'

describe 'basic ironic_config resource' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      File <||> -> Ironic_config <||>
      File <||> -> Ironic_inspector_config <||>

      file { '/etc/ironic' :
        ensure => directory,
      }
      file { '/etc/ironic-inspector' :
        ensure => directory,
      }
      file { '/etc/ironic/ironic.conf' :
        ensure => file,
      }
      file { '/etc/ironic-inspector/inspector.conf' :
        ensure => file,
      }

      ironic_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      ironic_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      ironic_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      ironic_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      ironic_config { 'DEFAULT/thisshouldexist3' :
        value => ['foo', 'bar'],
      }

      ironic_inspector_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      ironic_inspector_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      ironic_inspector_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      ironic_inspector_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      ironic_inspector_config { 'DEFAULT/thisshouldexist3' :
        value => ['foo', 'bar'],
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/ironic-inspector/inspector.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }
      it { is_expected.to contain('thisshouldexist3=foo') }
      it { is_expected.to contain('thisshouldexist3=bar') }

      describe '#content' do
        subject { super().content }
        it { is_expected.to_not match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/ironic/ironic.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }
      it { is_expected.to contain('thisshouldexist3=foo') }
      it { is_expected.to contain('thisshouldexist3=bar') }

      describe '#content' do
        subject { super().content }
        it { is_expected.to_not match /thisshouldnotexist/ }
      end
    end
  end
end
