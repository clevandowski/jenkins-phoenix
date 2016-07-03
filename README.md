# jenkins-phoenix
Jenkins Master &amp; Slaves basés sur Docker avec persistance de la configuration dans le repository GIT 


```@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@%,,,,,,,/@@@@@@@/,,,,,,,%@@@@@@@@@@@@@@@@@
@@@//////@@@@@,,,,,/@@@@@@@@@@@@@@@@@@@/,,,,,@@@@@//////@@@
@@@@@///////@@@,@@@@@@@@@@@@@@@@@///@@@@@@@,/@@///////@@@@@
@@@@@////////@@@@@@@@@@@@@@@/////@@@@@@@@@@@@@////////@@@@@
@@@@///////////@@@@@@@@@@/&/////@@@@@@@@@@@@///////////@@@@
@@@/////////////#@@@@@@@@@@/////@@@@@@@@@@%/////////////@@@
@@/////////////////@@@@@@@///////@@@@@@@/////////////////@@
@/////////////////////////////////////////////////////////@
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//////////@@/////////////////@/////////////////@@//////////
///////(@@@//////@///////////@///////////@//////@@@(///////
////@@@@@%////@@@///@@@@@/////@@////@@////@@@////@@@@@@////
///@@,,@@//@@@@@@/@@@@@@@@@///@@///@@@@@@/@@@@@@//@@,,@@///
@//@@,,,@@/@@@@@@@@@@@@@@@@///@@///@@@@@@@@@@@@@/@@,,,@@//@
@@/@@,,,@@@@@@@@@@@@@@@@@@///@@@//@@@@@@@@@@@@@@@@@,,,@@/@@
@@@/@@,,,@@@@@@@@@@@@@@@@@/@@/@@//@@@@@@@@@@@@@@@@,,,@@/@@@
@@@@@@@,,,@@@@@@@@@@@@@@@/@@//@@//@@@@@@@@@@@@@@@,,,@@@@@@@
@@@@@@@@,,,,@@@@@@@@@@@@/@@////@//@@@@@@@@@@@@@,,,,@@@@@@@@
@@@@@@@@@@,,,@@@@@@@@@@@/@&////@@//@@@@@@@@@@@,,,@@@@@@@@@@
@@@@@@@@@@@%,,,,@@@@@@@@@@//////(@@&@@@@@@@,,,,%@@@@@@@@@@@
@@@@@@@@@@@@@@,,,,,@@@@@@//////////@@@@@,,,,,@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@,,,,,,@@/////@////////@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@,,@(/#////@@@////////@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@//@//////@@@@@@////@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@/@@@/////////@@@//@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@/@@@@@@@@//////@%@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@///@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/@@@@@@@@@@@@@@@@@@@@@
```

## Installation

### docker configuration

Docker doit être installé sur la machine cible.

Le daemon docker doit être accessible via http (cf https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin, partie "Docker Environment")

Exemple de configuration dans le fichier /etc/default/docker

    DOCKER_OPTS="-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock"

Pour prendre en compte le changement dans /etc/default/docker, redémarrer docker

    sudo service docker restart

Pour vérifier que les paramètres sont bien pris en compte

    $ ps -eaf | grep docker
    root      6064     1  0 14:37 ?        00:00:00 /usr/bin/docker daemon -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock --raw-logs


### Génération du container master

    cd <workspace>
    git clone https://github.com/clevandowski/jenkins-phoenix.git
    cd master
    make build


## Démarrage du master

### Lancement du container

    # Le répertoire courant doit être master
    make run

  Une fois que le serveur affiche le message suivant...

    *************************************************************
    *************************************************************
    *************************************************************

    Jenkins initial setup is required. An admin user has been created and a password generated.
    Please use the following password to proceed to installation:

    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

    This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

    *************************************************************
    *************************************************************
    *************************************************************

  ... Lancer [jenkins dans l'explorateur](http://localhost:8080)


### Configuration de démarrage



