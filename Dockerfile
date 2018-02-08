FROM jupyterhub/jupyterhub
MAINTAINER Ryan Xia <ryanjwxia@uic.edu.hk>


RUN pip install jupyter && \
    conda create --yes -n py2 python=2.7 ipykernel && \
    conda create --yes -n py3 python=3.6 ipykernel && \
    conda create --yes -n C

RUN source activate cling && \
    apt-get update && \
    apt-get install gcc && \
    conda install --yes cling -c QuantStack -c conda-forge && \
    conda install --yes xeus-cling -c QuantStack -c conda-forge && \
    conda install --yes notebook -c conda-forge && \
    source deactivate


RUN source activate py2 && \
    python -m ipykernel install && \
    source deactivate

RUN source activate py3 && \
    python -m ipykernel install && \
    source deactivate

WORKDIR /tmp
COPY ./ jupyter_c_kernel/
