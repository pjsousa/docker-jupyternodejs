FROM	ubuntu:latest

ENV HOME /root
ENV WORKON_HOME $HOME/.virtualenvs

RUN apt-get update
RUN apt-get upgrade

# install generic dev tools/libs
RUN apt-get install -y build-essential cmake pkg-config
RUN apt-get install -y libgtk-3-dev
RUN apt-get install -y libatlas-base-dev gfortran
RUN apt-get install -y python2.7-dev python3.5-dev
RUN apt-get install -y wget zip git


#install pip and jupyter
WORKDIR $HOME
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

RUN pip install jupyter
RUN rm -rf ~/get-pip.py ~/.cache/pip


# Install node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs


#install ZeroMq (its a prerequisite for jupyter-nodejs kernel)
RUN echo "deb http://download.opensuse.org/repositories/network:/messaging:/zeromq:/release-stable/Debian_9.0/ ./" >> /etc/apt/sources.list
RUN wget https://download.opensuse.org/repositories/network:/messaging:/zeromq:/release-stable/Debian_9.0/Release.key -O- | apt-key add
RUN apt-get install -y libzmq3-dev


#install jupyter-nodejs kernel
WORKDIR $HOME
RUN git clone https://github.com/notablemind/jupyter-nodejs.git
WORKDIR $HOME/jupyter-nodejs
RUN mkdir -p $HOME/.ipython/kernels/nodejs/
RUN npm install && node install.js
RUN npm run build
RUN npm run build-ext

#create our work dir 
RUN mkdir -p $HOME/jupyterdata
RUN mkdir -p $HOME/.jupyter

#put our config in place
COPY jupyter_notebook_config.py $HOME/.jupyter/jupyter_notebook_config.py
COPY run-server.sh $HOME/run-server.sh
RUN chmod 777 $HOME/run-server.sh

#create self signed certificates
RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout ~/.jupyter/selfcert.key  -out ~/.jupyter/selfcert.cert


EXPOSE 8888
EXPOSE 3000
EXPOSE 4000
EXPOSE 5000
EXPOSE 7357
EXPOSE 8080

# fireup the jupyter server when the container starts
CMD $HOME/run-server.sh
