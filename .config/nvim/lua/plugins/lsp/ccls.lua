local core = require("plugins.lsp.core")

require("lspconfig").ccls.setup {
  on_attach = core.on_attach,
  capabilities = core.capabilities,

  init_options = {
    cache = { directory = "/tmp/ccls" },
    clang = {
      -- from clang -v -fsyntax-only -x c++ /dev/null
      extraArgs = {
        "-isystem/usr/local/include",
        "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1",
        "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/13.0.0/include",
        "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include",
        "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include",
        "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks",
      },
      -- From clang -print-resource-dir
      -- resourceDir = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/13.0.0"
    },
  },
  -- root_dir = require('lspconfig/util').root_pattern("compile_commands.json", ".ccls", "compile_flags.txt", ".git") or os.getenv("PWD"),
}
