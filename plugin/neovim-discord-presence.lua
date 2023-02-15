-- Get Vim-RPC file path from current file path
Rpc = io.popen(debug.getinfo(1).source:match("@?(.*/)") .. '../build/Vim-RPC', 'w')

local start_time = os.time(os.date("*t"))

local function basename(path)
	return vim.fn.fnamemodify(path, ':t')
end

local function ext(path)
	return vim.fn.fnamemodify(path, ':e')
end

local function set_time()
	Rpc:write("start:" .. start_time, "\n")
end

local available_filetypes_icon = {
  [".babelrc"] = true,
  [".bash_profile"] = true,
  [".bashrc"] = true,
  [".DS_Store"] = true,
  [".gitattributes"] = true,
  [".gitconfig"] = true,
  [".gitignore"] = true,
  [".gitlab-ci.yml"] = true,
  [".gitmodules"] = true,
  [".gvimrc"] = true,
  [".npmignore"] = true,
  [".npmrc"] = true,
  [".settings.json"] = true,
  [".vimrc"] = true,
  [".zprofile"] = true,
  [".zshenv"] = true,
  [".zshrc"] = true,
  ["Brewfile"] = true,
  ["CMakeLists.txt"] = true,
  ["COMMIT_EDITMSG"] = true,
  ["COPYING"] = true,
  ["COPYING.LESSER"] = true,
  ["Dockerfile"] = true,
  ["Gemfile$"] = true,
  ["LICENSE"] = true,
  ["R"] = true,
  ["Rmd"] = true,
  ["Vagrantfile$"] = true,
  ["_gvimrc"] = true,
  ["_vimrc"] = true,
  ["ai"] = true,
  ["awk"] = true,
  ["bash"] = true,
  ["bat"] = true,
  ["bmp"] = true,
  ["c"] = true,
  ["c++"] = true,
  ["cbl"] = true,
  ["cc"] = true,
  ["cfg"] = true,
  ["clj"] = true,
  ["cljc"] = true,
  ["cljs"] = true,
  ["cljd"] = true,
  ["cmake"] = true,
  ["cob"] = true,
  ["cobol"] = true,
  ["coffee"] = true,
  ["conf"] = true,
  ["config.ru"] = true,
  ["cp"] = true,
  ["cpp"] = true,
  ["cpy"] = true,
  ["cr"] = true,
  ["cs"] = true,
  ["csh"] = true,
  ["cson"] = true,
  ["css"] = true,
  ["csv"] = true,
  ["cxx"] = true,
  ["d"] = true,
  ["dart"] = true,
  ["db"] = true,
  ["desktop"] = true,
  ["diff"] = true,
  ["doc"] = true,
  ["dockerfile"] = true,
  ["drl"] = true,
  ["dropbox"] = true,
  ["dump"] = true,
  ["edn"] = true,
  ["eex"] = true,
  ["ejs"] = true,
  ["elm"] = true,
  ["epp"] = true,
  ["erb"] = true,
  ["erl"] = true,
  ["ex"] = true,
  ["exs"] = true,
  ["f#"] = true,
  ["favicon.ico"] = true,
  ["fnl"] = true,
  ["fish"] = true,
  ["fs"] = true,
  ["fsi"] = true,
  ["fsscript"] = true,
  ["fsx"] = true,
  ["gd"] = true,
  ["gemspec"] = true,
  ["gif"] = true,
  ["git"] = true,
  ["glb"] = true,
  ["go"] = true,
  ["godot"] = true,
  ["gruntfile"] = true,
  ["gulpfile"] = true,
  ["h"] = true,
  ["haml"] = true,
  ["hbs"] = true,
  ["heex"] = true,
  ["hh"] = true,
  ["hpp"] = true,
  ["hrl"] = true,
  ["hs"] = true,
  ["htm"] = true,
  ["html"] = true,
  ["hxx"] = true,
  ["ico"] = true,
  ["import"] = true,
  ["ini"] = true,
  ["java"] = true,
  ["jl"] = true,
  ["jpeg"] = true,
  ["jpg"] = true,
  ["js"] = true,
  ["json"] = true,
  ["jsx"] = true,
  ["ksh"] = true,
  ["kt"] = true,
  ["kts"] = true,
  ["leex"] = true,
  ["less"] = true,
  ["lhs"] = true,
  ["license"] = true,
  ["lua"] = true,
  ["makefile"] = true,
  ["markdown"] = true,
  ["material"] = true,
  ["md"] = true,
  ["mdx"] = true,
  ["mint"] = true,
  ["mix.lock"] = true,
  ["mjs"] = true,
  ["ml"] = true,
  ["mli"] = true,
  ["mo"] = true,
  ["mustache"] = true,
  ["nim"] = true,
  ["nix"] = true,
  ["node_modules"] = true,
  ["opus"] = true,
  ["otf"] = true,
  ['package.json'] = true,
  ['package-lock.json'] = true,
  ["pck"] = true,
  ["pdf"] = true,
  ["php"] = true,
  ["pl"] = true,
  ["pm"] = true,
  ["png"] = true,
  ["pp"] = true,
  ["ppt"] = true,
  ["pro"] = true,
  ["Procfile"] = true,
  ["ps1"] = true,
  ["psb"] = true,
  ["psd"] = true,
  ["py"] = true,
  ["pyc"] = true,
  ["pyd"] = true,
  ["pyo"] = true,
  ["r"] = true,
  ["rake"] = true,
  ["rakefile"] = true,
  ["rb"] = true,
  ["rlib"] = true,
  ["rmd"] = true,
  ["rproj"] = true,
  ["rs"] = true,
  ["rss"] = true,
  ["sass"] = true,
  ["scala"] = true,
  ["scss"] = true,
  ["sh"] = true,
  ["sig"] = true,
  ["slim"] = true,
  ["sln"] = true,
  ["sml"] = true,
  ["sql"] = true,
  ["sqlite"] = true,
  ["sqlite3"] = true,
  ["styl"] = true,
  ["sublime"] = true,
  ["suo"] = true,
  ["sv"] = true,
  ["svelte"] = true,
  ["svh"] = true,
  ["svg"] = true,
  ["swift"] = true,
  ["t"] = true,
  ["tbc"] = true,
  ["tcl"] = true,
  ["terminal"] = true,
  ["tex"] = true,
  ["toml"] = true,
  ["tres"] = true,
  ["ts"] = true,
  ["tscn"] = true,
  ["tsx"] = true,
  ["twig"] = true,
  ["txt"] = true,
  ["v"] = true,
  ["vh"] = true,
  ["vhd"] = true,
  ["vhdl"] = true,
  ["vim"] = true,
  ["vue"] = true,
  ["webmanifest"] = true,
  ["webp"] = true,
  ["webpack"] = true,
  ["xcplayground"] = true,
  ["xls"] = true,
  ["xml"] = true,
  ["xul"] = true,
  ["yaml"] = true,
  ["yml"] = true,
  ["zig"] = true,
  ["zsh"] = true,
  ["sol"] = true,
  [".env"] = true,
  ["prisma"] = true,
  ["lock"] = true,
  ["log"] = true,
}

local function set_buffer_state()
	local filename = basename(vim.api.nvim_buf_get_name(0))
	local extension = ext(vim.api.nvim_buf_get_name(0))

	if vim.bo.buftype == "terminal" then
		Rpc:write("state:In terminal", "\n")
		Rpc:write("small_image:terminal", "\n")
		Rpc:write("small_text:" .. filename, "\n")
	elseif vim.bo.buftype == "help" then
		Rpc:write("state:Reading vim help pages", "\n")
		Rpc:write("small_image:txt", "\n")
		Rpc:write("small_text:" .. filename, "\n")
	elseif vim.bo.buftype == "" then
		Rpc:write("state:Editing file " .. filename, "\n")

		if available_filetypes_icon[extension] == true then
			local cleaned_extension = extension:gsub("[^%w%s]", "_")
			Rpc:write("small_image:" .. cleaned_extension, "\n")
		elseif available_filetypes_icon[vim.bo.filetype] == true then
			local cleaned_filetype, _ = vim.bo.filetype:gsub("[^%w%s]", "_") -- Replace non-alphanumeric characters by underscores ( c++ -> c__ )
			Rpc:write("small_image:" .. cleaned_filetype, "\n")
		else
			Rpc:write("small_image:txt", "\n")
		end

		Rpc:write("small_text:" .. vim.bo.filetype, "\n")
	end

	-- set_time()

	Rpc:flush()
end

local function set_project_state()
	local dir = basename(vim.fn.getcwd()) -- Get current working directory's basename

	Rpc:write('details:In directory ' .. dir, "\n")

	Rpc:flush()
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = set_buffer_state
})

vim.api.nvim_create_autocmd({ "DirChanged" }, {
	callback = set_project_state
})

vim.api.nvim_create_autocmd({"VimLeave"}, {
	callback = function()
		Rpc:write("quit", "\n")
		Rpc:flush()
	end
})

vim.defer_fn(function()
	Rpc:write("large_image:neovim", "\n")
	Rpc:write("large_text:The One True Text Editor", "\n")

	set_time()

	set_buffer_state()
	set_project_state()

	-- timer:close()
end, 2000)
