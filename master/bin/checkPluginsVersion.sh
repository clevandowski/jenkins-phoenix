#!/bin/bash

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
    fi
  done < plugins.txt
  echo "Nb plugin to update: $myDeprecatedPluginNumber" 
  if [ $myDeprecatedPluginNumber -eq 0 ]; then
    exit 0
  else
    exit 1
  fi
}

main() {
  checkContext $@
  checkPlugins
}

main
