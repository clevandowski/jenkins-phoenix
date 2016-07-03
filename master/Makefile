build:
	docker build -t clevandowski/jenkins-phoenix-master .

test:	build
	ps -eaf | grep "docker daemon" | grep `cat /var/run/docker.pid` | grep "\-H tcp://"

run:	test
	docker run --rm --name jenkins-phoenix-master -p 8080:8080 clevandowski/jenkins-phoenix-master

