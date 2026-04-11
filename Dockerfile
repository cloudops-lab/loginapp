FROM tomcat:9-jdk11-openjdk

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080