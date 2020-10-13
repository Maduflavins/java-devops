FROM java:8-jdk-alpine
VOLUME /tmp
EXPOSE 8082
RUN mkdir -p /app/
RUN mkdir -p /app/logs
ADD ./target/spring-boot-rest-api-tutorial-0.0.1-SNAPSHOT.jar /app/app.jar
WORKDIR /usr/app

RUN sh -c 'touch 'spring-boot-rest-api-tutorial-0.0.1-SNAPSHOT.jar'

ENTRYPOINT ["java", "-jar", "spring-boot-rest-api-tutorial-0.0.1-SNAPSHOT.jar"]
