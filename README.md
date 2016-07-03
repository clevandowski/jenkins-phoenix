# jenkins-phoenix
Jenkins Master &amp; Slaves basés sur Docker avec persistance de la configuration dans le repository GIT 


```                               %%%%%%%%%%%%%%%%%                               
                         ,%%%%%%%%%%%%%%%%%%%%%%%%%%%,                         
                      %%%%%%%%                   %%%%%%%%                      
     ((((((((      %%%%%%(                           (%%%%%%       (((((((     
       ((((((((    %%%                                   %%%    ((((((((       
       ((((((((((                      ((((((,                ((((((((((       
      (((((((((((((                  ((((((                 (((((((((((((      
      ((((((((((((((             (((((((((                 ((((((((((((((      
     (((((((((((((((((              ((((((               (((((((((((((((((     
    ((((((((((((((((((((            (((((((            ((((((((((((((((((((    
   (((((((((((((((((((((((((     /((((((((((((    *(((((((((((((((((((((((((   
  (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((  
 ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((( 
(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
((((((((((((((( ((((((((((((((((((((((((((((((((((((((((((((((( (((((((((((((((
((((((((((((((  (((((((,((((((((((((((( (((((((((((((((,(((((((  ((((((((((((((
(((((((((((    *((((((( ((((((((((((((( *(((((((((((((( (((((((/    (((((((((((
((((((*       (((((((   ((((((   (((((((  (((((( ((((((   (((((((       /((((((
(((((   %%   (((/      ((          (((((,  (((((     (((      /(((   %%   (((((
,(((   %%%   ((        (             (((   ((((        (        ((   %%%   (((,
 (((   %%%   ((                     .(((   (((                  ((   %%%   ((( 
  ((   %%%%   ,                     (((    (((                  ,   %%%%   ((  
   ((   %%%%                       (((     ((                      %%%%   ((   
     (  ,%%%*                     ((/  (  ,((                     *%%%,  (     
      (  (%%%%                   *(,  ((   ((                    %%%%(  (      
           %%%%                  (,  ((((  ((                   %%%%           
            %%%%.               ((  (((((   ((                .%%%%            
             #%%%%              (  (((((((   (               %%%%#             
               %%%%%,              ((((((((               *%%%%%               
                 %%%%%%           (((((((((((           %%%%%%                 
                    %%%%%%%      ((((((((((((((((      %%%%                    
                       %%%%%%%(  (((((((  (((((((((((                          
                           %%%   ((((((((    (((((((((((                       
                                 (* ((((((         ((((((                      
                                 (*  ((((((((((.      (((                      
                                 ((    (((((((((((((   ((                      
                                  (         (((((((((                          
                                   (            (((((                          
                                                 ,((*                          
                                                 ((                            
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


### Récupération du repository GIT

    cd <workspace>
    git clone https://github.com/clevandowski/jenkins-phoenix.git

### Génération du container de Jenkins master

    cd master
    make test

### Génération du container de Jenkins slave

    cd slave
    make test


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


### Initialisation de Jenkins master

  Lors du 1er accès à Jenkins, la page "Unlock Jenkins" demande de saisir le mot de passe administrateur fourni dans le log de démarrage.

  Sur la page qui suit, "Getting started", choisir "Install Suggested Plugin" si vous n'avez pas de préférence particulière. L'installation des plugins se déroule juste après.

  Enfin, la dernière étape de l'initialisation requiert de saisir les informations du 1er utilisateur admin (login, password, nom complet & mail). Cliquer sur "Save and Continue". Cliquer ensuite sur "Start using Jenkins", ce qui amène finalement à la page d'accueil de Jenkins.


## Configuration de Jenkins master par l'UI

### Création d'un cloud Docker

  Ouvrir la configuration de Jenkins, en cliquant sur le lien [Manage Jenkins](http://localhost:8080/manage), puis aller dans la configuration système, lien [Configure System](http://localhost:8080/configure).

  Dans la catégorie "Cloud", Ajout un cloud en sélectionnant "Add a new Cloud", "docker". Définir les paramètres suivants du cloud:

    Name:       jenkins-phoenix-cloud
    Docker URL: http://172.17.0.1:4243

  Tester la configuration en cliquant sur le bouton "Test Connection". La version de docker doit s'afficher à droite si la configuration est correcte.

  Sauvegarder la configuration en cliquant sur "Save" en bas de la page.

### Création d'un docker template

  Définir les propriétés comme suit:

    Docker Image:               clevandowski/jenkins-phoenix-slave
    Instance Capacity:          4
    Remote Filing System Root:  /home/jenkins
    Labels:                     jenkins-slave
    Usage:                      Only build jobs with label expression matching this node
    Availability:               Experimental: Docker Cloud Retention Strategie
      Idle timeout:               5
    \# of executors:            1
    Launch method:              Docker SSH computer launcher
      Credentials:              jenkins/jenkins
      Port:                       22
      Maximum Number of Retries:  0
      Seconds To Wait Between Retries:  0
    Pull strategy:              Pull once and update latest

### Création d'un job de test

  Créer un nouveau job freestyle.
  Cocher l'option "Docker Container". Vérifier que la sous-option "Clean local images" est bien cochée.
  Cocher l'option "Restrict where this project can be run", et indiquer "jenkins-slave" dans "Label Expression".

  Définir une tache de build simple, par exemple un build "Execute shell" qui va lancer la commande "ls -al"

  Sauvegarder et déclencher le job. Après quelques secondes, le container est provisionné, le script est exécuté. On peut voir la console dans l'historique du job.