FROM golang:1.17.6

WORKDIR /go/src/toy-scheduler
COPY . .
ARG GOPROXYCN
RUN GOPROXYCN=${GOPROXYCN} make build

FROM alpine:3.12

COPY --from=0 /go/src/toy-scheduler/bin/toy-scheduler /bin/toy-scheduler

WORKDIR /bin
CMD ["toy-scheduler"]
