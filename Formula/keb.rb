class Keb < Formula
  desc "Rename files to kebab case, safely and idempotently"
  homepage "https://github.com/frycz/keb"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.0.1/keb-aarch64-apple-darwin.tar.xz"
      sha256 "1cd492f2543dd2fbb4172ca29f2d7be7eb41a1fc93f0cf07184a177e9007364b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.0.1/keb-x86_64-apple-darwin.tar.xz"
      sha256 "6d4fffc70ace364c5289ac9622ce24c28323bf140d88293af3e9a6c81e66a339"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.0.1/keb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f9c0fb98674827df1c26bd43e05a33d48ac8abfb14f8e94b63aa98f999e62fbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.0.1/keb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d1f74bab20d0a78b136555f3fb1fec3c1085261f86e9c92b6986f97b254b6a9"
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
