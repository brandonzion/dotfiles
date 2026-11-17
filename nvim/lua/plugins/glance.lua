-- Peek LSP results in a floating window instead of jumping to the file.
-- gp: definition · gP: references · gY: type definition
-- In the popup: q/Esc close, o/Enter open the location, j/k move through results.
return {
  "dnlhc/glance.nvim",
  cmd = "Glance",
  opts = {},
  keys = {
    { "gp", "<cmd>Glance definitions<cr>", desc = "Peek Definition" },
    { "gP", "<cmd>Glance references<cr>", desc = "Peek References" },
    { "gY", "<cmd>Glance type_definitions<cr>", desc = "Peek Type Definition" },
  },
}
