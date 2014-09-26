serve:
	http-server

watch:	
	watchify -v -t coffeeify --extension=".coffee" src/main.coffee -o bundle.js

test:
	jasmine-node --coffee spec
