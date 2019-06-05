require "formula"
require "language/go"
require "open-uri"

class UmschlagCli < Formula
  desc "Docker distribution management system - CLI"
  homepage "https://github.com/umschlag/umschlag-cli"

  head do
    url "https://github.com/umschlag/umschlag-cli.git", :branch => "master"
    depends_on "go" => :build
  end

  stable do
    url "https://dl.umschlag.tech/cli/0.1.0/umschlag-cli-0.1.0-darwin-amd64"
    sha256 begin
      open("https://dl.umschlag.tech/cli/0.1.0/umschlag-cli-0.1.0-darwin-amd64.sha256").read.split(" ").first
    rescue
      nil
    end
    version "0.1.0"
  end

  devel do
    url "https://dl.umschlag.tech/cli/testing/umschlag-cli-testing-darwin-amd64"
    sha256 begin
      open("https://dl.umschlag.tech/cli/testing/umschlag-cli-testing-darwin-amd64.sha256").read.split(" ").first
    rescue
      nil
    end
    version "master"
  end

  test do
    system "#{bin}/umschlag-cli", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 0
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath / "bin"

      currentpath = buildpath / "umschlag-cli"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath / "src"

      cd currentpath do
        system "make", "test", "build"

        bin.install "bin/umschlag-cli"
        # bash_completion.install "contrib/bash-completion/_umschlag-cli"
        # zsh_completion.install "contrib/zsh-completion/_umschlag-cli"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/umschlag-cli-testing-darwin-amd64" => "umschlag-cli"
    else
      bin.install "#{buildpath}/umschlag-cli-0.1.0-darwin-amd64" => "umschlag-cli"
    end
  end
end
