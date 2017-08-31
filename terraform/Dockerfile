FROM hashicorp/terraform:0.10.0
RUN apk add --no-cache bash

ARG USER
ARG USER_ID

ARG GROUP
ARG GROUP_ID

ENV USER_ID $USER_ID
ENV USER $USER

ENV GROUP_ID $GROUP_ID
ENV GROUP $GROUP

ENV USER_HOME /home/${USER}

#ENV TF_LOG DEBUG

COPY ./dockerfile-init.sh /
RUN chmod a+x /dockerfile-init.sh
RUN  /dockerfile-init.sh

USER ${USER}

ENTRYPOINT ["/bin/terraform"]
