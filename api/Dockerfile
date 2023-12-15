# Usa una imagen base con Java 18 y Maven 3
FROM amazoncorretto:17

# Directorio de trabajo dentro del contenedor
WORKDIR /api

# Copia el código fuente de la aplicación al contenedor
COPY . /api

# Install necessary packages (if needed)
RUN yum update -y && yum install -y wget tar gzip

# Download and install Maven
RUN wget -q https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz \
    && tar -xzf apache-maven-3.6.3-bin.tar.gz -C /opt \
    && ln -s /opt/apache-maven-3.6.3 /opt/maven \
    && ln -s /opt/maven/bin/mvn /usr/local/bin/mvn \
    && rm apache-maven-3.6.3-bin.tar.gz


ENV DATABASE_URL postgresql://db:5432/postgres
ENV MAVEN_HOME /opt/maven
ENV M2_HOME /opt/maven
ENV PATH $MAVEN_HOME/bin:$PATH

# Compilar la aplicación con Maven
RUN mvn clean package

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "target/words.jar"]


EXPOSE 8080
