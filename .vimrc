""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 快捷键一览表
""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     c-[	=>返回普通模式
"     空格	=>展开/关闭 折叠
"     zo	=>展开折叠
"     zO	=>深度展开折叠
"     zc	=>折叠
"     zC	=>嵌套折叠
"
"     ,			  =>主键
"     <leader>w	  =>保存
"     <leader>vv  =>编辑配置文件~/.vimrc
"     <leader>gg  =>应用配置文件~/.vimrc
"     <leader>m	  =>去除文件中的^M
"     <leader><F7> normal mode, 查找光标下单词
"     <leader><F7> visual mode, 查找选中的文本
"     <leader><F8> normal mode, 查找并替换:光标下单词
"     <leader><F8> visual mode, 查找并替换:选中的文本
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Normally we use vim-extensions.
set nocompatible 

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't write backup file if vim is being called by "crontab -e"
""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vundle managed plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(glob("~/.mysettings/vim/vundle.vimrc"))
if filereadable(glob("~/.vim/bundle/Vundle.vim/README.md"))
	filetype off   " required
	source ~/.mysettings/vim/vundle.vimrc
endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" g:SystemName  - the system name running vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("macunix")
	let g:OSName = "macos"
elseif has("win32") || has("win64")
	let g:OSName = "windows"
else
	let g:OSName = "ubuntu"
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 查找和应用 project文件 
"      ./proj.vim
"      ../proj.vim
"      ../../proj.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! FindProjectVIM()
	if filereadable(glob("./proj.vim"))
		source ./proj.vim
	elseif filereadable(glob("../proj.vim"))
		exe "cd .."
		source ./proj.vim
	elseif filereadable(glob("../../proj.vim"))
		exe "cd ../.."
		source ./proj.vim
	endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 输入法切换，退出insert模式，自动进入关闭输入法
""""""""""""""""""""""""""""""""""""""""""""""""""""""
if g:OSName=="macos"
	"echo "macos"
	"方法1：用smartim插件，在vundle里面安装。
	"       Add to ~/.vimrc file: Plugin 'ybian/smartim' 
	"       Open vim and run :PluginInstall
	"方法2：用vim的设置（如下）
	"set noimd
	"set iminsert=2
	"set imsearch=2
	"au InsertEnter * set noimd  " 进入插入模式时，恢复输入法
	"au InsertLeave * set imd    " 退出插入模式时，关闭输入法
	"au FocusGained * set imd    " 这个作用不明
elseif g:OSName=="ubuntu"
	"echo "ubuntu"
	let g:input_toggle = 1
	set ttimeoutlen=200
	" 关闭输入法
	function! Fcitx2en()
		let s:input_status = system("fcitx-remote")
		if s:input_status == 2
			let l:a = system("fcitx-remote -c")
			let g:input_toggle = 1
		endif
	endfunction
	" 开启输入法
	function! Fcitx2zh()
		let s:input_status = system("fcitx-remote")
		if s:input_status != 2 && g:input_toggle == 1
			let l:a = system("fcitx-remote -o")
			let g:input_toggle = 0
		endif
	endfunction
	autocmd InsertLeave * call Fcitx2en()  "退出插入模式
	autocmd InsertEnter * call Fcitx2zh()  "进入插入模式
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remember info about open buffers on close
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set viminfo^=%
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" typical settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on " 文件类型插件
syntax on                 " 语法高亮
set autoindent
set smartindent
set noerrorbells " 关闭错误信息响铃
set novisualbell " 关闭使用可视响铃代替呼叫
"set belloff=all  " 关闭所有的铃声, not applicable in Ubuntu
set backupdir=/tmp "备份文件目录
set directory=/tmp "临时文件目录
set undodir=/tmp   "undo文件目录
set noswapfile     "关闭交换文件
set nobackup       "关闭备份文件
set nowritebackup
set backspace=indent,eol,start
set tabstop=4
set softtabstop=4
set smarttab
set shiftwidth=4
"set expandtab "使用空格替代制表符
if g:OSName=="macos"
	set guifont=Monaco:h16
	set guifont=Menlo:h17
	set guifont=Courier\ New:h16
else
	set guifont=Courier\ 14
endif
set linespace=0
set incsearch
set hlsearch
set scrolloff=15   	" 光标移动到buffer的顶部和底部时保持3行距离
set ignorecase          "检索时忽略大小写
set showcmd		    	"display incomplete commands
set helplang=cn         "帮助系统设置为中文
set number              "显示行号
set ruler               "显示位置指示器
set history=512	    	" lines of command line history

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 折叠配置
""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable          " 允许折叠
set foldmethod=syntax   " 缩进折叠
"set foldmethod=indent   " 缩进折叠
set foldminlines=9      " 最少的折叠
set foldlevel=3
set foldclose=all       " 设置为自动关闭折叠
"用空格键来开关折叠
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 文件编码
""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 状态行显示的内容
""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%F%m%r%h%w%y\ %r%{getcwd()}%h\ [%{&ff}]\ [POS=%l,%v][%p%%,\ %L\ lines]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set statusline=%F%m%r%h%w%y\ %r%h\ [%{&ff}]\ [POS=%l,%v][%p%%,\ %L\ lines]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2 "始终显示状态栏
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 颜色配置
""""""""""""""""""""""""""""""""""""""""""""""""""""""
"colorscheme evening
"colorscheme blue
"colorscheme shine
"colorscheme morning
"colorscheme slate "good, white bkgd
"colorscheme peachpuff "good, white bkgd
colorscheme torte
colorscheme zellner
colorscheme darkblue
colorscheme desert
colorscheme industry "good, black bkgd
colorscheme default
hi search ctermbg=darkcyan ctermfg=white
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, so
" that you can undo CTRL-U after inserting a line break.
inoremap <C-u> <C-G>u<C-U>
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:searchpath = "./* ./src/* ../src/*"
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find a word in files
""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! FindVisualTextInFiles()
	let w = expand("<cword>") "光标抓词
	if( !empty(w) )
		let w = "'".w."'"
		execute "grep " w g:searchpath
		copen
	endif
endfunction
" F7 - 跨文件搜索光标处单词
nmap <leader><F7> :call FindVisualTextInFiles()<CR><CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <visual mode> Find selected text in many Files
""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! FindTextInFiles()
	let w = @9
	if( !empty(w) )
		let w = "'".w."'"
		execute "grep " w g:searchpath
		copen<CR>
	endif
endfunction
vmap <leader><F7> "9y:call FindTextInFiles()<CR><CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" visual mode 查找选中的文本，并替换 （使用"9寄存器）
""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! FindAndReplaceVisualText()
	if( !empty(@9) )
		let a:newword = input("replace ".@9." with: ")
		execute "%s/".@9."/".a:newword."/gIc"
	endif
endfunction
vmap <leader><F8> "9y:call FindAndReplaceVisualText()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 查找光标下的单词，并替换 wordxx wordYY
""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! FindAndReplace()
	let a:oldword = expand("<cword>") "光标抓词
	if( !empty(a:oldword) )
		let a:newword = input("replace ".a:oldword." with: ")
		"完整单词匹配
		let a:oldword = "\\<".a:oldword."\\>"
		execute "%s/".a:oldword."/".a:newword."/gIc"
	endif
endfunction
nmap <leader><F8> :call FindAndReplace()<CR>

autocmd BufReadPost * 
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\    exe " normal g`\"" |
	\ endif

" 删除行尾空白( Python and CoffeeScript )
func! DeleteTrailingWS()
  exe "normal! mz"
  %s/\s\+$//ge
  exe "normal! `z"
endfunc

" 设置 YouCompleteMe
let g:ycm_confirm_extra_conf = 0 "not to ask for confirmation
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
nnoremap <leader>jj :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>hh :YcmCompleter GoToImplementationElseDeclaration<CR>
nnoremap <leader>jk :YcmCompleter GoToDefinition<CR>
nnoremap <leader>hk :YcmCompleter GoToDeclaration<CR>
" 往前跳  Ctrl+O
" 往后跳  Ctrl+I


"-------------------- MiniBufferExplorer 的设置----------------------
" 不要在不可编辑内容的窗口（如TagList窗口）中打开选中的buffer
let g:miniBufExplModSelTarget=1
" 按下Ctrl+h/j/k/l，可以切换到当前窗口的上下左右窗口
let g:miniBufExplMapWindowNavVim = 1
" 按下Ctrl+箭头，可以切换到当前窗口的上下左右窗口
let g:miniBufExplMapWindowNavArrows = 1
" 启用以下两个功能：ubuntu好像不支持
"   下一个窗口: Ctrl+tab
"   上一个窗口: Ctrl+Shift+tab
let g:miniBufExplMapCTabSwitchWindows = 1
" 启用以下两个功能：ubuntu好像不支持
"   下一个buffer: Ctrl+tab
"   上一个buffer: Ctrl+Shift+tab
let g:miniBufExplMapCTabSwitchBufs = 1

" 设置 ctags and winmanager
let g:winManagerWindowLayout='FileExplorer|TagList'
nmap wm :WMToggle<cr>
noremap <silent><F9>   <Esc><Esc>:Tlist<CR>
inoremap <silent><F9>  <Esc><Esc>:Tlist<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 设置主键 编辑设置 .vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","
nmap <silent> <leader>gg :source ~/.vimrc<cr>
nmap <silent> <leader>vv :e ~/.vimrc<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" quickfix 快捷键
nmap <leader>cw :cw 10<cr>
nmap <leader>n  :cn<cr>
nmap <leader>p  :cp<cr>
nmap <leader>cc :botright cope<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 快捷键设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F6 - 轮换buffer
"nmap <F6>  <c-tab> |"(使用MiniBufferExplorer插件)
imap <F6>  <Esc><F6>
nmap <F6>  :bn<CR>
nmap <leader><F6>  :bp<CR>

" F4 - next qfix
imap <F4> <Esc><F4>
map <F4> :cn<CR>

" F3 - prev qfix
imap <F3> <Esc><F3>
map <F3> :cp<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 在段落内部定位
""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap 0 g0
vnoremap 0 g0
nnoremap ^ g^
vnoremap ^ g^
nnoremap $ g$
vnoremap $ g$
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 设置和重新映射快捷键
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 快速保存
nmap <leader>w :w!<cr>
" 返回普通模式
vmap <C-[> <ESC>
""""""""""""""""""""""""""""""""""""""""""""""""""""""

call FindProjectVIM()


