FROM openjdk:10-jdk as build-step
WORKDIR /workspace
COPY demo/build.gradle demo/settings.gradle demo/gradlew /workspace/
COPY demo/gradle/ /workspace/gradle/
RUN ./gradlew resolveDependencies
COPY demo /workspace
RUN ./gradlew bootJar

FROM openjdk:10-jre
COPY --from=build-step /workspace/build/libs/demo-0.0.1-SNAPSHOT.jar /demo.jar
COPY prepare.sh /prepare.sh

ENV PROFILE docker

ENTRYPOINT ["/prepare.sh"]
CMD ["java","-jar","demo.jar"]