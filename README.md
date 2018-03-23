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
Setup database
```
rake db:reset
```
Run application
```
rails s
```
