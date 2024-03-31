FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubi8 as nvidia-builder
RUN yum install -y python3.9 && yum clean all && rm -rf /var/cache/yum/*


FROM nvidia-builder as build
RUN mkdir /project
WORKDIR /project
COPY . /project
RUN pip3 install -r requirements.txt
RUN python3 setup.py build 
RUN python3 setup.py install 


FROM nvidia-builder as environment
RUN mkdir /project
WORKDIR /project
COPY --from=build /project/dist/* .
RUN easy_install-3 *.egg
COPY run.sh /run.sh
ENTRYPOINT ["/usr/bin/bash", "/run.sh"]
