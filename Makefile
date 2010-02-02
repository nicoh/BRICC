BRICC=./bricc.rb

all: ps rmps

clean:
	rm -rf out_*

# publisher subscriber
ps:
	${BRICC} -t ${TARGET} -o "out_publisher" ex_publisher.rb
	${BRICC} -t ${TARGET} -o "out_subscriber" ex_subscriber.rb

rmps: ps
	rosmake out_publisher out_subscriber
