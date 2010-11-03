
module Bcm::Codel::ClassModule
        def codel2rtc
                arr = split_codel().content
                if not arr then return "/* failed to parse codel #{name} */" end
                rtc_codel = ""
                arr.each { |t|
                        case t[0]
                        when :code
                                rtc_codel += t[1]
                        when :prop_get
                                rtc_codel += "#{t[1]}"
                        when :prop_set
                                rtc_codel += "#{t[1]}=#{t[2]})"
                        when :port_read
                                rtc_codel += "#{t[1]}.read()"
                        when :port_write
                                rtc_codel += "#{t[1]}.data = #{t[2]}; #{t[1]}Out.write()"
                        else
                                rtc_codel += "/* unsupported: #{t[0]} */"
                        end
                }
                return rtc_codel
        end
end
