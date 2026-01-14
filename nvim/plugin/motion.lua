-- precognition

if vim.g.did_load_precognition_plugin then
  return
end
vim.g.did_load_precognition_plugin = true

require('precognition').setup {}

-- ^ precognition

-- nvim-spider

if vim.g.did_load_spider_plugin then
  return
end
vim.g.did_load_spider_plugin = true

require('spider').setup {
  keys = {
    { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
		{ "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
		{ "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
	},
}
