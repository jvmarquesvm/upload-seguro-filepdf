#!/bin/sh
PRG="$0"
while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
DIR=`dirname "$PRG"`

WRAPPER_JAR="$DIR/.mvn/wrapper/maven-wrapper.jar"
WRAPPER_LAUNCHER="org.apache.maven.wrapper.MavenWrapperMain"

exec java "-Dmaven.multiModuleProjectDirectory=$DIR" -classpath "$WRAPPER_JAR" "$WRAPPER_LAUNCHER" "$@"
