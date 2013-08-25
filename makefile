server:
	python -m SimpleHTTPServer

watch:
	coffee --watch --bare --compile --output lib/ src/

coffee:
	coffee --bare --compile --output lib/ src/
