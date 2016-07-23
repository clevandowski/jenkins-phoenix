testenv:
	# Verification que le user courant est root (via sudo). Lancer "sudo make <command>"
	test $$(id -u) -eq 0

test:	testenv

build:	test
	docker build -t clevandowski/jenkins-phoenix-slave .

clean:	testenv
	docker rmi -f clevandowski/jenkins-phoenix-slave | true
