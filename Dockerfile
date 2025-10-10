# Use official Tomcat 10 with JDK 17
FROM tomcat:10.1-jdk17

# Remove default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your WAR file into Tomcat webapps directory
COPY target/clinique-digitale.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]