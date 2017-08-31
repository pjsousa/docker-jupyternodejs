# docker-jupyternodejs

Docker container with Jupyter installed with a nodejs kernel.


The node kernel itself is the work of [notablemind/jupyter-nodejs](https://github.com/notablemind/jupyter-nodejs)



The Jupyter server is configured to:
- use https
- create self signed ssl certificates
- listen on port 8888
- start on the container's path: /root/jupyterdata

Some other notes:
Besides the port 8888 in which jupyter runs, the container also exposes some other common ports. Which can be mapped from the host 
and then used by the notebooks' code.

```
   EXPOSE 8888 # jupyter runs here 
   EXPOSE 3000 # these are free
   EXPOSE 4000
   EXPOSE 5000
   EXPOSE 7357
   EXPOSE 8080
```

In order to spin a container in whichever current path you're in you can do:

```
   # jupyter is reachable on https://<your ip or domain name>:8888
   # `pwd` will use the current path as the working directory for the jupytre server
   docker run -it -p 8888:8888 -v `pwd`:/root/jupyterdata pjsousa/docker-jupyternodejs
```

Or, if we want to spin a server inside a notebook, we need to map some other port

```
   docker run -it -p 8888:8888 -p 3000:3000 -v `pwd`:/root/jupyterdata pjsousa/docker-jupyternodejs
```


In order to render html into a cell's output look [here](https://gist.github.com/jasonphillips/3ecfc221f8f931027c82511870727e34) and [here](https://github.com/notablemind/jupyter-nodejs/issues/21)
