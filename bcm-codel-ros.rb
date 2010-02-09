
module Bcm::Codel::ClassModule
        def codel2ros
                arr = split_codel().content
                if not arr then return "/* failed to parse codel #{name} */" end
                ros_codel = ""
                arr.each { |t|
                        case t[0]
                        when :code
                                ros_codel += t[1]
                        when :prop_get
                                ros_codel += "#{t[1]}"
                        when :prop_set
                                ros_codel += "#{t[1]}=#{t[2]}"
                        when :port_read
                                ros_codel += "#{t[1]}.pop()"
                        when :port_write
                                ros_codel += "#{t[1]}.publish(#{t[2]})"
                        when :call
                                ros_codel += "#{t[1]}.call(" + t[2..-1].join(',') + ')'
                        else
                                ros_codel += "/* unsupported: #{t[0]} */"
                        end
                }
                return ros_codel
        end
end
