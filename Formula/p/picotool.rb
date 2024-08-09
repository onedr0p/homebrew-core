class Picotool < Formula
  desc "Tool for interacting with RP2040/RP2350 devices and binaries"
  homepage "https://github.com/raspberrypi/picotool"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/raspberrypi/picotool/archive/refs/tags/2.0.0.tar.gz"
    sha256 "9392c4a31f16b80b70f861c37a029701d3212e212840daa097c8a3720282ce65"

    resource "pico-sdk" do
      url "https://github.com/raspberrypi/pico-sdk/archive/refs/tags/2.0.0.tar.gz"
      sha256 "626db87779fa37f7f9c7cfe3e152f7e828fe19c486730af2e7c80836b6b57e1d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "909c31ae54e7c19a10d9eabb0cb98b6f59f4ad1955c80b556d0fcd4e24ec8234"
    sha256 cellar: :any,                 arm64_ventura:  "ade5c431f3d8bc38a8344f568560e66ed9db419456135562911a2fa4857a6a91"
    sha256 cellar: :any,                 arm64_monterey: "f5215b286c3c79327faa53ae0cbea79a0127417eca52c9ff7888293932ffc5c2"
    sha256 cellar: :any,                 arm64_big_sur:  "a58c6248be802d53a62ed94e174895d96e8d785c06eaee7c8d868cb323f6367c"
    sha256 cellar: :any,                 sonoma:         "b30b491bfaf2e9206c6e50c28a5547846b09fc0cbce0a06f94172bb7ec6af22e"
    sha256 cellar: :any,                 ventura:        "7c0768d43b4ada8fd89e1749bab90b19e94a1ca5e1ceca09059323fbbb2d64cf"
    sha256 cellar: :any,                 monterey:       "94434284d05dd6e0a5ac3b484274805a7f848740ebec0e292b6a9f8b02c98f08"
    sha256 cellar: :any,                 big_sur:        "ea42adeb280960f973b906bacfdd065d70ff08611a0c9f6e08cd350105c8a8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26eb789f62304297bfbc00afe1eb8616c0e04dd381a2b95ae7d72869e81108e4"
  end

  head do
    url "https://github.com/raspberrypi/picotool.git", branch: "master"

    resource "pico-sdk" do
      url "https://github.com/raspberrypi/pico-sdk.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  resource "homebrew-pico-blink" do
    url "https://rptl.io/pico-blink"
    sha256 "4b2161340110e939b579073cfeac1c6684b35b00995933529dd61620abf26d6f"
  end

  def install
    resource("pico-sdk").stage buildpath/"pico-sdk"

    args = %W[-DPICO_SDK_PATH=#{buildpath}/pico-sdk]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-pico-blink").stage do
      result = <<~EOS
        File blink.uf2:

        Program Information
         name:          blink
         web site:      https://github.com/raspberrypi/pico-examples/tree/HEAD/blink
         binary start:  0x10000000
         binary end:    0x10003198
      EOS
      assert_equal result, shell_output("#{bin}/picotool info blink.uf2")
    end
  end
end
