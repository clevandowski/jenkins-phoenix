testplugins:
	# Verification de la version des plugins
	./bin/checkPluginsVersion.sh || (echo "[ERROR] Les plugins de l'image du master ne sont pas à jour"; exit 1)

testenv:
	# Verification que le user courant est root (via sudo). Lancer "sudo make <command>"
	#test $$(id -u) -eq 0 || (echo "[ERROR] Vous devez avoir les droits root"; exit 1)
	# Vérification que le docker daemon tourne
	docker system info || (echo "[ERROR] Le docker daemon n'est pas accessible"; exit 1)
	# Verification que le daemon docker ecoute bien en tcp
	# ps -eaf | grep "dockerd" | grep `cat /var/run/docker.pid` | grep "\-H tcp://" || (echo "[ERROR] Le docker daemon n'est pas configuré pour écouter en tcp sur le port 4243"; exit 1)
	echo "Environment tests successful !"

build:
	docker build -t clevandowski/jenkins-phoenix-master .

test:	build

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
