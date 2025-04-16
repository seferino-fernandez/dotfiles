# Java Configuration
jdk() {
    unset JAVA_HOME
    export JAVA_HOME=$(/usr/libexec/java_home -v "$1")
    java -version
}
# Default Java
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
