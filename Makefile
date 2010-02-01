all: clean gen rosmake

clean:
	rm -rf output

gen:
	./bricc.rb model_ex1.rb

rosmake:
	rosmake output
