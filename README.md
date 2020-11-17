# Customer Distance

The geofence customer filter

## Setup and Run

If you have [asdf](https://github.com/asdf-vm/asdf) runtime manager installed
you may use following snippet to install all dependencies and run the filter

```sh
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git

asdf install

bundle exec bin/filter samples/input.txt
```

Docker option is also available

```sh
docker build -t filterapp .
docker run --rm filterapp bin/filter samples/input.txt
```

## Development and Test

With your local `asdf` manager run

```sh
bundle exec rspec    # to check if no tests were failed
bundle exec rubocop  # to check if code properly formatted
```

With your Docker envionment

```sh
docker run bundle rspec
docker run bundle rubocop
```
