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


### Génération du container de Jenkins master

    cd <workspace>
    git clone https://github.com/clevandowski/jenkins-phoenix.git
    cd master
    make build


## Démarrage de Jenkins master

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

  ... Copier le code dans le clipboard et lancer [jenkins dans l'explorateur](http://localhost:8080)


### Initialisation de Jenkins

  Lors du 1er accès à Jenkins, la page "Unlock Jenkins" demande de saisir le mot de passe administrateur fourni dans le log de démarrage.

  Sur la page qui suit, "Getting started", choisir "Install Suggested Plugin" si vous n'avez pas de préférence particulière. L'installation des plugins se déroule juste après.

  Enfin, la dernière étape de l'initialisation requiert de saisir les informations du 1er utilisateur admin (login, password, nom complet & mail). Cliquer sur "Save and Continue". Cliquer ensuite sur "Start using Jenkins", ce qui amène finalement à la page d'accueil de Jenkins.


## Configuration de Jenkins master par l'UI

  Ouvrir la configuration de Jenkins, en cliquant sur le lien [Manage Jenkins](http://localhost:8080/manage), puis aller dans la configuration système, lien [Configure System](http://localhost:8080/configure).

  Dans la catégorie "Cloud", Ajout un cloud en sélectionnant "Add a new Cloud", "docker". Définir les paramètres suivants du cloud:

    Name:       jenkins-phoenix-cloud
    Docker URL: http://172.17.0.1:4243

  Tester la configuration en cliquant sur le bouton "Test Connection". La version de docker doit s'afficher à droite si la configuration est correcte.

  Sauvegarder la configuration en cliquant sur "Save" en bas de la page.
