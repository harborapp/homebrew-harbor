require "formula"
require "language/node"
require "language/go"

class KleisterUi < Formula
  desc "A docker distribution management system - UI"
  homepage "https://github.com/umschlag/umschlag-ui"

  stable do
    url "https://dl.webhippie.de/umschlag/ui/0.1.0/umschlag-ui-0.1.0-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/umschlag/ui/0.1.0/umschlag-ui-0.1.0-darwin-10.6-amd64.sha256`.split(" ").first
    version "0.1.0"
  end

  devel do
    url "https://dl.webhippie.de/umschlag/ui/master/umschlag-ui-master-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/umschlag/ui/master/umschlag-ui-master-darwin-10.6-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://github.com/umschlag/umschlag-ui.git", :branch => "master"
    depends_on "go" => :build
    depends_on "node" => :build
  end

  go_resource "github.com/UnnoTed/fileb0x" do
    url "https://github.com/UnnoTed/fileb0x.git",
      :revision => "c1bd5476f1cb44cdc21780d954cefb2155e8a325"
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
  end
end
