# KEY RESERVE


## Servises
- This is a reservation system for meeting rooms, etc that is used with KEY STATION.

## Features

### Application Server

- puma

### Deploy

- capistrano

### User Certification

- sorcery

### Design Template Engine

- bootstrap_form_for

### CSS Framework

- Bootstrap3(Sass)
- Fontawesome
- [adminlte2](https://almsaeedstudio.com/themes/AdminLTE/documentation/index.html)

### Upload

- carrierwave

### Background Job

- activejob

### The Others

- See `Gemfile`.

### Date/Time Format

- It's in `config/initializers/time_formats.rb`
---

## Ruby version

- See `.ruby-version`.

## Rails version

- See `Gemfile`.

## System dependencies

- MySQL >= 5.5
- Redis

## Project initiation

- Clone the Repositry

```bash
$ git@github.com:keeyls/keyreserve.git
```

- Install the right version of Ruby and Bundler.

- Install Gems

```bash
$ bundle install --path vendor/bundle
```

### Configuration

*Please change the contents of the file according to your own environment.*

- Database Settings

```bash
$ cp config/database.yml.default config/database.yml
```

- Setting Environment Variables

```bash
$ cp .env.default .env
```

*Please ask the person in charge of the AWS access key etc if you need it and add it to these files.*

### Database creation

```bash
$ rake db:create db:migrate
```

### Database initialization

```bash
$ rake db:seed_fu
```

## Run rails server

```bash
$ bundle exec rails server
```

## How to run the test suite

```bash
$ spring rspec spec/[Target File]
```

## CI as a service

- [CircleCI](https://circleci.com/)

## Development controller

### Setup Spring
```
$ spring binstub --all
$ bin/spring status
$ direnv allow
```

## Development tasks

### Reset database

- Execute db:drop, db:db:create, db:migrate, db:seed_fu

### Page title helper

- See `app/helpers/application_helper.rb`

```
/! layout
title = current_title(yield(:title))

/! template
- provide(:title, 'page title')
```
