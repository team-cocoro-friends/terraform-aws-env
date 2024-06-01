FROM ubuntu:22.04

# check terraform version: https://www.terraform.io/downloads.html
ARG TERRAFORM_VERSION=1.7.4
# check tflint version: https://github.com/terraform-linters/tflint/releases
ARG TFLINT_VERSION=0.50.3
# check trivy version: https://github.com/aquasecurity/trivy/releases
ARG TRIVY_VERSION=0.49.1

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN apt-get update \
  && apt-get -y install --reinstall ca-certificates \
  && apt-get -y install --no-install-recommends \
      curl \
      unzip \
      jq \
      git \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# install terraform, tflint
RUN cd /usr/local/bin \
    && if [[ -z "$TERRAFORM_VERSION" ]] ; then TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M ".current_version") ; else echo TERRAFORM_VERSION=$TERRAFORM_VERSION ; fi \
    && curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && rm -f terraform.zip \
    && curl -sSL https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip -o tflint_linux_amd64.zip \
    && unzip tflint_linux_amd64.zip \
    && rm tflint_linux_amd64.zip \
    && curl -sSL https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz -o trivy_Linux-64bit.tar.gz \
    && tar zxvf trivy_Linux-64bit.tar.gz \
    && rm trivy_Linux-64bit.tar.gz

# tflintの設定をルートディレクトリにコピー
ADD tflint/.tflint.hcl /root/
RUN cd /root/ \
   && tflint --init

# provider aws 5.44.0をローカルにmirrorする
RUN rm -rf /root/terraform && mkdir /root/terraform
ADD terraform-aws-5.44.0/main.tf /root/terraform/
RUN cd /root/terraform && terraform providers mirror /providers

# providerのダウンロード先をローカルファイルシステムに変更する
# ADD terraformrc/.terraformrc /root/

# install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# バージョンを出力
ADD post-start.sh /root/


