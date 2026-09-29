class Keb < Formula
  desc "Rename files to kebab case, safely and idempotently"
  homepage "https://github.com/frycz/keb"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.4.0/keb-aarch64-apple-darwin.tar.xz"
      sha256 "32f0ea9c50ccf9fae35d063f8208aca7a4b0674948895b6e3de6d3be43976e37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.4.0/keb-x86_64-apple-darwin.tar.xz"
      sha256 "f010662fdc59276c12f5dec634e42b13e72d024e587b0bb4d0b4105b4d692dcb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.4.0/keb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4b64651ec86ca7bd69a0bdfbbe80b2b6ff9bacd35ea2aa927d0ff47007a27d0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.4.0/keb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2281589e114260664eb6835b92ec1eb3c7393cf4393c8fa66b0ea8d134c6e8db"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "keb"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "keb"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "keb"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "keb"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
