return {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "zls.json", "build.zig", ".git", vim.uv.cwd() },
  single_file_support = true,
  workspace_required  = false,
}
