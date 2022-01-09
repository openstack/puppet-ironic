require 'spec_helper'

describe 'ironic::disk_utils' do

  shared_examples_for 'ironic::disk_utils' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it 'configures default values' do
        is_expected.to contain_ironic_config('disk_utils/efi_system_partition_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('disk_utils/bios_boot_partition_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('disk_utils/dd_block_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('disk_utils/partition_detection_attempts').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('disk_utils/partprobe_attempts').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('disk_utils/image_convert_memory_limit').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('disk_utils/image_convert_attempts').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with specific parameters' do
      let :params do
        {
          :efi_system_partition_size    => 200,
          :bios_boot_partition_size     => 1,
          :dd_block_size                => '1M',
          :partition_detection_attempts => 3,
          :partprobe_attempts           => 10,
          :image_convert_memory_limit   => 2048,
          :image_convert_attempts       => 3,
        }
      end

      it 'configures specified values' do
        is_expected.to contain_ironic_config('disk_utils/efi_system_partition_size').with_value(200)
        is_expected.to contain_ironic_config('disk_utils/bios_boot_partition_size').with_value(1)
        is_expected.to contain_ironic_config('disk_utils/dd_block_size').with_value('1M')
        is_expected.to contain_ironic_config('disk_utils/partition_detection_attempts').with_value(3)
        is_expected.to contain_ironic_config('disk_utils/partprobe_attempts').with_value(10)
        is_expected.to contain_ironic_config('disk_utils/image_convert_memory_limit').with_value(2048)
        is_expected.to contain_ironic_config('disk_utils/image_convert_attempts').with_value(3)
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'ironic::disk_utils'
    end
  end

end
