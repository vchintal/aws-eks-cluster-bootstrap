FROM --platform=linux/amd64 public.ecr.aws/lambda/provided:al2023

ARG CLUSTER_NAME
ENV CLUSTER_NAME=${CLUSTER_NAME}

ARG REGION
ENV REGION=${REGION}

RUN dnf -y install aws-cli && \
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv kubectl /usr/local/bin/

ADD bootstrap-manifests /bootstrap-manifests 

COPY bootstrap ${LAMBDA_RUNTIME_DIR}
COPY function.sh ${LAMBDA_TASK_ROOT}

CMD [ "function.handler" ]