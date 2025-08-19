# == Class: ironic::disk_utils
#
# Configure the disk_utils parameters
#
# === Parameters
#
# [*efi_system_partition_size*]
#  (optional) Size of EFI system partition in MiB when configuring UEFI systems
#  for local boot.
#  Defaults to $facts['os_service_default']
#
# [*bios_boot_partition_size*]
#  (optional) Size of BIOS Boot partition in MiB when configuring GPT
#  partitioned systems for local boot in BIOS.
#  Defaults to $facts['os_service_default']
#
# [*dd_block_size*]
#  (optional) Block size to use when writing to the node disk.
#  Defaults to $facts['os_service_default']
#
# [*partition_detection_attempts*]
#  (optional) Maximum attempts to detect a newly created partition.
#  Defaults to $facts['os_service_default']
#
# [*partprobe_attempts*]
#  (optional) Maximum number of attempts to try to read the partition.
#  Defaults to $facts['os_service_default']
#
# [*image_convert_memory_limit*]
#  (optional) Memory limit for "qemu-img convert" in MiB. Implemented via
#  the address space resource limit.
#  Defaults to $facts['os_service_default']
#
# [*image_convert_attempts*]
#  (optional) Number of attempts to convert an image
#  Defaults to $facts['os_service_default']
#
class ironic::disk_utils (
  $efi_system_partition_size    = $facts['os_service_default'],
  $bios_boot_partition_size     = $facts['os_service_default'],
  $dd_block_size                = $facts['os_service_default'],
  $partition_detection_attempts = $facts['os_service_default'],
  $partprobe_attempts           = $facts['os_service_default'],
  $image_convert_memory_limit   = $facts['os_service_default'],
  $image_convert_attempts       = $facts['os_service_default'],
) {
  include ironic::deps
  include ironic::params

  ironic_config {
    'disk_utils/efi_system_partition_size':    value => $efi_system_partition_size;
    'disk_utils/bios_boot_partition_size':     value => $bios_boot_partition_size;
    'disk_utils/dd_block_size':                value => $dd_block_size;
    'disk_utils/partition_detection_attempts': value => $partition_detection_attempts;
    'disk_utils/partprobe_attempts':           value => $partprobe_attempts;
    'disk_utils/image_convert_memory_limit':   value => $image_convert_memory_limit;
    'disk_utils/image_convert_attempts':       value => $image_convert_attempts;
  }
}
