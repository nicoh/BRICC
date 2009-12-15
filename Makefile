all: clean gen rosmake

clean:
	rm -rf output

gen:
	./testmodel1.rb

rosmake:
	rosmake output
