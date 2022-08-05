# Uncomment and edit the line below to define JRE_HOME.
# If you use the Bitbucket installer, this value will be automatically set to point to the bundled JRE.
# Once a value is set here, existing JRE_HOME and JAVA_HOME values set in the environment will be overridden and ignored.
# JRE_HOME=

JAVA_HOME="/opt/JAVA/jdk-18.0.1.1/"

export JAVA_HOME


# Otherwise, use an existing installed JDK defined by JAVA_HOME
if [ -z "$JRE_HOME" ]; then
    if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/jre/bin/java" ]; then
        # If JAVA_HOME points to a valid JDK, use its JRE
        JRE_HOME="$JAVA_HOME/jre"
    elif [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
        # If JAVA_HOME appears to point to a JRE and not a JDK use this anyway
        JRE_HOME="$JAVA_HOME"
    fi
fi

# By this line, JRE_HOME should be defined
if [ -z "$JRE_HOME" ]; then
    echo "Neither the JAVA_HOME nor the JRE_HOME environment variable is defined"
    echo "Edit set-jre-home.sh and define JRE_HOME"
    return 1
fi

if [ -n "$JRE_HOME" ] && [ -x "$JRE_HOME/bin/java" ]; then
    # Found java executable in JRE_HOME
    JAVA_BINARY="$JRE_HOME/bin/java"
    JAVA_VERSION=$("$JAVA_BINARY" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    if [ "$JAVA_VERSION" \< "1.8" ]; then
        echo "JRE_HOME '$JRE_HOME' is Java $JAVA_VERSION"
        echo "Atlassian Bitbucket requires Java 8 to run"
        echo "Set JRE_HOME to a Java 8 JRE and try again"
        return 1
    fi
else
    # If JRE_HOME/bin/java is not an executable, JRE_HOME is not valid
    echo "The JRE_HOME environment variable is not defined correctly"
    echo "This environment variable is needed to run this program"
    echo "Edit set-jre-home.sh and define JRE_HOME"
    return 1
fi

# This ensures that JAVA_HOME and JRE_HOME are consistent so that
# both Bitbucket and the bundled search server use the same JVM.
JAVA_HOME=$JRE_HOME

# If we make it here, the Java environment looks good
export JRE_HOME
export JAVA_HOME
export JAVA_BINARY
export JAVA_VERSION
