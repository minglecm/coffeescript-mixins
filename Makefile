JASMINE = ./node_modules/.bin/jasmine-node

.PHONY : init clean build test dist

init:
	npm install

clean:
	rm -rf lib/

build:
	coffee -o lib/ -c src/

test:
	$(JASMINE) --coffee spec/

dist: clean init build test