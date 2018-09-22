FROM rails:latest

ARG GITHUB_TOKEN

RUN git config --global url."https://${GITHUB_TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/"
RUN apt-get update && apt-get install -y -q git
RUN gem install rdoc bundle
RUN mkdir /build

WORKDIR	/build
RUN git clone https://github.com/utilitywarehouse/genieacs-gui.git

WORKDIR /build/genieacs-gui
RUN cp config/graphs-sample.json.erb config/graphs.json.erb
RUN cp config/index_parameters-sample.yml config/index_parameters.yml
RUN cp config/summary_parameters-sample.yml config/summary_parameters.yml
RUN cp config/parameters_edit-sample.yml config/parameters_edit.yml
RUN cp config/parameter_renderers-sample.yml config/parameter_renderers.yml
RUN cp config/roles-sample.yml config/roles.yml
RUN cp config/users-sample.yml config/users.yml
RUN bundle

ENTRYPOINT ["rails", "s"]
