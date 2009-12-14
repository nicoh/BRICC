all: clean gen

clean:
	rm -rf output

gen:
	./testmodel1.rb
