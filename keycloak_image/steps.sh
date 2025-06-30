docker image build . -t chustos.io/keycloak/stripped:26.2.5 -f Dockerfile;
docker container run --rm chustos.io/keycloak/stripped:26.2.5;

#docker image build . -t chustos.io/keycloak/stripped2:26.2.5 -f Dockerfile.scratch;

#trivy image quay.io/keycloak/keycloak:26.2.5-0;

# GraalVM JDK with Native Image
#docker pull container-registry.oracle.com/graalvm/native-image:21

# GraalVM JDK without Native Image
#docker pull container-registry.oracle.com/graalvm/jdk:21

# docker image pull quay.io/quarkus/ubi9-quarkus-graalvmce-builder-image:jdk-21