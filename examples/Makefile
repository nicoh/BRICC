BRICC=../bricc.rb
RUBYLIB=${RUBYLIB}":../"

all: ps rmps

clean:
	rm -rf out_* output

# publisher subscriber
ps:
	${BRICC} -t ${TARGET} -o out_publisher_${TARGET} ex_publisher.rb
	${BRICC} -t ${TARGET} -o out_subscriber_${TARGET} ex_subscriber.rb

rmps: ps
	rosmake out_publisher_${TARGET} #out_subscriber_${TARGET}
