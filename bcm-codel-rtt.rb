
module Bcm::Codel::ClassModule
        def codel2rtt
                arr = split_codel().content
                if not arr then return "/* failed to parse codel #{name} */" end
                rtt_codel = ""
                arr.each { |t|
                        case t[0]
                        when :code
                                rtt_codel += t[1]
                        when :prop_get
                                rtt_codel += "#{t[1]}"
                        when :prop_set
                                rtt_codel += "#{t[1]}=#{t[2]})"
                        when :port_read
                                rtt_codel += "#{t[1]}.Pop()"
                        when :port_write
                                rtt_codel += "#{t[1]}.Push(#{t[2]})"
                        when :call
                                rtt_codel += "#{t[1]}.call(" + t[2..-1].join(',') + ')'
                        else
                                rtt_codel += "/* unsupported: #{t[0]} */"
                        end
                }
                return rtt_codel
        end
end
