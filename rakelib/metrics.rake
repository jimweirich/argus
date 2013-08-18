if defined?(Bundler)
  def cleanly(&block)
    Bundler.with_clean_env(&block)
  end
else
  def cleanly
    yield
  end
end

METRICS_FILES = FileList['lib/**/*.rb']

task :flog, [:all] do |t, args|
  flags = args.all ? "--all" : ""
  cleanly do
    sh "flog -m -b #{flags} #{METRICS_FILES}"
  end
end

task :flay do
  cleanly do
    sh "flay #{METRICS_FILES}"
  end
end
