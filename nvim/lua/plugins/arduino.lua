-- Arduino support: syntax highlighting, LSP (completion, errors, gd), compile/upload keymaps.
-- Board: Arduino Uno R4 WiFi. Change FQBN to target another board
-- (list installed ones with `arduino-cli board listall`).
local FQBN = "arduino:renesas_uno:unor4wifi"

return {
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "arduino" } } },
  { "mason-org/mason.nvim", opts = { ensure_installed = { "arduino-language-server" } } },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        arduino_language_server = {
          cmd = {
            "arduino-language-server",
            "-cli-config", vim.fn.expand("~/Library/Arduino15/arduino-cli.yaml"),
            "-fqbn", FQBN,
            -- Use the clangd bundled with Arduino IDE (v14). Mason's newer clangd
            -- sends symbol tags this server doesn't support, and it panics.
            "-clangd", "/Applications/Arduino IDE.app/Contents/Resources/app/lib/backend/resources/clangd",
          },
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "arduino",
        callback = function(ev)
          local function run(cmd)
            Snacks.terminal(cmd, { cwd = vim.fn.expand("%:p:h"), interactive = false })
          end
          vim.keymap.set("n", "<leader>ac", function()
            run({ "arduino-cli", "compile", "--fqbn", FQBN, "." })
          end, { buffer = ev.buf, desc = "Arduino compile" })
          vim.keymap.set("n", "<leader>au", function()
            local port = vim.fn.glob("/dev/cu.usbmodem*", false, true)[1]
            if not port then
              return vim.notify("No board found at /dev/cu.usbmodem*", vim.log.levels.ERROR)
            end
            run({ "arduino-cli", "compile", "--upload", "--fqbn", FQBN, "-p", port, "." })
          end, { buffer = ev.buf, desc = "Arduino compile + upload" })
          vim.keymap.set("n", "<leader>am", function()
            local port = vim.fn.glob("/dev/cu.usbmodem*", false, true)[1]
            if not port then
              return vim.notify("No board found at /dev/cu.usbmodem*", vim.log.levels.ERROR)
            end
            Snacks.terminal({ "arduino-cli", "monitor", "-p", port, "-c", "baudrate=9600" })
          end, { buffer = ev.buf, desc = "Arduino serial monitor" })
        end,
      })
    end,
  },
}
