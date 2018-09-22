FROM rails:latest

ARG GITHUB_TOKEN

RUN apt-get update
RUN gem install rdoc bundle
RUN mkdir -p /build/genieacs-gui

ADD . /build/genieacs-gui

WORKDIR /build/genieacs-gui
RUN cp config/graphs-sample.json.erb config/graphs.json.erb
RUN cp config/index_parameters-sample.yml config/index_parameters.yml
RUN cp config/summary_parameters-sample.yml config/summary_parameters.yml
RUN cp config/parameters_edit-sample.yml config/parameters_edit.yml
RUN cp config/parameter_renderers-sample.yml config/parameter_renderers.yml
RUN cp config/roles-sample.yml config/roles.yml
RUN cp config/users-sample.yml config/users.yml
RUN bundle

ENTRYPOINT ["rails", "s", "-b", "0.0.0.0"]
