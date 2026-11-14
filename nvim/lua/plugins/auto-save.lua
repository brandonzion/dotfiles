return {
  {
    "okuuva/auto-save.nvim",
    version = "^1.0.0",
    cmd = "ASToggle", -- :ASToggle turns autosave on/off
    event = { "InsertLeave", "TextChanged" },
    opts = {
      noautocmd = true, -- autosaves skip format-on-save; manual :w still formats
    },
  },
}
