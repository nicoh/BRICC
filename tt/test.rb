require "treetop"
require "polyglot"
require "codel"
require "term/ansicolor"
require "pp"

include Term::ANSIColor

code = <<END
// asd
port_read(port);
// bla
port_write(port2, arg);
END

code2 = <<END
just various bla
no bcm funcs

asd
END

code3 =<<END
std::stringstream ss;
std_msgs::String msg;

int x = prop_get(counter)
cout << "hello " << x << " times" << endl;
ss << "Hello there! This is message [" << x << "]";
prop_set(counter, ++x)
msg.data = ss.str();
x = port_read("portX");
port_write("portY", 33);
chatter.publish(msg);
END

def testparse(str, ppast = false)
        puts (green '='*80)
        codelp = CodelParser.new
        puts(green(str))
        ast = codelp.parse(str)
        if ppast then pp ast end
        puts (blue '-'*10)
        pp ast.content
        return ast
end

testparse('port_read    (   asd )')
testparse('port_write(asd, hula)')
testparse('justastring')
testparse(code)
testparse(code2)
testparse(code3)


