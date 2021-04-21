class << Process
  alias :spawn_before_enclose_io :spawn
  def spawn(arg0, *args)
    if arg0.kind_of?(Hash) && args[0].kind_of?(String) && '/__enclose_io_memfs__' == args[0][0...21]
      arg0 = arg0.dup
      args[0] = args[0].dup
      arg0['ENCLOSE_IO_USE_ORIGINAL_RUBY'] = '1'
      args[0] = Process.enclose_io_execpath + ' ' + args[0]
    end
    spawn_before_enclose_io(arg0, *args)
  end
end
class << IO
  alias :popen_before_enclose_io :popen
  def popen(*args, &block)
    if args[0].kind_of?(Array)
      if args[0][0].kind_of?(String) && '/__enclose_io_memfs__' == args[0][0][0...21]
        args[0] = args[0].dup
        args[0][0] = enclose_io_memfs_extract(args[0][0], 'exe')
        File.chmod(0755, args[0][0])
      end
    end
    popen_before_enclose_io(*args, &block)
  end
end
require 'fileutils'
if ENV['ENCLOSE_IO_WORKDIR'] && ENV['ENCLOSE_IO_WORKDIR'].length > 0
  x = File.expand_path(ENV['ENCLOSE_IO_WORKDIR'])
  FileUtils.mkdir_p(x)
  if ENV['ENCLOSE_IO_RAILS']
    Dir.chdir(x) do
      FileUtils.mkdir_p('config')
      Dir.chdir('config') do
        Dir['/__enclose_io_memfs__/local/config/*'].each do |fullpath|
          unless fullpath =~ /\\.rb$/ || File.exist?(File.basename(fullpath)) || !File.file?(fullpath)
            FileUtils.cp(fullpath, File.basename(fullpath))
          end
        end
      end
    end
  end
  enclose_io_set_mkdir_workdir(x)
end
if ENV['ENCLOSE_IO_RAILS']
  Dir.chdir('/__enclose_io_memfs__/local')
end
