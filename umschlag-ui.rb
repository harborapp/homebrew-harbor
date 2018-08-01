require "formula"
require "language/node"
require "language/go"
require "fileutils"
require "open-uri"

class UmschlagUi < Formula
  desc "Docker distribution management system - UI"
  homepage "https://github.com/umschlag/umschlag-ui"

  head do
    url "https://github.com/umschlag/umschlag-ui.git", :branch => "master"
    depends_on "go" => :build
    depends_on "node" => :build
  end

  stable do
    url "https://dl.webhippie.de/umschlag/ui/0.1.0/umschlag-ui-0.1.0-darwin-10.6-amd64"
    sha256 begin
      open("https://dl.webhippie.de/umschlag/ui/0.1.0/umschlag-ui-0.1.0-darwin-10.6-amd64.sha256").read.split(" ").first
    rescue
      nil
    end
    version "0.1.0"
  end

  devel do
    url "https://dl.webhippie.de/umschlag/ui/master/umschlag-ui-master-darwin-10.6-amd64"
    sha256 begin
      open("https://dl.webhippie.de/umschlag/ui/master/umschlag-ui-master-darwin-10.6-amd64.sha256").read.split(" ").first
    rescue
      nil
    end
    version "master"
  end

  test do
    system "#{bin}/umschlag-ui", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 0
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/umschlag/umschlag-ui"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      %w[src/github.com/UnnoTed/fileb0x].each do |path|
        cd(path) { system "go", "install" }
      end

      cd currentpath do
        system "npm", "install", *Language::Node.std_npm_install_args(libexec)
        system "npm", "run", "build"

        system "make", "generate", "test", "build"

        bin.install "umschlag-ui"
        # bash_completion.install "contrib/bash-completion/_umschlag-ui"
        # zsh_completion.install "contrib/zsh-completion/_umschlag-ui"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/umschlag-ui-master-darwin-10.6-amd64" => "umschlag-ui"
    else
      bin.install "#{buildpath}/umschlag-ui-0.1.0-darwin-10.6-amd64" => "umschlag-ui"
    end

    FileUtils.touch("umschlag-api.conf")
    etc.install "umschlag-api.conf" => "umschlag-api.conf"
  end

  plist_options :startup => true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>EnvironmentVariables</key>
          <dict>
            <key>UMSCHLAG_ENV_FILE</key>
            <string>#{etc}/umschlag-ui.conf</string>
          </dict>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/umschlag-ui</string>
            <string>server</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
        </dict>
      </plist>
    EOS
  end
end
