class Macha < Formula
  desc "Reports Mac state (Bluetooth) to Home Assistant over MQTT"
  homepage "https://github.com/humanfriend22/macha"
  url "https://github.com/humanfriend22/macha/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "39df31a6948578a5e086c8dfe8474f9dc4013cb1a2e9e404824dcff12e547cfb"
  license "GPL-3.0-or-later"

  depends_on xcode: ["27.0", :build]
  depends_on :macos

  def install
    # Builds macha and wraps it in macha.app: macOS only grants Location Services to a signed app bundle.
    system "scripts/build.sh", libexec
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
