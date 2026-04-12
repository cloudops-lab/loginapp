FROM maven:3.9.9-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy only pom first (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy full source
COPY . .

# Build WAR
RUN mvn clean package -DskipTests


# -------------------------
# Stage 2: Runtime (Tomcat)
# -------------------------
FROM tomcat:9-jdk11-temurin-jammy

# Create non-root user
RUN useradd -u 1001 -r -g root tomcat

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from builder stage
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/AccountLogin.war

# Fix permissions
RUN chown -R 1001:0 /usr/local/tomcat

# Switch user
USER 1001

EXPOSE 8080
