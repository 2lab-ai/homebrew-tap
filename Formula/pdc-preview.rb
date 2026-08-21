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

    # libexec is not symlinked into the prefix, so this copy of the runtime
    # cannot collide with the stable channel's copy of the same filenames.
    # The wrapper points this binary at its own.
    (libexec/"palladium").install "runtime"
    libexec.install bin/"pdc"
    bin.write_env_script libexec/"pdc", "pdc-preview",
                         PALLADIUM_RUNTIME: libexec/"palladium/runtime"
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
