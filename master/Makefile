testenv:
	# Verification que le daemon docker ecoute bien en tcp
	ps -eaf | grep "docker daemon" | grep `cat /var/run/docker.pid` | grep "\-H tcp://"
	# Verification que le user courant est root (via sudo). Lancer "sudo make <command>"
	test $$(id -u) -eq 0

init:	testenv
	rm -rf /opt/jenkins-phoenix-master
	mkdir -p /opt/jenkins-phoenix-master
	chown -R 1000:1000 /opt/jenkins-phoenix-master

test:	testenv

build:	test
	docker build -t clevandowski/jenkins-phoenix-master .

run:	test
	test -d /opt/jenkins-phoenix-master
	docker run -d --name jenkins-phoenix-master -p 8080:8080 -v /opt/jenkins-phoenix-master:/var/jenkins_home clevandowski/jenkins-phoenix-master

stop:
	docker stop jenkins-phoenix-master
	docker rm jenkins-phoenix-master

clean:	testenv
	docker rmi -f clevandowski/jenkins-phoenix-master | true

log:	testenv
	docker logs -f jenkins-phoenix-master

check-plugins:
	./bin/checkPluginsVersion.sh
