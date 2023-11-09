# `jekyll_archive_create` [![Gem Version](https://badge.fury.io/rb/jekyll_archive_create.svg)](https://badge.fury.io/rb/jekyll_archive_create)


This is a Jekyll plugin that makes tar or zip files based on `_config.yml` entries.

In production mode, the archives are built each time Jekyll generates the website.

In development mode, the archives are only built if they do not already exist,
or if `delete: true` is set for that archive in `_config.yml`.
Archives are placed in the top-level of the Jekyll project, and are copied to `_site` by Jekyll's normal build process.
Entries are created in `.gitignore` for each of the generated archives.


## Usage

This plugin supports 4 types of file specifications:

* Absolute filenames (start with `/`).
* Filenames relative to the top-level directory of the Jekyll website
  (do not preface with `.` or `/`).
* Filenames relative to the user home directory (preface with `~`).
* Executable filenames on the PATH (preface with `!`).


## `_config.yml` Syntax

Any number of archives can be specified. Each archive has 3 properties: `archive_name`,
`delete` (defaults to true) and `files`.
Take care that the dashes have exactly 2 spaces before them,
and that the 2 lines following each dash have exactly 4 spaces in front.

```yaml
make_archive:
  -
    archive_name: cloud9.zip
    delete: true  # This is the default, and need not be specified.
    files: [ index.html, 404.html, ~/.ssh/config, /etc/passwd, '!date' ]
  -
    archive_name: cloud9.tar
    delete: false  # Do not overwrite the archive if it already exists
    files: [ index.html, 404.html, ~/.ssh/config, /etc/passwd, '!date' ]
```

The file called `date` contains the executable program or script of that name.


## Additional Information

More information is available on my website about
[my Jekyll plugins](https://mslinn.com/jekyll/3000-jekyll-plugins.html#archive_create).


## Installation

Add this line to your Jekyll project's Gemfile, within the `jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem 'jekyll_archive_create'
end
```

And then install dependent gems as usual:

```shell
$ bundle
```


## Demo Website

A test/demo website is provided in the `demo` directory.
You can run it under a debugger, or let it run free.

The `demo/_bin/debug` script can set various parameters for the demo.
View the help information with the `-h` option:

```shell
$ demo/_bin/debug -h

debug - Run the demo Jekyll website.

By default the demo Jekyll website runs without restriction under ruby-debug-ide and debase.
View it at http://localhost:4444

Options:
  -h  Show this error message

  -r  Run freely, without a debugger
```


### Debugging the Demo

To run under a debugger, for example Visual Studio Code:

1. Set breakpoints.

2. Initiate a debug session from the command line:

   ```shell
   $ demo/bin/debug
   ```

3. Once the `Fast Debugger` signon appears,
   launch the Visual Studio Code launch configuration called `Attach rdebug-ide`.

4. View the generated website at [`http://localhost:4444`](http://localhost:4444).


## Development

After checking out the repo, run `bin/setup` to install dependencies.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.


### Build and Install Locally

To build and install this gem onto your local machine, run:

```shell
$ bundle exec rake install
```

Examine the newly built gem:

```shell
$ gem info jekyll_archive_create

*** LOCAL GEMS ***

jekyll_archive_create (1.0.0)
    Author: Mike Slinn
    Homepage:
    https://github.com/mslinn/jekyll_archive_create
    License: MIT
    Installed at: /home/mslinn/.gems

    Generates Jekyll logger with colored output.
```


### Build and Push to RubyGems

To release a new version,

1. Update the version number in `version.rb`.
2. Commit all changes to git; if you don't the next step might fail with an unexplainable error message.
3. Run the following:

    ```shell
    $ bundle exec rake release
    ```

    The above creates a git tag for the version, commits the created tag,
    and pushes the new `.gem` file to [RubyGems.org](https://rubygems.org).


## Contributing

1. Fork the project
2. Create a descriptively named feature branch
3. Add your feature
4. Submit a pull request


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
