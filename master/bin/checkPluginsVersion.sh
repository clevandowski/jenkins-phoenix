#!/bin/bash
#
# Exemple de format (sans le "#" devant bien sur)
#
#script-security:1.22 # https://wiki.jenkins-ci.org/display/JENKINS/Script+Security+Plugin

getPluginLastVersion() {
  local myPluginUrl="" myPluginLastVersion=""
  myPluginUrl=$1

  # echo "plugin url: $myPluginUrl"

  myPluginLastVersion=$(curl -XGET $myPluginUrl 2>/dev/null | grep "http://updates.jenkins-ci.org/latest" | sed -e "s/^.*<a href=\"http:\/\/updates.jenkins-ci.org\/latest\/[^>]\+>\([^<]\+\).*$/\1/")
  echo $myPluginLastVersion
}

checkContext() {
  if [ ! -e plugins.txt ]; then
    echo "No file plugins.txt found in current directory"
    exit 1
  fi
}

checkPlugins() {
  local myPluginId="" myPluginVersion="" myPluginUrl="" myPluginLastVersion="" myPluginIdAndVersion="" myComment="" myDeprecatedPluginNumber=0

  > plugins.new.txt
  # myComment c'est toujours le caractère "#"
  while read myPluginIdAndVersion myComment myPluginUrl; do
    if [ -n "$myPluginIdAndVersion" ] && [ -n "$myPluginUrl" ]; then 
      # echo "plugin id and version: $myPluginIdAndVersion"
      # echo "plugin url: $myPluginUrl"
      myPluginId=$(echo $myPluginIdAndVersion | cut -d: -f1)
      myPluginVersion=$(echo $myPluginIdAndVersion | cut -d: -f2)

      # echo "plugin id: $myPluginId"
      # echo "plugin version: $myPluginVersion"
      # echo "plugin url: $myPluginUrl"
      myPluginLastVersion=$(getPluginLastVersion $myPluginUrl)
      # echo "plugin last version: $myPluginLastVersion"

      echo "plugin: $myPluginId, current version: $myPluginVersion, last version: $myPluginLastVersion"
      if [ "$myPluginVersion" != "$myPluginLastVersion" ]; then
        ((myDeprecatedPluginNumber++))
      fi
      echo "$myPluginId:$myPluginLastVersion # $myPluginUrl" >> plugins.new.txt
    else
      echo "Erreur: format inconnu. Exemple de format:"
      echo "script-security:1.22 # https://wiki.jenkins-ci.org/display/JENKINS/Script+Security+Plugin"
      exit 1
    fi
  done < plugins.txt
  echo "Nb plugin to update: $myDeprecatedPluginNumber" 
  echo "New config file written in plugins.new.txt. Overwrite the current file plugins.txt in order to use the latest plugins version."
}

main() {
  checkContext $@
  checkPlugins
}

main
