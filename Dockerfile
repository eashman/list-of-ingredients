FROM ruby:2.3.3
MAINTAINER CoPlannery

RUN apt-get update -y

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install base dependencies
RUN apt-get update && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        && rm -rf /var/lib/apt/lists/*

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.3.0

# Install nvm + node
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.20.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/v$NODE_VERSION/bin:$PATH

ENV WORK_DIR /opt/coplannery

RUN mkdir -p $WORK_DIR
WORKDIR $WORK_DIR

ADD Gemfile $WORK_DIR
ADD Gemfile.lock $WORK_DIR

RUN bundle install

ADD . $WORK_DIR

RUN cd client && npm install
