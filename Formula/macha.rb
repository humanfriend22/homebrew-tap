class Macha < Formula
  desc "Reports Mac state (Bluetooth) to Home Assistant over MQTT"
  homepage "https://github.com/humanfriend22/macha"
  url "https://github.com/humanfriend22/macha/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "f999142352ea8807bc1ea5cbddbe2b6c18ecda71e8df6a158351114e68e22048"
  license "GPL-3.0-or-later"

  depends_on xcode: ["27.0", :build]
  depends_on :macos

  def install
    ohai "Compiling macha and its Swift dependencies. This may take a few minutes."
    system "scripts/build.sh", "compile"
    ohai "Packaging macha.app"
    system "scripts/build.sh", "package", libexec
    bin.install_symlink libexec/"macha.app/Contents/MacOS/macha"
  end

  service do
    run [opt_libexec/"macha.app/Contents/MacOS/macha", "run"]
    keep_alive true
    log_path var/"log/macha.log"
    error_log_path var/"log/macha.log"
  end

  def caveats
    <<~EOS
      Configure before starting the service:
        macha configure
        brew services start macha
    EOS
  end

  test do
    assert_match "macha", shell_output("#{bin}/macha --help")
  end
end
