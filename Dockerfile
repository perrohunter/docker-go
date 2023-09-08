# Seleccionamos nuestra version de Go
FROM golang:1.21 as golayer

# Queremos los certificados raiz del internet para confiar en certificados TLS
RUN apt-get update -y && apt-get install -y ca-certificates

# Agregamos nuetro archivo de dependencias
ADD go.mod /go/src/perrohunter.com/docker/go.mod
# Seleccionamos un folder donde vamos a trabajar
WORKDIR /go/src/perrohunter.com/docker/

# instala las dependencias
RUN go mod download

# copiamos el resto del codigo
ADD . /go/src/perrohunter.com/docker/

# Apagamos CGO
ENV CGO_ENABLED=0

# Compilamos de forma estatica
RUN go build --tags=kqueue -ldflags "-w -s" -a -o app .

# agarramos un contenedor vacio
FROM scratch

# defininimos el puerto de neustra app
EXPOSE 8080

# Copiamos nuestra app y los certificados
COPY --from=golayer /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=golayer /go/src/perrohunter.com/docker/app .

# Creamos el punto de arranque del contenedor
ENTRYPOINT ["/app"]
