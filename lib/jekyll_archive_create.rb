require 'fileutils'
require 'jekyll'
require 'jekyll_plugin_logger'
require 'ptools'
require 'rubygems'
require 'rubygems/package'
require 'tmpdir'
require 'zlib'
require 'zip'
require_relative 'jekyll_archive_create/version'

module Jekyll
  # Makes tar or zip file based on _config.yml entry
  class MakeArchive < Jekyll::Generator # rubocop:disable Metrics/ClassLength
    priority :high

    # Method prescribed by the Jekyll plugin lifecycle.
    # @param site [Jekyll.Site] Automatically provided by Jekyll plugin mechanism
    # @return [void]
    def generate(site)
      @logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
      @live_reload = site.config['livereload']

      archive_config = site.config['make_archive']
      return if archive_config.nil?

      archive_config.each do |config|
        setup_instance_variables config
        create_archive site.source
        site.keep_files << @archive_name
      end
    end

    private

    def setup_instance_variables(config)
      @archive_name = config['archive_name'] # Relative to _site.source
      abort 'Error: archive_name was not specified in _config.yml.' if @archive_name.nil?

      @archive_type = archive_type(@archive_name)

      @archive_files = config['files'].compact
      abort 'Error: archive files were not specified in _config.yml.' if @archive_files.nil?

      delete_archive = config['delete']
      @force_delete = delete_archive.nil? ? !@live_reload : delete_archive

      @logger.debug do
        part1 = "@archive_name=#{@archive_name}; @live_reload=#{@live_reload};"
        part2 = "@force_delete=#{@force_delete}; @archive_files=#{@archive_files}"
        "#{part1} #{part2}"
      end
    end

    def archive_type(archive_name)
      if archive_name.end_with? '.zip'
        :zip
      elsif archive_name.end_with? '.tar'
        :tar
      else
        abort "Error: archive must be zip or tar; #{archive_name} is of an unknown archive type."
      end
    end

    def create_archive(source)
      archive_name_full = "#{source}/#{@archive_name}"
      archive_exists = File.exist?(archive_name_full)
      return if archive_exists && @live_reload

      @logger.debug { "#{archive_name_full} exists? #{archive_exists}" }
      if archive_exists && @force_delete
        @logger.debug "Deleting old #{archive_name_full}"
        File.delete(archive_name_full)
      end

      make_tar_or_zip(archive_exists, archive_name_full, source)

      @logger.debug { "Looking for #{@archive_name} in .gitignore..." }
      if File.exist? '.gitignore'
        return if File.foreach('.gitignore').grep(%r!^#{@archive_name}\n?!).any?

        @logger.warn "#{@archive_name} was not found in .gitignore, adding entry."
      else
        @logger.warn "#{Dir.pwd}/.gitignore does not exist, creating it."
        FileUtils.touch '.gitignore'
      end

      File.open('.gitignore', 'a') do |f|
        f.puts File.basename(@archive_name)
      end
    end

    def make_tar(tar_name, source)
      Dir.mktmpdir do |dirname|
        @archive_files.each do |filename|
          fn, filename_full = qualify_file_name(filename, source)
          @logger.debug { "Copying #{filename_full} to temporary directory #{dirname}; filename=#{filename}; fn=#{fn}" }
          FileUtils.copy(filename_full, dirname)
        end
        write_tar(tar_name, dirname)
      end
    end

    def make_tar_or_zip(archive_exists, archive_name_full, source)
      return unless !archive_exists || @force_delete

      @logger.debug { "Making #{archive_name_full}" }
      case @archive_type
      when :tar
        make_tar(archive_name_full, source)
      when :zip
        make_zip(archive_name_full, source)
      end
    end

    def make_zip(zip_name, source)
      Zip.default_compression = Zlib::DEFAULT_COMPRESSION
      Zip::File.open(zip_name, Zip::File::CREATE) do |zipfile|
        @archive_files.each do |filename|
          filename_in_archive, filename_original = qualify_file_name(filename, source)
          @logger.debug { "make_zip: adding #{filename_original} to #{zip_name} as #{filename_in_archive}" }
          zipfile.add(filename_in_archive, filename_original)
        end
      end
    end

    def write_tar(tar_name, dirname)
      # Modified from https://gist.github.com/sinisterchipmunk/1335041/5be4e6039d899c9b8cca41869dc6861c8eb71f13
      File.open(tar_name, 'wb') do |tarfile|
        Gem::Package::TarWriter.new(tarfile) do |tar|
          Dir[File.join(dirname, '**/*')].each do |filename|
            write_tar_entry(tar, dirname, filename)
          end
        end
      end
    end

    def write_tar_entry(tar, dirname, filename)
      mode = File.stat(filename).mode
      relative_file = filename.sub(%r!^#{Regexp.escape dirname}/?!, '')
      if File.directory?(filename)
        tar.mkdir relative_file, mode
      else
        tar.add_file relative_file, mode do |tf|
          File.open(filename, 'rb') { |f| tf.write f.read }
        end
      end
    end

    # @return tuple of filename (without path) and fully qualified filename
    def qualify_file_name(path, source)
      case path[0]
      when '/' # Is the file absolute?
        @logger.debug { "Absolute filename: #{path}" }
        [File.basename(path), path]
      when '!' # Should the file be found on the PATH?
        clean_path = path[1..]
        filename_full = File.which(clean_path)
        abort "Error: #{clean_path} is not on the PATH." if filename_full.nil?

        @logger.debug { "File on PATH: #{clean_path} -> #{filename_full}" }
        [File.basename(clean_path), filename_full]
      when '~' # Is the file relative to user's home directory?
        clean_path = path[2..]
        filename_full = File.join(Dir.home, clean_path)
        @logger.debug { "File in home directory: #{clean_path} -> #{filename_full}" }
        [File.basename(clean_path), filename_full]
      else # The file is relative to the Jekyll website top-level directory
        @logger.debug { "Relative filename: #{path}" }
        [File.basename(path), File.join(source, path)] # join yields the fully qualified path
      end
    end

    PluginMetaLogger.instance.logger.info { "Loaded jekyll_archive_create v#{JekyllArchiveCreateVersion::VERSION} plugin." }
  end
end
