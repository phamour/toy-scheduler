FROM golang:1.17.6

WORKDIR /go/src/toy-gpu-scheduler
COPY . .
ARG GOPROXYCN
RUN GOPROXYCN=${GOPROXYCN} make build

FROM alpine:3.12

COPY --from=0 /go/src/toy-gpu-scheduler/bin/toy-gpu-scheduler /bin/toy-gpu-scheduler

WORKDIR /bin
CMD ["toy-gpu-scheduler"]
