Puppet::Functions.create_function(:ipv6_normalize_dnsmasq_ip_subnets) do
  def ipv6_normalize_dnsmasq_ip_subnets(args)
    require 'ipaddr'
    result = []
    args.each do |ip_subnet|
      ip_subnet_dup = ip_subnet.dup
      begin
        if ip_subnet["netmask"]
          if IPAddr.new(ip_subnet["netmask"]).ipv6?
            # TODO(hjensas) Once we have ruby stdlib >= 2.5.x we can use
            # IPAddr.new().prefix instead of counting 1's.
            prefix = IPAddr.new(ip_subnet["netmask"]).to_i.to_s(2).count("1")
            Puppet.debug("Netmask #{ip_subnet["netmask"]} changed to prefix #{prefix}")
            ip_subnet_dup["netmask"] = prefix
          end
        end
      rescue IPAddr::AddressFamilyError, IPAddr::Error, IPAddr::InvalidAddressError, IPAddr::InvalidPrefixError => e
        # Ignore it
      end
      begin
        if ip_subnet["gateway"]
          if IPAddr.new(ip_subnet["gateway"]).ipv6?
            # draft-ietf-mif-dhcpv6-route-option-05 was never completed.
            # https://datatracker.ietf.org/doc/draft-ietf-mif-dhcpv6-route-option/
            # Remove the gateway key:value so that the option:router entry is
            # not created in dnsmasq.conf.
            ip_subnet_dup.delete("gateway")
          end
        end
      rescue IPAddr::AddressFamilyError, IPAddr::Error, IPAddr::InvalidAddressError, IPAddr::InvalidPrefixError => e
        # Ignore it
      end
      result << ip_subnet_dup
    end
    return result
  end
end
