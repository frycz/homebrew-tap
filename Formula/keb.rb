class Keb < Formula
  desc "Rename files to kebab case, safely and idempotently"
  homepage "https://github.com/frycz/keb"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.3.0/keb-aarch64-apple-darwin.tar.xz"
      sha256 "e8bc5dbba37ac000854b60174d410934df02bec9be99ca3d8d1edf9ab3aaedac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.3.0/keb-x86_64-apple-darwin.tar.xz"
      sha256 "8018c1f0112e3b1bcf8f30eeaab835735e0492df5b2443781f720abe2675be0b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frycz/keb/releases/download/v0.3.0/keb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "26c8dbe174f9dc42061643792a112baca9ceda07b20a3cb183e0370f73a2fde2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frycz/keb/releases/download/v0.3.0/keb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "050f7b92916168ff8372380ef911a16f114bb0c74a7427f2eb7238d15fe72784"
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
