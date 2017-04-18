require "formula"
require "language/go"

class UmschlagApi < Formula
  desc "A docker distribution management system - API"
  homepage "https://github.com/umschlag/umschlag-api"

  stable do
    url "https://dl.webhippie.de/umschlag/api/0.1.0/umschlag-api-0.1.0-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/umschlag/api/0.1.0/umschlag-api-0.1.0-darwin-10.6-amd64.sha256`.split(" ").first
    version "0.1.0"
  end

  devel do
    url "https://dl.webhippie.de/umschlag/api/master/umschlag-api-master-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/umschlag/api/master/umschlag-api-master-darwin-10.6-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://github.com/umschlag/umschlag-api.git", :branch => "master"
    depends_on "go" => :build
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
  end
end
