server:
	python -m SimpleHTTPServer

coffee:
	coffee --bare --compile --output lib/ src/

watch_coffee:
	coffee --watch --bare --compile --output lib/ src/

watch_server:
	node ./server/bin/watch
