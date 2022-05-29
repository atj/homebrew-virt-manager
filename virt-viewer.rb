class VirtViewer < Formula
  desc "App for virtualized guest interaction"
  homepage "https://virt-manager.org/"
  url "https://virt-manager.org/download/sources/virt-viewer/virt-viewer-11.0.tar.xz"
  sha256 "a43fa2325c4c1c77a5c8c98065ac30ef0511a21ac98e590f22340869bad9abd0"

  patch :DATA

  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gtk-vnc"
  depends_on "hicolor-icon-theme"
  depends_on "libvirt"
  depends_on "libvirt-glib"
  depends_on "pango"
  depends_on "shared-mime-info"
  depends_on "spice-gtk"
  depends_on "spice-protocol"

  def install
    args = *std_meson_args + %W[
      -Dvnc=enabled
      -Dspice=enabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "install", "-v"
    end
  end

  def post_install
    # manual update of mime database
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
    # manual icon cache update step
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/virt-viewer", "--version"
  end
end
__END__
diff --git a/data/meson.build b/data/meson.build
index d718491..4325108 100644
--- a/data/meson.build
+++ b/data/meson.build
@@ -2,7 +2,6 @@ if host_machine.system() != 'windows'
   desktop = 'remote-viewer.desktop'

   i18n.merge_file (
-    desktop,
     type: 'desktop',
     input: desktop + '.in',
     output: desktop,
@@ -14,7 +13,6 @@ if host_machine.system() != 'windows'
   mimetypes = 'virt-viewer-mime.xml'

   i18n.merge_file (
-    mimetypes,
     type: 'xml',
     input: mimetypes + '.in',
     output: mimetypes,
@@ -27,7 +25,6 @@ if host_machine.system() != 'windows'
   metainfo = 'remote-viewer.appdata.xml'

   i18n.merge_file (
-    metainfo,
     type: 'xml',
     input: metainfo + '.in',
     output: metainfo,
