require "formula"
require "language/go"
require "fileutils"
require "open-uri"

class UmschlagApi < Formula
  desc "Docker distribution management system - API"
  homepage "https://github.com/umschlag/umschlag-api"

  head do
    url "https://github.com/umschlag/umschlag-api.git", :branch => "master"
    depends_on "go" => :build
  end

  stable do
    url "https://dl.webhippie.de/umschlag/api/0.1.0/umschlag-api-0.1.0-darwin-10.6-amd64"
    sha256 open("https://dl.webhippie.de/umschlag/api/0.1.0/umschlag-api-0.1.0-darwin-10.6-amd64.sha256").read.split(" ").first
    version "0.1.0"
  end

  devel do
    url "https://dl.webhippie.de/umschlag/api/master/umschlag-api-master-darwin-10.6-amd64"
    sha256 open("https://dl.webhippie.de/umschlag/api/master/umschlag-api-master-darwin-10.6-amd64.sha256").read.split(" ").first
    version "master"
  end

  test do
    system "#{bin}/umschlag-api", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 1
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/umschlag/umschlag-api"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "test", "build"

        bin.install "umschlag-api"
        # bash_completion.install "contrib/bash-completion/_umschlag-api"
        # zsh_completion.install "contrib/zsh-completion/_umschlag-api"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/umschlag-api-master-darwin-10.6-amd64" => "umschlag-api"
    else
      bin.install "#{buildpath}/umschlag-api-0.1.0-darwin-10.6-amd64" => "umschlag-api"
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
            <string>#{etc}/umschlag-api.conf</string>
          </dict>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/umschlag-api</string>
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
