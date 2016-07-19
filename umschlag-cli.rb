require "securerandom"

class UmschlagCli < Formula
  homepage "https://github.com/umschlag/umschlag-cli"
  url "http://dl.webhippie.de/umschlag-cli/latest/umschlag-cli-latest-darwin-amd64"
  sha256 `curl -s http://dl.webhippie.de/umschlag-cli/latest/umschlag-cli-latest-darwin-amd64.sha256`.split(" ").first

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
      umschlag_build_home = "/tmp/#{SecureRandom.hex}"
      umschlag_build_path = File.join(umschlag_build_home, "src", "github.com", "umschlag", "umschlag-cli")

      ENV["GOPATH"] = umschlag_build_home
      ENV["GOHOME"] = umschlag_build_home

      mkdir_p umschlag_build_path

      system("cp -R #{buildpath}/* #{umschlag_build_path}")
      ln_s File.join(cached_download, ".git"), File.join(umschlag_build_path, ".git")

      Dir.chdir umschlag_build_path

      system "make", "deps"
      system "make", "build"

      bin.install "#{umschlag_build_path}/bin/umschlag-cli" => "umschlag-cli"
      Dir.chdir buildpath
    else
      bin.install "#{buildpath}/umschlag-cli-latest-darwin-amd64" => "umschlag-cli"
    end
  ensure
    rm_rf umschlag_build_home if build.head?
  end
end
