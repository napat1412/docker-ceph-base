# docker-ceph-base

This dockerfile install ceph-base: luminous v12.2.5 & etcd v3.3.5.
These is no startup for run. User should run with interactive mode.

## Build
```bash
$ docker build -t local/ceph-base:luminous-v12.2.5  .
```

## Run
```
$ docker run -it --name ceph-base local/ceph-base:luminous-v12.2.5
```
