### CharityAPI

CharityAPI is a Ruby on Rails API project that provides data from the Ethereum blockchain for [Charity frontend application](https://github.com/rubyruby/charity).

Description in English: [https://medium.com/@rubyruby.ru/dive-into-ethereum-development-part-3-user-application-107f0a6e5190](https://medium.com/@rubyruby.ru/dive-into-ethereum-development-part-3-user-application-107f0a6e5190)

Description in Russian: [https://habrahabr.ru/post/339080/](https://habrahabr.ru/post/339080/)

### Local Dev Setup

Install [Ruby](https://www.ruby-lang.org/en/documentation/) language version 2.2.2 or newer.

Clone the project and  the project folder.

```
git clone git@github.com:rubyruby/charity-api.git
cd charity-api
```

Create config/database.yml and config/secrets.yml with the correct settings. This project uses PostgreSQL as a database server but you are free to use anything else.

Install Bundler to manage the project dependencies.

```
gem install bundler
```

Install dependencies:

```
bundle install
```

Create a database and run the migrations
```
rails db:create
rails db:migrate
```

Start dev server:

```
rails s
```

Now the server is ready to serve requests from a [Charity frontend application](https://github.com/rubyruby/charity).

**Important:** To be able to connect to the Ethereum blockchain you need [Geth](https://github.com/ethereum/go-ethereum/wiki/geth) to be installed and running on your machine. Install Geth, start it and wait for it to synchronize.

```
geth --testnet
```
