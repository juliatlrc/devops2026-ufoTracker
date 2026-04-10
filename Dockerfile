# ============================================================
# Dockerfile – ufoTracker (Spring Boot / Java 21 / Maven)
# ============================================================

# Etapa 1: Build com Maven
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# Copia o wrapper e o pom antes do código para aproveitar cache de camadas
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw dependency:go-offline -q

# Copia o código-fonte e realiza o build
COPY src ./src
RUN ./mvnw package -DskipTests -q

# ============================================================
# Etapa 2: Imagem final enxuta
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copia apenas o JAR gerado na etapa de build
COPY --from=builder /app/target/*.jar app.jar

# Porta utilizada pelo Spring Boot
EXPOSE 8080

# Ponto de entrada da aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]


