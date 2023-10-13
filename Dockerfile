# Estágio de compilação
FROM ubuntu:latest AS build

RUN apt-get update
RUN apt-get install -y openjdk-17-jdk
RUN apt-get install -y maven

WORKDIR /app

# Copie apenas o arquivo pom.xml primeiro e faça o download das dependências
COPY pom.xml .
RUN mvn dependency:go-offline

# Copie o restante do código-fonte
COPY src src

# Compile o projeto
RUN mvn package

# Estágio de produção
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copie o arquivo JAR compilado a partir do estágio anterior
COPY --from=build /app/target/todolist-1.0.0.jar app.jar

EXPOSE 8080

# Comando de inicialização da aplicação
CMD ["java", "-jar", "app.jar"]
