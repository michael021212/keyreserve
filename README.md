# KEY RESERVE


## Servises
- こちらはKEY STATIONで使える会議室などの予約システムです

## Features

### アプリケーションサーバー

- puma

### デプロイ

- capistrano

### ユーザー認証

- sorcery

### テンプレートエンジン

- bootstrap_form_for

### CSSフレームワーク

- Bootstrap3(Sass)
- Fontawesome
- [adminlte2](https://almsaeedstudio.com/themes/AdminLTE/documentation/index.html)

### アップロード

- carrierwave

### バックグラウンドジョブ

- activejob

### その他

- See `Gemfile`.

### 日付/時間フォーマット

- config/initializers/time_formats.rb にあります
---

## Ruby version

- See `.ruby-version`.

## Rails version

- See `Gemfile`.

## System dependencies

- MySQL >= 5.5
- Redis

## Project initiation

- リポジトリのクローン

```bash
$ git@github.com:hisaju/keyreserve.git
```

- Gemのインストール

```bash
$ bundle install --path vendor/bundle
```

### Configuration

*ファイルの中身はご自身の環境に合わせて適宜変更してください*

- データベースの設定

```bash
$ cp config/database.yml.default config/database.yml
```

- 環境変数の設定

```bash
$ cp .env.default .env
```

*AWSのアクセスキーなどは個別に担当者に聞いてください。*

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
$ spring rspec spec/[対象ファイル]
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
- provide(:title, 'ページタイトル')
```
