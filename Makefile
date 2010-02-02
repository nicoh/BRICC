BRICC=./bricc.rb

all: model_ex1 ps rosmake

clean:
	rm -rf out_*

model_ex1:
	${BRICC} model_ex1.rb "out_model_ex1"

# publisher subscriber
ps:
	${BRICC} ex_publisher.rb "out_publisher"
	${BRICC} ex_subscriber.rb "out_subscriber"

rosmake: ps
	rosmake out_publisher out_subscriber
