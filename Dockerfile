FROM ubuntu:20.04

# Define default arguments
ARG EXEC_ARG="/opt/sqldeveloper/sqldeveloper.sh"
ARG DISPLAY_ARG=":20"

# Environment variables
ENV DISPLAY ${DISPLAY_ARG}
# ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

# Install needed packages
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    unzip \
    x11vnc \
    xvfb

# Add (and expand) assets to /opt
ADD assets /opt
WORKDIR /opt

# Install SQLDeveloper from the zip
RUN unzip ./sqldeveloper-*.zip && rm -rf ./sqldeveloper-*.zip

# Install SQLDeveloper
RUN mkdir -p /data && chown -R $UID:$GID /data

# Describe moutable volumes and exposable ports
VOLUME ["/data"]
EXPOSE 5900

# Run the configuration script
RUN /opt/setup.sh "$EXEC_ARG" "$DISPLAY_ARG"

# Setup the default run command
CMD ["x11vnc", "-create", "-forever"]
