module Puppet::Parser::Functions
	newfunction(:check_ips_include, :type => :rvalue, :doc => <<-EOS
 This function will check if a IP is in the given range, and will then return a list of valid IPs
to be put onto the system. Give the Argument bad to it, you will receive all the values not included in that range.

 *Examples:*


	e.g.
	ip_array = ['192.168.1.1", '192.168.0.3']
	ip_net = "192.168.0.1/24
	check_ips_include(ip_array,ip_net[,bad])
	value bad is optional, if you give this argument, you will receive all ips which are not included in that range
	by default you will receive all ips within the given range
	Would return:
		192.168.0.3

	EOS
		) do |arguments|

		if (arguments.size < 2) then
    	  raise(Puppet::ParseError, "check_ips_include(): Wrong number of arguments "+
   	     "given #{arguments.size} for 2.")
  	  	end
		require 'ipaddr'
			good_ips = Array.new
			bad_ips = Array.new
			if (arguments[1].kind_of?(Array))
				arguments[1].each do |net1|
					ip_net = net1
					ip_nets = IPAddr.new(ip_net)
					if (arguments[0].kind_of?(Array))
							arguments[0].each do |array1|
								ip_check = IPAddr.new(array1)
								if (ip_check.ipv4?() or ip_check.ipv6?()) 
									if ( ip_nets.include?(ip_check))
										good_ips << "#{ip_check}"
										#raise(TypeInfo, "trying to see what is wrong #{ip_check}"  )
									else
										bad_ips << "#{ip_check}"
									end
								end
							end
					else
							raise(TypeError, "check_ips_include(): First argument must be an Array of valid IPs." )
					end
				end
			else
				ip_net = arguments[1]
				ip_nets = IPAddr.new(ip_net)
				if (arguments[0].kind_of?(Array))
						arguments[0].each do |array1|
							ip_check = IPAddr.new(array1)
							if (ip_check.ipv4?() or ip_check.ipv6?()) 
								if ( ip_nets.include?(ip_check))
									good_ips << "#{ip_check}"
									#raise(TypeInfo, "trying to see what is wrong #{ip_check}"  )
								else
									bad_ips << "#{ip_check}"
								end
							end
						end
				else
						raise(TypeError, "check_ips_include(): First argument must be an Array of valid IPs." )
				end
			end
			if (arguments[2] == "bad" )
				return (bad_ips.uniq - good_ips.uniq)
			else
				return (good_ips.uniq)
			end
	end
end
