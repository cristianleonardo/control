module Webpack
  class CompilationError < StandardError;end
  class NotRunningError < StandardError;end

  class << self
    def check_webpack_status
      status_path = Rails.root.join("tmp", "webpack-status.json")
      return unless File.exists?(status_path)

      File.open(status_path) do |f|
        webpack = JSON.parse(f.read)
        unless webpack["status"] == "ok"
          error = webpack["errors"].first
          raise CompilationError, "Error compiling #{error["header"]}: #{error["text"]}"
        end
      end
    end

    def webpack_running?
      `ps aux | grep "webpac[k]" | wc -l`.strip.to_i > 0
    end

    def check!
      unless webpack_running?
        raise NotRunningError, "webpack is not running. Please run 'npm run webpack:development'"
      end

      check_webpack_status
    end
  end
end
