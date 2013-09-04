module CaptureIO
  def capture_io
    old_out = $stdout
    sio_out = StringIO.new
    $stdout = sio_out

    old_err = $stderr
    sio_err = StringIO.new
    $stderr = sio_err

    yield

  ensure
    $stdout = old_out
    $stderr = old_err

    captured_out << sio_out.string
    captured_err << sio_err.string
  end

  def captured_out
    @captured_out ||= ""
  end

  def captured_err
    @captured_err ||= ""
  end
end

RSpec.configure do |config|
  config.include CaptureIO
end
