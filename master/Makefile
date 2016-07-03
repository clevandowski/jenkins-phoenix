testenv:
	# Verification que le uid du user qui execute est bien 1000, en raison du user interne des containers jenkins
	# Commande d'origine (les $ ne sont pas remplaces par $$ pour le Makefile):
	# test `id | cut -d" " -f1 | cut -d"=" -f2 | sed -e "s/^\([0-9]\+\).*$/\1/"` == 1000
	id | cut -d" " -f1 | cut -d"=" -f2 | sed -e "s/^\([0-9]\+\).*$$/\1/" | grep -e "^1000$$"
	# Verification que le daemon docker ecoute bien en tcp
	ps -eaf | grep "docker daemon" | grep `cat /var/run/docker.pid` | grep "\-H tcp://"

init:	testenv
	sudo rm -rf /opt/jenkins-phoenix-master
	sudo mkdir -p /opt/jenkins-phoenix-master
	sudo chown -R 1000:1000 /opt/jenkins-phoenix-master

build:	testenv
	docker build -t clevandowski/jenkins-phoenix-master .

test:	build

run:	test
	test -d /opt/jenkins-phoenix-master
	docker run -d --name jenkins-phoenix-master -p 8080:8080 -v /opt/jenkins-phoenix-master:/var/jenkins_home clevandowski/jenkins-phoenix-master

stop:
	docker stop jenkins-phoenix-master
	docker rm jenkins-phoenix-master

