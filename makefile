# I motion to move from submodules to npm where/when possible. -JJ
install:
	git submodule init
	# bmpimage repo requires perms?
	git submodule update vendor/jDataView vendor/jParser vendor/js_bintrees vendor/restruct.js/

server:
	python -m SimpleHTTPServer

coffee:
	coffee --bare --compile --output lib/ src/

watch_coffee:
	coffee --watch --bare --compile --output lib/ src/

watch_server:
	node ./server/bin/watch
