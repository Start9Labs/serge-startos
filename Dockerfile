FROM ghcr.io/serge-chat/serge:main as main

FROM ghcr.io/serge-chat/serge:latest
WORKDIR /usr/src/app
RUN rm -rf ./api

COPY --from=main /usr/src/app/api /usr/src/app/api
RUN sed -i 's/llama-cpp-python==0.1.66/llama-cpp-python==0.1.78/g' /usr/src/app/deploy.sh
 
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl dumb-init && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD ./health.sh /usr/local/bin/health.sh
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/*.sh
