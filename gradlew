#!/usr/bin/env bash

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##############################################################################
##
##  Gradle start up script for UN*X
##
##############################################################################

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> KATEX_INLINE_OPEN.*KATEX_INLINE_CLOSE$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`/" >/dev/null
APP_HOME="`pwd -P`"
cd "$SAVED" >/dev/null

APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"'

# Use the maximum available, or set MAX_FD != -1 to use that value.
MAX_FD="maximum"

warn () {
    echo "$*"
}

die () {
    echo
    echo "$*"
    echo
    exit 1
}

# OS specific support (must be 'true' or 'false').
cygwin=false
msys=false
darwin=false
nonstop=false
case "`uname`" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MINGW* )
    msys=true
    ;;
  NONSTOP* )
    nonstop=true
    ;;
esac

# For Cygwin, ensure paths are in UNIX format before anything is touched.
if $cygwin ; then
    [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
fi

# Attempt to find java
if [ -z "$JAVA_HOME" ] ; then
    JAVA_EXE=`which java 2>/dev/null`
    if [ -z "$JAVA_EXE" ] ; then
        die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
    fi
else
    JAVA_EXE="$JAVA_HOME/bin/java"
fi

if [ ! -x "$JAVA_EXE" ] ; then
    die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
fi

# Determine the Java version.
# We chose to just parse the output of 'java -version' instead of parsing the
# value of the java.version property. This is because we might be running against
# a JRE that is 1.7 or 1.8 but the JDK is 1.6. The goal is to determine the version
# of the JRE that will be used to execute Gradle.
# A Java version of '1.8.0_25' would be converted to '1.8'
# A Java version of '9.0.4' would be converted to '9'
# A Java version of '11.0.12' would be converted to '11'
JAVA_VERSION_STRING=$("$JAVA_EXE" -version 2>&1)
if [ $? -ne 0 ] || [ -z "$JAVA_VERSION_STRING" ]; then
    # Some issue with getting the version. Can happen on some platforms.
    # We will just assume it is a supported version.
    # This is what Gradle does as of 6.3
    true
else
    # First line is sufficient
    JAVA_VERSION_LINE=$(echo "$JAVA_VERSION_STRING" | head -n 1)
    # Some JREs prepend "Picked up..." message. Remove it.
    JAVA_VERSION_LINE=${JAVA_VERSION_LINE#Picked up*:}
    # Get the version string.
    # Should be the third word, but some JREs have more words.
    # So we take the last word that starts with a number.
    # e.g.
    #   java version "11.0.12" 2021-07-20
    #   openjdk version "11.0.12" 2021-07-20
    #   "1.8.0_322"
    #   "17"
    #   "17.0.2"
    for word in $JAVA_VERSION_LINE; do
        # Remove quotes
        word=${word#\"}
        word=${word%\"}
        case $word in
            [1-9]*)
                JAVA_VERSION=$word
                break
                ;;
        esac
    done
    # Convert to a major version.
    # e.g.
    #   1.8.0_322 -> 1.8
    #   11.0.12 -> 11
    #   17 -> 17
    #   17.0.2 -> 17
    JAVA_MAJOR_VERSION=$(echo "$JAVA_VERSION" | cut -d . -f 1)
    if [ "$JAVA_MAJOR_VERSION" -eq 1 ]; then
        # For Java 1.8
        JAVA_MAJOR_VERSION=$(echo "$JAVA_VERSION" | cut -d . -f 2)
    fi
fi

# Collect all arguments for the java command, following the shell quoting rules.
# This allows for options with spaces as part of the value.
# (Note: rather than using arrays, we use a string lists here,
# with a separator that is not allowed in file names.)
#
#   `a'b`   "c d"   -- becomes --
#   a\'b|c d|
#
# A simple `for` loop over the string list will break on spaces.
# Instead, we will use `read` to split the list at the separator.
#
# A trailing separator is added to the list, so that the `read`
# loop will execute once for the last element.
#
# The quoting is such that the separator will not be part of the value.
#
# This is a bit tricky, but it's the only way to do it correctly
# in a POSIX-compliant way.
#
# See https://stackoverflow.com/a/29906923/1688349
#
# As a small simplification, we do not allow the separator in the arguments.
# This should not be a problem in practice.
#
ARG_SEPARATOR="|"
if printf "%s" "$*" | grep -q "$ARG_SEPARATOR"; then
    die "ERROR: The arguments contain a character that is not allowed: '$ARG_SEPARATOR'"
fi
# Add the trailing separator
CMD_LINE_ARGS_LIST=$(printf "%s$ARG_SEPARATOR" "$@")

# Use Java 1.8 for Gradle < 5.0
# Use Java 9 for Gradle >= 5.0
# Use Java 11 for Gradle >= 7.0
# ... we will just rely on the wrapper to download a compatible version
# and let it fail if the Java version is not compatible.

# For Cygwin, switch paths to Windows format before running java
if $cygwin ; then
    APP_HOME=`cygpath --path --windows "$APP_HOME"`
    CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
fi

# Split up the JVM options only separated by spaces
JVM_OPTS=($DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS)
JVM_OPTS[${#JVM_OPTS[*]}]="-Dorg.gradle.appname=$APP_BASE_NAME"

# Escape the arguments for the `java` command.
# This is necessary because the arguments are passed as a single string.
# (Note: we could have used an array here, but that is not POSIX-compliant.)
JAVA_ARGS=
while IFS= read -r -d "$ARG_SEPARATOR" arg; do
    # Escape the argument for the shell
    # See https://stackoverflow.com/a/1250279/1688349
    arg_escaped=$(printf "%s" "$arg" | sed "s/'/'\\\\''/g")
    JAVA_ARGS="$JAVA_ARGS '$arg_escaped'"
done <<EOF
$CMD_LINE_ARGS_LIST
EOF

exec "$JAVA_EXE" "${JVM_OPTS[@]}" -classpath "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain $JAVA_ARGS
