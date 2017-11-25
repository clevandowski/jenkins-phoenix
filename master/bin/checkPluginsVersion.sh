#!/bin/bash

getPluginLastVersion() {
  local myPluginId="" myPluginLastVersion=""
  myPluginId=$1

  # echo "plugin id: $myPluginId"
  myPluginLastVersion=$(curl -XGET https://plugins.jenkins.io/$myPluginId 2>/dev/null | grep '<h1 class="title"' | grep '<span class="v"' | sed -e 's|^.*<span class="v"[^>]*>\([^<]*\)</span>.*$|\1|')
  echo $myPluginLastVersion
}

checkContext() {
  if [ ! -e plugins.txt ]; then
    echo "No file plugins.txt found in current directory"
    exit 1
  fi
}

checkPlugins() {
  local myPluginId="" myPluginVersion="" myPluginUrl="" myPluginLastVersion="" myPluginIdAndVersion="" myDeprecatedPluginNumber=0
  while read myPluginIdAndVersion; do
    if [ -n "$myPluginIdAndVersion" ]; then 
      # echo "plugin id and version: $myPluginIdAndVersion"
      myPluginId=$(echo $myPluginIdAndVersion | cut -d: -f1)
      myPluginVersion=$(echo $myPluginIdAndVersion | cut -d: -f2)

      # echo "plugin id: $myPluginId"
      # echo "plugin version: $myPluginVersion"
      myPluginLastVersion=$(getPluginLastVersion $myPluginId)
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
