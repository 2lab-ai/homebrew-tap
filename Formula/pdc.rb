class Pdc < Formula
  desc "Palladium compiler - a self-hosting systems language that compiles to C"
  homepage "https://github.com/labforadvancedstudy/palladium-a"
  url "https://github.com/labforadvancedstudy/palladium-a/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6126f85fefc9eb7e78738aa3aa01a727988d53f3b01797026cae9564ca77a586"
  license "MIT"
  head "https://github.com/labforadvancedstudy/palladium-a.git", branch: "main"

  depends_on "rust" => :build

  # pdc emits C and then invokes a C compiler to link. On macOS that is clang
  # under the name `gcc`, which is always present with the Command Line Tools;
  # on Linux the formula depends on gcc explicitly.
  on_linux do
    depends_on "gcc"
  end

  def install
    system "cargo", "install", "--bin", "pdc", *std_cargo_args

    # The C runtime is not optional: generated C declares 16 extern symbols that
    # live in palladium_runtime.c, and includes pd_prelude.h. Without them the
    # compiler links nothing. pdc canonicalizes its own path and looks for
    # ../share/palladium/runtime first, which resolves inside this keg.
    (share/"palladium").install "runtime"
  end

  def caveats
    <<~EOS
      Verify the install from a directory that is not a Palladium checkout:

        pdc --print-runtime
        cd /tmp && printf 'fn main() { print("ok"); }\\n' > ok.pd
        pdc compile ok.pd -o ok && ./build_output/ok

      To try unreleased fixes alongside this one:

        brew install pdc-preview     # installs as `pdc-preview`
    EOS
  end

  test do
    # The runtime must resolve from the install location, with no help from the
    # working directory — that is the whole point of shipping it in share/.
    runtime = shell_output("#{bin}/pdc --print-runtime").strip
    assert_predicate Pathname.new(runtime)/"palladium_runtime.c", :exist?

    (testpath/"hello.pd").write <<~PALLADIUM
      fn main() {
          print("homebrew-ok");
          print_int(string_len("abcd"));
      }
    PALLADIUM

    system bin/"pdc", "compile", "hello.pd", "-o", "hello"
    output = shell_output("#{testpath}/build_output/hello")
    assert_match "homebrew-ok", output
    assert_match "4", output
  end
end
