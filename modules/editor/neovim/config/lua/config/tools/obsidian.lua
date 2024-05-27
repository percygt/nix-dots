require("obsidian").setup({
  workspaces = {
    {
      name = "playbook",
      path = "/home/percygt/data/playbook",
    },
  },
  notes_subdir = "Brain",
  new_notes_location = "notes_subdir",
  templates = {
    subdir = "System/templates",
    date_format = "%Y-%m-%d-%a",
    time_format = "%H:%M",
    tags = "",
  },
})
