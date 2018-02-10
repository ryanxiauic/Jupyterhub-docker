FROM ubuntu:16.04
MAINTAINER Ryan Xia <ryanjwxia@uic.edu.hk>


RUN apt-get -y update && \
    apt-get -y install locales tzdata wget git bzip2

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' TZ='Asia/Hong_Kong'

RUN echo $TZ > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get install build-essential software-properties-common -y && \
    apt-get clean

# Install python2 and python 3 kernel

RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/conda.sh && \
    /bin/bash ~/conda.sh -b -p /opt/conda && \
    /opt/conda/bin/conda install --yes -c conda-forge \
     python=3.6 sqlalchemy tornado jinja2 traitlets requests pip pycurl \
      nodejs configurable-http-proxy && \
    /opt/conda/bin/pip install --upgrade pip && \
    rm ~/conda.sh

ENV PATH=/opt/conda/bin:$PATH

RUN pip install jupyterhub jupyter && \
    conda create --yes -n py2 python=2.7 ipykernel && \
    conda create --yes -n py3 python=3.6 ipykernel && \
    conda create --yes -n C 

RUN /bin/bash -c "source activate /opt/conda/envs/py2 && python -m ipykernel install" && \
    /bin/bash -c "source activate /opt/conda/envs/py3 && python -m ipykernel install" && \
    /bin/bash -c "source activate /opt/conda/envs/C && pip install notebook jupyter-c-kernel && install_c_kernel --sys-prefix"





EXPOSE 8000
LABEL org.jupyter.service="jupyterhub"

CMD [ "/bin/bash" ]