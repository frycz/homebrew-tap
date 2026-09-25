class Keb < Formula
  desc "Rename files to kebab case, safely and idempotently"
  homepage "https://github.com/frycz/keb"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.1.0/keb-aarch64-apple-darwin.tar.xz"
      sha256 "60dfc21c5ab209d31d8a8db6a381a90226cfe430687ddf26e9292e6fc6ea854a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.1.0/keb-x86_64-apple-darwin.tar.xz"
      sha256 "8b732aa41c9f47c8c7a1661b9f57684151f71a4eb6e964bde2988847791442b8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.1.0/keb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "121fea8a2971859a46178c44a99e98a160ce69624949cef5efe58368c46d7433"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.1.0/keb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "64d714b0ae067f28d0f693c20bdc595d490b7ffff41c55c14cd4bcb589b84376"
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
