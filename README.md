# Docker Ledger S

This image can be used to compile (and, on Linux, load) Ledger Nano S and Blue applications. It uses an Ubuntu-based system with the official GCC-ARM and LLVM images, as well as the current stable Nano S and Blue SDKs.

In first time, please build Dockerfile using:
```
$ docker build -t docker-ledger-s .
```

To use the system for development, mount a volume containing your application at /home/workspace, and then build as normal. For example, if your application is built by a Makefile:

```
$ docker run -v `pwd`:/home/workspace -ti docker-ledger-s make
```

NOTE: Connection issues  
https://support.ledger.com/hc/en-us/articles/115005165269-Connection-issues-with-Windows-or-Linux