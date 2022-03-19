jekyll_archive_create
[![Gem Version](https://badge.fury.io/rb/jekyll_archive_create.svg)](https://badge.fury.io/rb/jekyll_archive_create)
===========

This is a Jekyll plugin that makes tar or zip files based on `_config.yml` entries.

In production mode, the archives are built each time Jekyll generates the web site. In development mode, the archives are only built if they do not already exist, or if `delete: true` is set for that archive in `_config.yml`. Archives are placed in the top-level of the Jekyll project, and are copied to `_site` by Jekyll's normal build process. Entries are created in `.gitignore` for each of the generated archives.

## Usage
This plugin supports 4 types of file specifications:

 * Absolute filenames (start with /).
 * Filenames relative to the top-level directory of the Jekyll web site (do not preface with . or /).
 * Filenames relative to the user home directory (preface with ~).
 * Executable filenames on the PATH (preface with !).

## `_config.yml` Syntax
Any number of archives can be specified. Each archive has 3 properties: `archive_name`, `delete` (defaults to true) and `files`. Take care that the dashes have exactly 2 spaces before them, and that the 2 lines following each dash have exactly 4 spaces in front.

```
make_archive:
  -
    archive_name: cloud9.zip
    delete: true  # This is the default, and need not be specified.
    files: [ index.html, 404.html, ~/.ssh/config, /etc/passwd, '!update' ]
  -
    archive_name: cloud9.tar
    delete: false  # Do not overwrite the archive if it already exists
    files: [ index.html, 404.html, ~/.ssh/config, /etc/passwd, '!update' ]
```


## Additional Information
More information is available on my web site about [my Jekyll plugins](https://www.mslinn.com/blog/2020/10/03/jekyll-plugins.html).


## Installation

Add this line to your application's Gemfile, within the `jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem 'jekyll_archive_create'
end
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll_archive_create


## Development

After checking out the repo, run `bin/setup` to install dependencies.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.


### Build and Install Locally
To build and install this gem onto your local machine, run:
```shell
$ rake install:local
```

The following also does the same thing:
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
