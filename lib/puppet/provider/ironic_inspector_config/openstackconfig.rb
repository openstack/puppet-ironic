Puppet::Type.type(:ironic_inspector_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/ironic-inspector/inspector.conf'
  end

end
