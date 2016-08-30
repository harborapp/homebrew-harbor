require "formula"

class UmschlagApi < Formula
  homepage "https://github.com/umschlag/umschlag-api"
  head "https://github.com/umschlag/umschlag-api.git"

  stable do
    url "http://dl.webhippie.de/umschlag-api/0.0.1/umschlag-api-0.0.1-darwin-amd64"
    sha256 `curl -s http://dl.webhippie.de/umschlag-api/0.0.1/umschlag-api-0.0.1-darwin-amd64.sha256`.split(" ").first
    version "0.0.1"
  end

  devel do
    url "http://dl.webhippie.de/umschlag-api/latest/umschlag-api-latest-darwin-amd64"
    sha256 `curl -s http://dl.webhippie.de/umschlag-api/latest/umschlag-api-latest-darwin-amd64.sha256`.split(" ").first
    version "0.0.1"
  end

  head do
    url "https://github.com/umschlag/umschlag-api.git", :branch => "master"

    depends_on "go" => :build
    depends_on "mercurial" => :build
    depends_on "bzr" => :build
    depends_on "git" => :build
  end

  test do
    system "#{bin}/umschlag-api", "--version"
  end

  def install
    if build.head?
      mkdir_p buildpath/File.join("src", "github.com", "umschlag")
      ln_s buildpath, buildpath/File.join("src", "github.com", "umschlag", "umschlag-api")

      ENV["GOVENDOREXPERIMENT"] = "1"
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["PATH"] += ":" + File.join(buildpath, "bin")

      system("make", "build")

      bin.install "#{buildpath}/bin/umschlag-api" => "umschlag-api"
    else
      bin.install "#{buildpath}/umschlag-api-latest-darwin-amd64" => "umschlag-api"
    end
  end
end
