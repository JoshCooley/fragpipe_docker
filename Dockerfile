# 3.9.16-bullseye linux/amd64
FROM python@sha256:1f1b3b271a5839cf9437ef077d74b795c3f92dc700bf4d430752d652d75b13e9

ARG FRAGPIPE_SHA256=fd58b6fdccea0c41fb5ee46d849a6867acb69c166c2d826c8ab9b58e35ec982a
ARG FRAGPIPE_VERSION=19.0
ARG IONQUANT_SHA256=10169a092d157c83d75acc0c2d1bd22378556bdb2f20c5b45aad325f45593d4c
ARG IONQUANT_VERSION=1.8.9
ARG MSFRAGGER_SHA256=ba2f97ba979e8542dd940ba08ce1f41b3620c7e49f7455092f00cd0debb5ca67
ARG MSFRAGGER_VERSION=3.6

SHELL [ "/bin/bash", "-c" ]

RUN apt-get update \
  && apt-get install --no-install-recommends --yes \
    curl=7.74.0-1.3+deb11u3 \
    mono-devel=6.8.0.105+dfsg-3.2 \
    openjdk-17-jre=17.0.4+8-1~deb11u1 \
    unzip=6.0-26+deb11u1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN [ "pip", "install", "--no-cache-dir", \
      "biopython==1.80", \
      "easypqp==0.1.35", \
      "lxml==4.9.2", \
      "matplotlib==3.6.2", \
      "numpy==1.24.0", \
      "pandas==1.5.2", \
      "pyopenms==2.7.0", \
      "scikit-learn==1.2.0", \
      "scipy==1.9.3", \
      "seaborn==0.12.1", \
      "statsmodels==0.13.5" \
    ]

RUN curl --fail --location --output FragPipe.zip \
      "https://github.com/Nesvilab/FragPipe/releases/download/${FRAGPIPE_VERSION}/FragPipe-${FRAGPIPE_VERSION}.zip" \
  && sha256sum FragPipe.zip \
      <<< "${FRAGPIPE_SHA256}  FragPipe.zip" \
  && unzip FragPipe.zip -d /opt/ \
  && rm FragPipe.zip \
  && curl 'https://msfragger.arsci.com/upgrader/upgrade_download.php' \
    --data "agreement1=on&agreement2=on&agreement3=on&download=Release ${MSFRAGGER_VERSION}\$zip&email=&name=&organization=&submit=Download&transfer=academic" \
    --fail -X POST \
    --output MSFragger.zip \
  && sha256sum MSFragger.zip \
      <<< "${MSFRAGGER_SHA256}  MSFragger.zip" \
  && unzip MSFragger.zip -d /opt/fragpipe/tools/ \
  && rm MSFragger.zip \
  && curl 'https://msfragger.arsci.com/ionquant/upgrade_download.php' \
    --data "agreement1=on&download=${IONQUANT_VERSION}\$zip&email=&name=&organization=&submit=Download&transfer=academic" \
    --fail -X POST \
    --output IonQuant.zip \
  && sha256sum IonQuant.zip \
      <<< "${IONQUANT_SHA256}  IonQuant.zip" \
  && unzip IonQuant.zip -d /opt/fragpipe/tools/ \
  && rm IonQuant.zip

ENV FRAGPIPE_VERSION=${FRAGPIPE_VERSION}
ENV MSFRAGGER_VERSION=${MSFRAGGER_VERSION}
ENV IONQUANT_VERSION=${IONQUANT_VERSION}

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]