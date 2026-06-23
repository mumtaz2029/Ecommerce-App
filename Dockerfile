# Build stage
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /usr/src/app

# Copy pom first for dependency caching
COPY pom.xml .

RUN mvn dependency:go-offline -B

# Copy source
COPY src ./src

# Build WAR
RUN mvn clean package -DskipTests


# Runtime stage
FROM tomcat:10.1-jdk21-temurin

WORKDIR /usr/local/tomcat/webapps/

COPY --from=builder /usr/src/app/target/*.war ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
