# Customer Distance

The geofence customer filter


## Development and Tests

If you have [asdf](https://github.com/asdf-vm/asdf) runtime manager installed
you may use following snippet to install all dependencies and run the filter

```sh
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install
```

Bundle installs required gems

```sh
bundle install
bundle exec bin/filter samples/customers
```

To run specs and linter checks

```sh
bundle exec rspec    # to check if no tests were failed
bundle exec rubocop  # to check if code properly formatted
```

## Docker

Docker is a quick way to start application with no development dependencies

```sh
docker build -t filterapp .
docker run --rm filterapp bin/filter samples/customers
```

In order to run test suits with Docker

```sh
docker build -f Dockerfile.dev -t filterapp-dev .
docker run --rm filterapp-dev bundle exec rspec
docker run --rm filterapp-dev bundle exec rubocop
```
