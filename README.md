[![Build Status](http://183.88.244.121:6100/api/badges/BananaCoding/genieacs-gui/status.svg)](http://183.88.244.121:6100/BananaCoding/genieacs-gui)

genieacs-gui
============

A GUI front end for GenieACS built with Ruby on Rails.

## Requirement
1. Ruby 2.5.0
2. GenieACS core
3. MongoDB

## GenieACS core
Install by npm, or go to https://genieacs.com/docs/ if you want more detail
```
npm install -g genieacs
```
Run northbound interface module, this must be running for the GUI front end
```
genieacs-nbi
```

## Installation

Clone this repo
```
git clone git@github.com:BananaCoding/genieacs-gui.git
```
Go to directory and bundle install
```
cd genieacs-gui
bundle install
```
Copy & Change config files
```
cp config/graphs-sample.json.erb config/graphs.json.erb
cp config/index_parameters-sample.yml config/index_parameters.yml
cp config/summary_parameters-sample.yml config/summary_parameters.yml
cp config/parameters_edit-sample.yml config/parameters_edit.yml
cp config/parameter_renderers-sample.yml config/parameter_renderers.yml
cp config/database.sample.yml config/database.yml
```
Setup database
```
rake db:reset
```
Run application
```
rails s
```
