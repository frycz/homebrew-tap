class Keb < Formula
  desc "Rename files to kebab case, safely and idempotently"
  homepage "https://github.com/frycz/keb"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.2.0/keb-aarch64-apple-darwin.tar.xz"
      sha256 "2b2c1e35a398aa1039346bbeef007a7e97e81a2ddc34accb5e06a4eaac423128"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.2.0/keb-x86_64-apple-darwin.tar.xz"
      sha256 "d2c62b25ddf078e478ea498648f3aad16984ece1c7edf46add2c4a72073fa210"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.2.0/keb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "929dce976a2256622b2a35630b4bf7e04e90919f2be767a0bca2059e034d1cfd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.2.0/keb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "391217aa0bb6146d2d7b5f6d60d61ee25f135527ca0daab04b50f2016fea94d6"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
