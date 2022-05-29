class OsinfoDbTools < Formula
  desc "Tools for managing the libosinfo database files"
  homepage "https://libosinfo.org"
  url "https://releases.pagure.org/libosinfo/osinfo-db-tools-1.9.0.tar.xz"
  sha256 "b4f3418154ef3f43d9420827294916aea1827021afc06e1644fc56951830a359"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "json-glib"
  depends_on "libarchive" # need >= 3.0.0
  depends_on "libsoup@2"

  def install
    args = std_meson_args + %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja -v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/osinfo-db-path"
  end
end
