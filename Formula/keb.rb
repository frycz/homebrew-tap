class Keb < Formula
  desc "Rename files to kebab case, safely and idempotently"
  homepage "https://github.com/frycz/keb"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.4.1/keb-aarch64-apple-darwin.tar.xz"
      sha256 "8a308a02eaea5fbab4b9c967b16974b1b7885e7c90ca23fc282eb9548d840c96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.4.1/keb-x86_64-apple-darwin.tar.xz"
      sha256 "ee1cddb86dae34264a74de4d4f393529417b3b61f9e2bec12d5efbc17dab6ee5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.4.1/keb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f836fcb9aeae789dff580a3b8944a917c8961ad2aeb0ead5c2db616c32700fc4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.4.1/keb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8f63105fc12ebd67b9caac9653207cc1fbb562ce9f61b80dd9efa21a1fc7bbb6"
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
