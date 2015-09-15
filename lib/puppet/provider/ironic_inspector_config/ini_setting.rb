Puppet::Type.type(:ironic_inspector_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/ironic-inspector/inspector.conf'
  end

end
