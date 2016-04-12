require "securerandom"

class HarborApi < Formula
  homepage "https://github.com/harborapp/harbor-api"
  url "http://dl.webhippie.de/harbor-api/latest/harbor-api-latest-darwin-amd64"
  sha256 `curl -s http://dl.webhippie.de/harbor-api/latest/harbor-api-latest-darwin-amd64.sha256`.split(" ").first

  head do
    url "https://github.com/harborapp/harbor-api.git", :branch => "master"

    depends_on "go" => :build
    depends_on "mercurial" => :build
    depends_on "bzr" => :build
    depends_on "git" => :build
  end

  test do
    system "#{bin}/harbor-api", "--version"
  end

  def install
    if build.head?
      harbor_build_home = "/tmp/#{SecureRandom.hex}"
      harbor_build_path = File.join(harbor_build_home, "src", "github.com", "harborapp", "harbor-api")

      ENV["GOPATH"] = harbor_build_home
      ENV["GOHOME"] = harbor_build_home

      mkdir_p harbor_build_path

      system("cp -R #{buildpath}/* #{harbor_build_path}")
      ln_s File.join(cached_download, ".git"), File.join(harbor_build_path, ".git")

      Dir.chdir harbor_build_path

      system "make", "deps"
      system "make", "build"

      bin.install "#{harbor_build_path}/bin/harbor-api" => "harbor-api"
      Dir.chdir buildpath
    else 
      bin.install "#{buildpath}/harbor-api-latest-darwin-amd64" => "harbor-api"
    end
  ensure
    rm_rf harbor_build_home if build.head?
  end
end
