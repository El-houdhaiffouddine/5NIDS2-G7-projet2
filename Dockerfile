FROM openjdk:8
LABEL authors="Ben Sidi El-houdhaiffouddine"
LABEL version="1.0.0"

RUN mkdir /tmp/docker/
RUN apt-get update && apt-get install net-tools -y
RUN apt-get install -y inetutils-ping traceroute
COPY target/5NIDS2-G7-projet2-1.0.0.jar /tmp/docker/
ENTRYPOINT ["java", "-jar", "/tmp/docker/5NIDS2-G7-projet2-1.0.0.jar"]
EXPOSE 8084