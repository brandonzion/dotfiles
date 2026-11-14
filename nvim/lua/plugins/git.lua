return {
  -- Magit-style git UI: stage, commit, push, pull, branch, rebase
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit Commit" },
    },
    opts = {
      integrations = { diffview = true }, -- open diffs from Neogit in Diffview
    },
  },

  -- Side-by-side diffs, merge-conflict resolution, file history
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      {
        "<leader>gv",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "Diffview Toggle (working tree)",
      },
      { "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
      { "<leader>gR", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview Repo History" },
    },
    opts = {},
  },

  -- Commit graph; selecting a commit (or a visual range) opens it in Diffview
  {
    "isakbm/gitgraph.nvim",
    dependencies = { "sindrets/diffview.nvim" },
    keys = {
      {
        "<leader>gt",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "Git Graph",
      },
    },
    opts = {
      symbols = { merge_commit = "M", commit = "*" },
      format = {
        timestamp = "%Y-%m-%d %H:%M",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        on_select_commit = function(commit)
          vim.cmd("DiffviewOpen " .. commit.hash .. "^!")
        end,
        on_select_range_commit = function(from, to)
          vim.cmd("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
  },
}
