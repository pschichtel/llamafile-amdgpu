ARG UBUNTU_CODENAME="focal"

FROM docker.io/library/ubuntu:${UBUNTU_CODENAME}

ARG UBUNTU_CODENAME
ARG AMDGPU_REPO_VERSION="6.1"

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y curl gnupg build-essential cmake

RUN echo "deb https://repo.radeon.com/amdgpu/${AMDGPU_REPO_VERSION}/ubuntu ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/amdgpu.list \
 && echo "deb http://repo.radeon.com/rocm/apt/${AMDGPU_REPO_VERSION}/ ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/rocm.list \
 && curl -sL http://repo.radeon.com/rocm/rocm.gpg.key | apt-key add -

RUN apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests rocm-llvm hipblas hip-samples rocm-device-libs

ENV PATH="${PATH}:/opt/rocm/bin"

RUN cd /opt/rocm/share/hip/samples/1_Utils/hipInfo \
 && cmake . \
 && make \
 && mv hipInfo /usr/local/bin \
 && make clean

RUN useradd --create-home -G video --shell /bin/bash llamafile

WORKDIR /home/llamafile

USER llamafile

