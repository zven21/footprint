
# FootPrint

**Track changes to your database with Ecto**

## Table of contents

* [Getting started](#getting-started)
* [TODO](#todo)
* [Demo](#demo)
* [Contributing](#contributing)
* [Make a pull request](#make-a-pull-request)
* [License](#license)
* [Credits](#credits)

## Getting started

* The package can be installed by adding `footprint` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:footprint, "~> 0.3.0"}
  ]
end
```

* Add the Repo of your app and the desired per_page to the `footprint` configuration in `config.exs`:

```elixir
config :footprint, repo: MyApp.Rep
```

## TODO

* [x] Build `Footprint.insert(changeset)` func.
* [x] Build `Footprint.update(changeset)` func.
* [x] Build `Footprint.delete(changeset)` func.
* [x] Gets a object all version.
* [ ] Diff object version.
* [ ] Apply one operation.
* [x] Support meta info.
* [x] Add event and inspect output.


## Demo

The dummy app shows a simple turbo_ecto example.

Clone the repository.

```bash
https://github.com/zven21/footprint.git
```

Change directory

```bash
$ cd dummy
```

Run mix

```bash
$ mix deps.get && yarn --cwd=assets
```

Preparing database

```bash
$ mix ecto.setup
```

Start the Phoenix server

```bash
$ ./script/server
```

Open your browser, and visit `http://localhost:4000`

## Contributing

Bug report or pull request are welcome.

### Make a pull request

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please write unit test with your code if necessary.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


## Credits

* [paper_trail](https://github.com/izelnakri/paper_trail) - Similar implementation.