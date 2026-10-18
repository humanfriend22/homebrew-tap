class Macha < Formula
  desc "Reports Mac state (Bluetooth) to Home Assistant over MQTT"
  homepage "https://github.com/humanfriend22/macha"
  url "https://github.com/humanfriend22/macha/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0a811a56d773f8e24ce14eeb28fb4a69244e403468165f49bc44f84b29826ea4"
  license "GPL-3.0-or-later"

  depends_on xcode: ["27.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/macha"
  end

  service do
    run [opt_bin/"macha", "run"]
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
