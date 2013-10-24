require 'fileutils'
require 'hashie/mash'

class Setting < Hashie::Mash

  SETTING_FILE = "#{Rails.root}/config/settings.yml"

  @_hash = nil

  class << self

    def method_missing(method, *arguments, &block)
      return super if block_given? or not (0..1).include?(arguments.length)

      hash.public_send(method)
    end

    def file
      @_file ||= begin
        file = File.open(SETTING_FILE, "r")
        file.flock(File::LOCK_SH)

        out = YAML::load(file.read) || {}
        out[:load_time] = Time.now
        file.close
        out
      end
    end

    def hash
      @_hash ||= begin
        new file
      end
    end

    def save!
      if file[:load_time] < File.stat(SETTING_FILE).mtime
        @_file = nil
        file
      end

      File.open(SETTING_FILE, "a") do |f|
        f.flock(File::LOCK_EX)
        f.truncate(0)

        hash.delete(:load_time)
        f.write YAML::dump(hash.to_hash)
        hash[:load_time] = Time.now
      end
    end
  end
end
