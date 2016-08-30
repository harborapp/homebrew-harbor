require "formula"

class UmschlagCli < Formula
  homepage "https://github.com/umschlag/umschlag-cli"
  head "https://github.com/umschlag/umschlag-cli.git"

  stable do
    url "http://dl.webhippie.de/umschlag-cli/0.0.1/umschlag-cli-0.0.1-darwin-amd64"
    sha256 `curl -s http://dl.webhippie.de/umschlag-cli/0.0.1/umschlag-cli-0.0.1-darwin-amd64.sha256`.split(" ").first
    version "0.0.1"
  end

  devel do
    url "http://dl.webhippie.de/umschlag-cli/latest/umschlag-cli-latest-darwin-amd64"
    sha256 `curl -s http://dl.webhippie.de/umschlag-cli/latest/umschlag-cli-latest-darwin-amd64.sha256`.split(" ").first
    version "0.0.1"
  end

  head do
    url "https://github.com/umschlag/umschlag-cli.git", :branch => "master"

    depends_on "go" => :build
    depends_on "mercurial" => :build
    depends_on "bzr" => :build
    depends_on "git" => :build
  end

  test do
    system "#{bin}/umschlag-cli", "--version"
  end

  def install
    if build.head?
      mkdir_p buildpath/File.join("src", "github.com", "umschlag")
      ln_s buildpath, buildpath/File.join("src", "github.com", "umschlag", "umschlag-cli")

      ENV["GOVENDOREXPERIMENT"] = "1"
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["PATH"] += ":" + File.join(buildpath, "bin")

      system("make", "build")

      bin.install "#{buildpath}/bin/umschlag-cli" => "umschlag-cli"
    else
      bin.install "#{buildpath}/umschlag-cli-latest-darwin-amd64" => "umschlag-cli"
    end
  end
end
