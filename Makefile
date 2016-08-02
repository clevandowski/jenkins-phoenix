testplugins:
	cd master && make testplugins

testenv:
	cd master && make testenv
	cd slave && make testenv

test:
	cd master && make test
	cd slave && make test

build:
	cd master && make build
	cd slave && make build

clean:
	cd master && make clean
	cd slave && make clean

init:
	cd master && make init

run:
	cd master && make run

stop:
	cd master && make stop

