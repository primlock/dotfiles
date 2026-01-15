-- treesitter is a set of programming language parsers, so that nvim can understands your code text as a tree 
-- of PL constructs (field, method, function, keyword ...), so it can use those information to do folding, 
-- highlighting, text-object manipulating (delete a function's content, change a class' content, ...), and 
-- much more
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "json",
      "lua",
      "vim",
      "c",
      "cpp",
      "regex",
	  "python",
    },
  },
}
