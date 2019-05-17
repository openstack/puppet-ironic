Puppet::Functions.create_function(:ipv6_netmask_to_prefix) do
  def ipv6_netmask_to_prefix(args)
    require 'ipaddr'
    result = []
    args.each do |ip_subnet|
      begin
        if IPAddr.new(ip_subnet["netmask"]).ipv6?
          # TODO(hjensas) Once we have ruby stdlib >= 2.5.x we can use
          # IPAddr.new().prefix instead of counting 1's.
          prefix = IPAddr.new(ip_subnet["netmask"]).to_i.to_s(2).count("1")
          Puppet.debug("Netmask #{ip_subnet["netmask"]} changed to prefix #{prefix}")
          ip_subnet_dup = ip_subnet.dup
          ip_subnet_dup["netmask"] = prefix
          result << ip_subnet_dup
        else
          result << ip_subnet
        end
      rescue IPAddr::AddressFamilyError, IPAddr::Error, IPAddr::InvalidAddressError, IPAddr::InvalidPrefixError => e
        # Ignore it
        result << ip_subnet
      end
    end
    return result
  end
end
