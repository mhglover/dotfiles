export PROJECT_HOME=$HOME/devel

export JAVA_HOME=$(/usr/libexec/java_home)

function rbwork () {
  # add rubyenv
  eval "$(rbenv init -)"
}