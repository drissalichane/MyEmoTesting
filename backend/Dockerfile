# Backend Dockerfile for Jakarta EE application

FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage with WildFly
FROM quay.io/wildfly/wildfly:29.0.1.Final-jdk17

# Copy WAR file
COPY --from=build /app/target/myemohealth-api.war /opt/jboss/wildfly/standalone/deployments/

# Add PostgreSQL JDBC driver
RUN curl -o /opt/jboss/wildfly/standalone/deployments/postgresql.jar \
    https://jdbc.postgresql.org/download/postgresql-42.6.0.jar

# Create admin user for WildFly
RUN /opt/jboss/wildfly/bin/add-user.sh admin admin123 --silent

# Expose ports
EXPOSE 8080 9990

# Start WildFly
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
