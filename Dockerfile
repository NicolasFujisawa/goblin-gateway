FROM ghcr.io/graalvm/native-image-community:25 AS builder

WORKDIR /app

RUN microdnf install -y maven && microdnf clean all

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn -Pnative -DskipTests native:compile

FROM bellsoft/alpaquita-linux-base:stream-glibc

WORKDIR /app

COPY --from=builder /app/target/goblin-gateway .
CMD ["./goblin-gateway"]