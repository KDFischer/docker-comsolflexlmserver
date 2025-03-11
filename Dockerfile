FROM debian:stable-slim
LABEL maintainer="Kasper D. Fischer <kasper.fischer@rub.de>"

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################
# add the flexlm commands to $PATH
ENV PATH="${PATH}:/opt/comsol_flexlm/glnxa64/"

#########################################
##         RUN INSTALL SCRIPT          ##
#########################################
ADD /files /usr/local/bin

RUN apt-get update \
    && apt-get install -y \
        lsb-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# lmadmin is required for -2 -p flag support
RUN addgroup --system lmadmin && \
    adduser --system  --no-create-home --ingroup lmadmin --disabled-password --disabled-login lmadmin

ADD --chown=lmadmin:lmadmin distrib/glnxa64tar.bz2 /opt/comsol_flexlm/
RUN chown -R lmadmin:lmadmin /opt/comsol_flexlm
RUN chmod 755 -R /opt/comsol_flexlm/glnxa64
RUN mkdir -p /tmp/.flexlm && chown lmadmin:lmadmin /tmp/.flexlm && ln -s /tmp /usr/tmp
RUN mkdir -p /usr/local/flexlm/licenses/ && chown lmadmin:lmadmin /usr/local/flexlm/licenses

#########################################
##              VOLUMES                ##
#########################################
VOLUME ["/usr/local/flexlm"]

#########################################
##            EXPOSE PORTS             ##
#########################################
EXPOSE 1718-1719

# do not use ROOT user
USER lmadmin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# no CMD, use container as if 'lmgrd'
