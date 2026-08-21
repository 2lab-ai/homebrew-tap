class PdcPreview < Formula
  desc "Palladium compiler, preview channel - tracks main (installs as pdc-preview)"
  homepage "https://github.com/labforadvancedstudy/palladium-a"
  url "https://github.com/labforadvancedstudy/palladium-a/archive/refs/tags/preview-20260821-153504-09e6000.tar.gz"
  version "0.2.0-preview.20260821-153504-09e6000"
  sha256 "1a1e53ac01f42361f69f3049b951d9039afd0e118572c7390d15fa56071f3206"
  license "MIT"
  head "https://github.com/labforadvancedstudy/palladium-a.git", branch: "main"

  # Installs its binary as `pdc-preview`, so it coexists with a stable `pdc`
  # rather than conflicting with it.

  depends_on "rust" => :build

  on_linux do
    depends_on "gcc"
  end

  def install
    system "cargo", "install", "--bin", "pdc", *std_cargo_args

    mv bin/"pdc", bin/"pdc-preview"

    # lib/, not share/: the stable channel installs the same filenames under
    # share/palladium/runtime, and Homebrew refuses to symlink the second keg
    # over the first. pdc's runtime resolver already searches
    # ../lib/palladium/runtime after ../share/palladium/runtime, and it
    # canonicalizes its own path first, so this binary finds its own copy.
    (lib/"palladium").install "runtime"
  end

  def caveats
    <<~EOS
      Installed as `pdc-preview`. This is a preview of unreleased work from main;
      for anything you care about use the stable channel:

        brew install pdc
    EOS
  end

  test do
    runtime = shell_output("#{bin}/pdc-preview --print-runtime").strip
    assert_predicate Pathname.new(runtime)/"palladium_runtime.c", :exist?

    (testpath/"hello.pd").write <<~PALLADIUM
      fn main() {
          print("preview-ok");
          print_int(string_len("abcd"));
      }
    PALLADIUM

    system bin/"pdc-preview", "compile", "hello.pd", "-o", "hello"
    output = shell_output("#{testpath}/build_output/hello")
    assert_match "preview-ok", output
    assert_match "4", output
  end
end
