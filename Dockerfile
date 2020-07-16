FROM golang:1.14.2-alpine as build
ARG SSH_PRIVATE_KEY


# No git, ssh-keyscan in golang alpine
#RUN apk --update add --no-cache --virtual .build-deps \
#  git \
#  openssh

WORKDIR /go/src/github.com/helloworld

ADD . /go/src/github.com/helloworld
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o helloworld

RUN ls -al

# Cleanup
#RUN apk del .build-deps \
#  && rm -rf /root/.ssh

FROM golang:1.14.2-alpine
COPY --from=build /go/src/github.com/helloworld/helloworld /helloworld

RUN chmod +x /helloworld

RUN ls -al /helloworld

CMD ["/helloworld"]
