require 'csv'

class ParallelCSV
  DEFAULTS = {
    chunk_size: 5_000,
    col_sep: '¦',
    process_num: 4
  }.freeze

  attr_reader :path, :options

  def initialize(path, options = {})
    @options = DEFAULTS.merge(options)
    @path = path
  end

  def process(&block)
    offset = 0
    reader, writer = IO.pipe
    eof = false

    until eof do
      pids = []
      options[:process_num].times do
        pids << fork_unless_test do
          single_process(offset, writer, &block)
        end

        offset += options[:chunk_size]
      end

      pids.compact.each { |pid| Process.wait(pid) }

      eof = (IO.select([reader], [writer])[0].length > 0 && reader.gets == "stop\n")
    end
  end

  private

  def single_process(offset, writer, &block)
    io = IO.new(IO.sysopen(path, 'r'), 'r')
    csv = CSV.new(io, csv_options)
    chunk = []

    offset.times { io.readline }

    options[:chunk_size].times do
      line = csv.readline
      chunk << line.fields if line
    end
  rescue
    writer.puts 'stop'
  ensure
    yield chunk if block_given? && !chunk.empty?
  end

  def csv_options
    options.except(:process_num, :chunk_size)
  end

  def fork_unless_test
    if Rails.env == 'test'
      yield
      return nil
    else
      fork { yield }
    end
  end
end
