require "treetop"
require "polyglot"
require "codel"
require "term/ansicolor"
require "pp"

include Term::ANSIColor

code = <<END
// asd
bcm_port_read(port);
// bla
bcm_port_write(port2, arg);
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
x = bcm_port_read("portX");
bcm_port_write("portY", 33);
chatter.publish(msg);
END

bcmapi =<<END
// properties
bcm_prop_get("propA")
bcm_prop_set("propB", "value")

// ports
bcm_port_read("portX")
bcm_port_write("portY", 99)

// operations
bcm_call("reqOpX", varx, vary, varz)

END

def testparse(str, ppast = false)
	puts (magenta '='*80)
	codelp = CodelParser.new
	puts(green(str))
	ast = codelp.parse(str)
	if not ast then
		puts(red(bold("Failed!")))
		return
	end
	if ppast then pp ast end
	puts (blue '-'*10)
	pp ast.content
	return ast
end

testparse('bcm_port_read    (   asd )')
testparse('bcm_port_write(asd, hula)')
testparse('bcm_prop_get("prop1")')
testparse('bcm_prop_set("prop2", hula)')
testparse('bcm_prop_set(prop2.data, hula)')
testparse('justastring')
testparse('bcm_call("reqOp")')
testparse('bcm_call("reqOp", 23)')
testparse('bcm_call("reqOp", 1, x, y)')
testparse(code)
testparse(code2)
testparse(code3)
testparse(bcmapi)
