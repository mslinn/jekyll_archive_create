require_relative 'lib/jekyll_archive_create/version'

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  github = 'https://github.com/mslinn/jekyll_archive_create'

  spec.authors     = ['Mike Slinn']
  spec.bindir      = 'exe'
  spec.description = <<~END_OF_DESC
    Jekyll generator for creating tar and zip files.
  END_OF_DESC
  spec.email    = ['mslinn@mslinn.com']
  spec.files    = Dir['.rubocop.yml', 'LICENSE.*', 'Rakefile', '{lib,spec}/**/*', '*.gemspec', '*.md']
  spec.homepage = 'https://www.mslinn.com/jekyll_plugins/jekyll_archive_create.html'
  spec.license  = 'MIT'
  spec.metadata = {
    'allowed_push_host' => 'https://rubygems.org',
    'bug_tracker_uri'   => "#{github}/issues",
    'changelog_uri'     => "#{github}/CHANGELOG.md",
    'homepage_uri'      => spec.homepage,
    'source_code_uri'   => github,
  }
  spec.name                 = 'jekyll_archive_create'
  spec.platform             = Gem::Platform::RUBY
  spec.post_install_message = <<~END_MESSAGE

    Thanks for installing #{spec.name}!

  END_MESSAGE
  spec.require_paths         = ['lib']
  spec.required_ruby_version = '>= 2.6.0'
  spec.summary               = 'Jekyll generator for creating tar and zip files.'
  spec.test_files            = spec.files.grep(%r!^(test|spec|features)/!)
  spec.version               = JekyllArchiveCreateVersion::VERSION

  spec.add_dependency 'jekyll', '>= 3.5.0'
  spec.add_dependency 'jekyll_plugin_logger', '~> 2.1.0'
  spec.add_dependency 'rubyzip'
end
