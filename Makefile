JASMINE = ./node_modules/.bin/jasmine-node

.PHONY : init clean build test dist publish

init:
	npm install

clean:
	rm -rf lib/

build:
	coffee -o lib/ -c src/

test:
	$(JASMINE) --coffee spec/

dist: clean init build test

publish: dist
	npm publish