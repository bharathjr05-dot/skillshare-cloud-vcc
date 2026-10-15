FROM maven:3.9-eclipse-temurin-8 AS build
WORKDIR /workspace
COPY pom.xml .
COPY WEB-INF ./WEB-INF
COPY WebContent ./WebContent
RUN mvn -B package

FROM tomcat:9.0-jdk8-temurin
ENV PORT=10000
COPY --from=build /workspace/target/skillshare-cloud-vcc-1.0.0.war /usr/local/tomcat/webapps/ROOT.war
COPY docker-entrypoint.sh /usr/local/bin/skillshare-entrypoint.sh
RUN chmod +x /usr/local/bin/skillshare-entrypoint.sh
EXPOSE 10000
CMD ["/usr/local/bin/skillshare-entrypoint.sh"]
