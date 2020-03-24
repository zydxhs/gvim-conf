" vim 中文帮助下载地址：http://vimcdoc.sourceforge.net/，改用插件 asins/vimcdoc
" linux 安装使用：
" 1. mkdir -p ~/.vim/autoload
" 2. curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 3. mv _vimrc ~/.vimrc
" 4. 打开vim，执行 PlugInstall 安装插件
" 5. 进入 ~/.vim/bundle/vimproc，执行 make 命令
"
" Sections
" -> 运行环境判断
" -> 插件管理
" -> 常规配置
" -> 用户命令
" -> Colors and Fonts
" -> Files and backups
" -> Text, tab and indent related
" -> Visual mode related
" -> Moving around, tabs and buffers
" -> Status line
" -> Editing mappings
" -> vimgrep searching and cope displaying
" -> Misc
" -> Helper functions
" -> 常用工具配置
" -> 插件配置 
" -----------------------------------------------------------------------------

set nocompatible    " 禁用兼容模式
filetype off        " 禁用文件类型侦测

" << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================
let g:isWindows = 0
let g:isLinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:isWindows = 1
else
    let g:isLinux = 1
endif

if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

"  < Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if (g:isWindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin

    if &diffopt !~# 'internal'
        set diffexpr=MyDiff()
    endif

    function! MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg1 = substitute(arg1, '!', '\!', 'g')
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg2 = substitute(arg2, '!', '\!', 'g')
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let arg3 = substitute(arg3, '!', '\!', 'g')
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
              if empty(&shellxquote)
                  let l:shxq_sav = ''
                  set shellxquote&
              endif
              let cmd = '"' . $VIMRUNTIME . '\diff"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        let cmd = substitute(cmd, '!', '\!', 'g')
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
        if exists('l:shxq_sav')
            let &shellxquote=l:shxq_sav
        endif
    endfunction
endif

"  < Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if g:isLinux
    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif

if g:isWindows
    set rtp+=$VIM/vimfiles/bundle
endif

" < vim-plug 插件管理工具配置 >
" -----------------------------------------------------------------------------
" 安装方法：
" 1. 从 https://github.com/junegunn/vim-plug/ 下载 plug.vim，
" windows:拷贝到 $VIM/vimfiles/autoload
" linux:拷贝到 ~/.vim/autoload
" 2. 安装 git 到本机，添加 GIT 的 %GIT%\bin、%GIT%\cmd 目录到环境变量
" 3. 新建 ~/.vim/colors 目录，存放本色方案
" 4. 新建 ~/.vim/bundle 目录，在 vim 中使用命令 PlugInstall/PlugUpdate 安装/更新插件

if g:isLinux
    call plug#begin('~/.vim/bundle/')
else
    "set rtp+=$VIM/vimfiles/bundle/vim-plug     "插件管理器路径
    call plug#begin('$VIM/vimfiles/bundle/')
endif

" 使用说明详见 =$VIM/vimfiles/autoload/plug.md
" PlugInstall [name ...] [#threads]     安装插件
" PlugUpdate [name ...] [#threads]      安装或更新插件
" PlugClean[!]                          移除未使用的插件
" PlugUpgrade                           更新 vim-plug 自身
" PlugStatus                            检查插件状态
" PlugDiff                              比较上次更新与本次更新的差别
" PlugSnapshot[!] [output path]         生成当前安装插件的备份脚本
"
" 通用插件
" ... matchit 是 vim 自带插件
" runtime macros/matchit.vim
source $VIMRUNTIME/macros/matchit.vim

Plug 'asins/vimcdoc'                    " vim 中文文档
Plug 'ctrlpvim/ctrlp.vim', {'as': 'ctrlp'}  " 对文件以及buffer进行模糊查询，快速打开文件。国人优化版
Plug 'tacahiroy/ctrlp-funky'            " ctrlp 的插件，作用：模糊搜索当前文件中所有函数
Plug 'Lokaltog/vim-easymotion'          " 快速移动
Plug 'jrosiek/vim-mark'                 " 不同的单词高亮
Plug 'terryma/vim-multiple-cursors'     " 多光标编辑
Plug 'oblitum/rainbow'                  " 括号高亮，取代 cSyntaxAfter。cSyntaxAfter 会导致语法折叠失效
Plug 'Yggdroot/indentLine'              " 缩进对齐线样式
Plug 'tomtom/tcomment_vim', {'as': 'tcomment'}  " 快速注释
" Plug 'tpope/vim-commentary'                   " 快速注释
Plug 'vim-scripts/DoxygenToolkit.vim', {'as': 'DoxygenToolkit'}
Plug 'Raimondi/delimitMate'             " 生成配对括号
Plug 'godlygeek/tabular'                " 对齐
Plug 'gcmt/wildfire.vim', {'as': 'wildfire'}    " 快速选中结对符内的文本
Plug 'vim-scripts/TaskList.vim', {'as': 'TaskList'} " TODO 任务列表
Plug 'MattesGroeger/vim-bookmarks'      " 书签

" ... 搜索相关。ag.vim 代码搜索，速度比 ack 快上153%. 关键词各种秒搜而且自动忽略.git .,svn 类似的版本控制文件。且速度比 IDE 快了不少，而且定位代码速度飞快。ctrlsf 全局代码搜索插件。
" Plug 'dkprice/vim-easygrep', {'as': 'easygrep'}
" Plug 'rking/ag.vim', {'as': 'ag'}
" ag : https://github.com/ggreer/the_silver_searcher
" Plug 'dyng/ctrlsf.vim', {'as': 'ctrlsf'}

" ... 在 Vim中完成各种CMD，终端操作。 从来没有见过，如此优雅的Shell 执行方式。 直接打开GUI 在里面模拟一个终端。
" Plug 'Shougo/vimproc.vim', {'as': 'vimproc'} | Plug 'Shougo/vimshell.vim', {'as': 'vimshell'}
" set rtp+=$VIM/vimfiles/bundle/vimproc
Plug 'tpope/vim-repeat' | Plug 'tpope/vim-surround'
" ... 区域扩展
" Plug 'terryma/vim-expand-region'

" 代码补全
" if g:isWindows
" Plug 'Shougo/neocomplete.vim', {'as': 'neocomplete'}  " neocomplete 是 neocomplcache 的升级版，需要 lua 支持
Plug 'Shougo/neocomplcache.vim', {'as': 'neocomplcache'}
" " ... node.js 补全 内建模块的方法/属性补全 
" Plug 'myhere/vim-nodejs-complete'
" else
" Plug 'Valloric/YouCompleteMe'
" " ... 可以实现node所有模块的方法/属性补全
" Plug 'ternjs/tern_for_vim', {'do': 'npm install'}
" endif
" 自动关闭 html/xml 标签
Plug 'alvan/vim-closetag', {'as': 'closetag'}

" 代码片段
" Plug 'msanders/snipmate.vim', {'as': 'snipmate'}
Plug 'Shougo/neosnippet'
Plug 'honza/vim-snippets', {'as': 'vim_snippets'}
" Plug 'mattn/emmet-vim', {'as': 'emmet'}             " html/css

" 表格插件
Plug 'dhruvasagar/vim-table-mode'
" Plug 'plasticboy/vim-markdown'    " 依赖 tabular
" Plug 'iamcco/markdown-preview.vim', {'as': 'markdown-preview'}
" pandoc
Plug 'vim-pandoc/vim-pandoc' | Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-pandoc/vim-markdownfootnotes'

"语法检查插件
" Plug 'scrooloose/syntastic'

" 语法高亮
Plug 'octol/vim-cpp-enhanced-highlight'
" ... node 模板引擎语法高亮，原来的 vim-jade
" Plug 'digitaltoad/vim-pug'
" Plug 'dNitro/vim-pug-complete'
" ... 高亮匹配的标签
Plug 'valloric/MatchTagAlways'

" Plug 'hari-rangarajan/CCTree'   " 函数调用关系
" Plug 'jsfaint/gen_tags.vim', {'as': 'gen_tags'}     " 自动生成与维护 ctags/gtags 数据库

Plug 'derekwyatt/vim-fswitch', {'as': 'fswitch'}               " .h .cpp 快速切换
" Plug 'vim-scripts/c.vim', {'as': 'c'}

" Plug 'mbbill/echofunc'      " 函数参数提示
" Plug 'vim-scripts/ccvext.vim', {'as': 'ccvext'}

" asciidoc
" .vim-asciidoc 增强的asciidoc文本编辑插件,依赖vimple/Asif/VimRegStyle
" Plug 'dahu/vimple' | Plug 'dahu/Asif' | Plug 'Raimondi/VimRegStyle' | Plug 'dahu/vim-asciidoc'

" 界面插件
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" 配色

" 多功能插件
" ... CoffeeScript : 高亮、缩进、编译等
" Plug 'kchmck/vim-coffee-script'
" . 带折叠双栏树状态文本管理
Plug 'vim-scripts/VOoM'

call plug#end()

" => General
" -----------------------------------------------------------------------------
set history=100                         " 历史记录的行数
filetype on                             " 启动文件类型侦测
filetype plugin indent on               " 自动识别文件类型，启用文件类型插件，使用缩进定义文件
set autoread                            " 文件在外部修改时自动更新
set relativenumber                      " 相对行号
set fillchars=vert:\ ,stl:\ ,stlnc:\    " 在被分割的窗口间显示空白，便于阅读

let mapleader=","               " <leader>默认为'\'键，将其改映射为','键
let g:mapleader=","

" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
if g:isGUI
    set mouse=a
else
    set mouse=c
endif
set selection=inclusive                 " 必须打开，会影响 vim-multiple-cursors 的多重选择
" set selectmode=mouse,key

" 设置工作目录为当前编辑文件的目录
set bsdir=buffer
" set autochdir                           " autochdir 与插件 vimshell 冲突

" set shortmess=atI                       " 去掉欢迎界面

" 设置 gVim 窗口初始位置及大小
if g:isGUI
    " au GUIEnter * simalt ~x      " 窗口启动时自动最大化
    winpos 100 100               " 指定窗口出现的位置，坐标原点在屏幕左上角
    set lines=37 columns=130     " 指定窗口大小，lines为高度，columns为宽度

    " 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F12 切换
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    map <silent> <c-F12> :if &guioptions =~# 'm' <Bar>
        \set guioptions-=m <Bar>
        \set guioptions-=r <Bar>
        \set guioptions-=L <Bar>
    \else <Bar>
        \set guioptions+=m <Bar>
        \set guioptions+=r <Bar>
        \set guioptions+=L <Bar>
    \endif<CR>
endif

set so=4                            " 使用 h,j 时上、下保持的行数
set wildmenu                        " 启用增强补全模式
set wildignore=*.o,*~,*.pyc,*.obj   " 忽略编译中间文件
set ruler                           " 右下角显示光标坐标
set cmdheight=2                     " 设置命令行的高度为2，默认为1
set showcmd                         " 显示未敲完的命令
set hid                             " 缓冲区被抛弃时隐藏
set viminfo+=!                      " 保存全局变量

set backspace=eol,start,indent      " 使退格键（backspace）正常处理 indent, eol, start 等    
set whichwrap+=<,>,h,l              " 允许 backspace 和光标键跨越行边界

set ignorecase                      " 搜索时忽略大小写
set smartcase                       " 如果搜索时包含大写字符，忽略 'ignorecase' 选项
set hlsearch                        " 高亮搜索结果
set incsearch                       " 增量搜索
set lazyredraw                      " 执行宏时不重绘界面
set magic                           " 正则表达式中 除了 $.*^ 之外的其它元字符，都要加反斜杠
set showmatch                       " 输入括号时,短暂时跳转到匹配的括号
set matchtime=5                     " 匹配括号高亮的时间（单位是十分之一秒）

set noerrorbells                    " 不让vim发出讨厌的滴滴声
set novisualbell                    " 不要闪烁
set t_vb=                           " 关闭提示音/闪烁
set tm=500

set confirm                         " 在处理未保存或只读文件的时候，弹出确认
set clipboard+=unnamed              " 与系统共享剪贴板

" => 用户命令
" -----------------------------------------------------------------------------
" 帮助文档的语言
" set helplang=en/cn/utf-8

" 输入 :set list 命令时应该显示哪些特殊字符；:set nolist 取消显示
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$

" 列模式
map <leader>v <C-Q>

" 保存文件
map <leader>s :w<CR>
imap <leader>s <ESC>:w<CR>
" 关闭文件
map <leader>c :bd<CR>

" 在VIM中快速打开配置文件
map <silent> <leader>ee :e $MYVIMRC<cr>
" 快速重新载入配置文件
" map <silent> <leader>ss :source $MYVIMRC<cr>
" 在VIM中修改配置，保存后不需要重启即可生效，不需要任何操作。
autocmd! BufWritePost $MYVIMRC source $MYVIMRC

" F5打开 netrw 插件的文件浏览窗口， :bd 关闭文件浏览窗口
" 大写 P 在上次使用的窗口中打开文件
nmap <F5> :Vexplore<cr>
imap <F5> <ESC>:Vexplore<cr>
let g:netrw_liststyle=1
let g:netrw_winsize = 30

" function! TT()
"     if bufwinnr("FileExplorer") == -1
"         :Vexplore
"     else
"         :Rexplore
"     endif
" endfunction

" C/C++ 代码美化
nmap <F8>   :call AStyle()<cr>

" markdown 格式转为 html，并打开浏览器预览
" nnoremap <leader>mdp :MarkdownPreview<CR>
" nnoremap <C-M> :MarkdownPreview<CR>
" markdown 格式转为 html，并打开浏览器预览，pandoc
nnoremap <leader>mp :call PreviewMarkdown()<CR>

" 用空格键来开关折叠
" zf% 在括号处，创建从当前行起到对应的匹配的括号上去( ()，{}，[]，<>等)的折叠
set foldenable           " 启用折叠
set foldlevel=4          " 启动vim时不要自动折叠代码
set foldmethod=indent    " 折叠方式 manual,indent,expr,syntax,diff,marker
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
"za 打开/关闭在光标下的折叠
"zA 循环地打开/关闭光标下的折叠
"zo 打开在光标下的折叠
"zO 循环地打开光标下的折叠
"zc 关闭在光标下的折叠
"zC 循环地关闭在光标下的折叠
"zM 关闭所有折叠
"zR 打开所有的折叠

" 自动格式化, 可以用 "gq" 进行手工排版
set formatoptions=bqnro1jB


" => Colors and Fonts
" -----------------------------------------------------------------------------
syntax enable                   " 启用语法高亮
set cursorcolumn                " 高亮光标所在列
set cursorline                  " 突出显示当前行
hi cursorline gui=underline guibg=NONE
set renderoptions=type:directx,renmode:5,taamode:1  " direct2d 渲染
" set guifont=YaHeiConsolasZyd:h12                    " 设置字体:字号（字体名称空格用下划线代替）
set guifont=等距更纱黑体_T_SC:h12:cGB2312:qDRAFT                    " 设置字体:字号（字体名称空格用下划线代替）

colo molokai        "molokai, solarized, lucius, darkburn, seti

" => Files, backups and undo
" -----------------------------------------------------------------------------
" 不管文件的编码如何，不管如何显示和输入，让 Vim 内部使用编码 UTF-8。这是国际化支持的基础。
set encoding=utf-8                                    " 设置gvim内部编码

" utf-8 编码添加、删除 BOM
" :setlocal nobomb
:setlocal bomb

" 文件转码方法
" set fileencoding=目标编码，w 保存即可。

" 新建文件时，文件采用的编码为 chinese。如果保存文件时，你不希望使用文件本身的编码，那么，
" 你可以通过手工设定该选项来更改文件保存时采用的编码，如 **|:set fileencoding=utf-8|** 
" 需要注意的一点是，使用“set”来设定该选项的话会改变以后新建文件的缺省编码，
" 而使用“setlocal”的话则只影响当前文件（参考|:help setlocal|）。
set fileencoding=utf-8                              " 设置当前文件编码

" Vim 在载入已有文件时会首先判断文件的开头是否是一个 Unicode 的 BOM（byte order mark）字符，
" 是的话则把文件的其余内容解释成相应的 Unicode 序列；否的话再试图把文件内容解释成 UTF-8 的序列；
" 再失败的话，则把文件解释为简体中文（chinese 是一个跨平台的简体中文字符集的别名，
" Linux 下相当于 gb2312 和 euc-cn，Windows 下相当于cp936）。需要注意的是，该顺序不能颠倒，
" 不能把 utf-8 或别的 Unicode 编码放在 ucs-bom 的前面。并且在后面再添加其它编码如 big5、latin1 也是没有意义的，
" 因为 Vim 不能识别 8 比特编码中的错误，因此这些编码后列的编码永远不会被用到。此选项不会用于新建文件。
set fileencodings=ucs-bom,utf-8,chinese               " 设置支持打开的文件的编码

" 把所有的“不明宽度”字符(指的是在 Unicode 字符集中某些同时在东西方语言中使用的字符，
" 如省略号、破折号、书名号和全角引号，在西方文字中通常字符宽度等同于普通 ASCII 字符，
" 而在东方文字中通常字符宽度等同于两倍的普通 ASCII 字符，因而其宽度“不明”)的宽度置为双倍字符宽度（中文字符宽度）。
" 此数值只在 encoding 设为 utf-8 或某一 Unicode 编码时才有效。
" 需要额外注意的是，如果你通过终端使用 Vim 的话，需要令终端也将这些字符显示为双宽度……
set ambiwidth=double

" 终端使用的编码
" set termencoding=cp936

" 文件格式，默认 ffs=dos,unix
set fileformat=unix             " 设置新文件的<EOL>格式
set fileformats=unix,dos        " 给出文件的<EOL>格式类型

if (g:isWindows)
    if (g:isGUI)
        "解决菜单乱码
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
    endif

    "解决输出乱码
    language messages zh_CN.utf-8
endif

" 编辑文件时建立备份，保存成功后删除该备份。
set writebackup
set nobackup
set noswapfile
set noundofile                  " 不使用撤消列表文件
" 备份/撤消 文件路径
if g:isWindows
    set directory=%temp%
    set undodir=%temp%
else
    set directory=/var
    set undodir=/var
endif

au BufNewFile,BufRead *.qss set filetype=css

" => Text, tab and indent related
" -----------------------------------------------------------------------------
set expandtab               " 将Tab键转换为空格
set autoindent              " 自动缩进
set smartindent             " 新行智能自动缩进
set smarttab                " 按一次backspace就删除shiftwidth宽度的空格
set cindent                 " 使用C/C++样式的缩进
" set cino=:0g0t0(sus         " C/C++风格自动缩进

" jade 模板文件类型为 pug
autocmd FileType * setlocal tabstop=4|setlocal shiftwidth=4|setlocal softtabstop=4
autocmd FileType nsis,javascript,html,pug setlocal tabstop=2|setlocal shiftwidth=2|setlocal softtabstop=2


set linebreak               " 自动换行不截断单词
set textwidth=100           " 列宽
set colorcolumn=+1          " 高亮 textwidth 之后的列
" 启用每行超过100列的字符提示（字体变蓝），不启用就注释掉
au BufWinEnter let w:m2=matchadd('normal', '\%>' . 100 . 'v.\+', -1)

set autoindent              " 自动缩进
set smartindent             " 智能缩进
set wrap                    " 自动换行
set iskeyword+=_,$,@,%,#    " 带有如下符号的单词不要被换行分割

" => Visual mode related
" -----------------------------------------------------------------------------
" visual 模式下，* 向前、# 向后搜索当前选中的文字
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" => Moving around, tabs, windows and buffers
" -----------------------------------------------------------------------------
" 超长自动换行的行，上、下移动时当作多行移动
map j gj
map k gk

" 在多个窗口之智能的移动
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" 标签页
" map <leader>tn :tabnew %<cr>
" map <leader>to :tabonly<cr>
" map <leader>tc :tabclose<cr>
" map <leader>tm :tabmove
" 使用当前缓冲的路径，在新标签页中编辑文件
" map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" => Status line
" -----------------------------------------------------------------------------
set laststatus=2                " 启用状态栏信息
" set statusline=%t%m%r%h%w%q\ %=%-10.(\|\ %{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\"}[%{&ff}]%y%)\ \|\ %=%-20.(\(%l,%v\)=0X%B\ %P%)

" Editing mappings
" -----------------------------------------------------------------------------
"文本行上移、下移
nmap <A-j> mz:m+<cr>
vmap <A-j> :m'>+<cr>
nmap <A-k> mz:m-2<cr>
vmap <A-k> :m'<-2<cr>

" nmap cS :%s/\s\+$//g<CR>:noh<CR>   " 常规模式下输入 cS 清除行尾空格
nmap cM :%s/\r$//g<CR>:noh<CR>     " 常规模式下输入 cM 清除行尾 ^M 符号
" 保存文件时删除行尾空格/tab
func! DeleteTrailingWS()
  let previous_search=@/  
  let previous_cursor_line=line('.')  
  let previous_cursor_column=col('.')  
  %s/\s\+$//e  
  let @/=previous_search  
  call cursor(previous_cursor_line, previous_cursor_column)
endfunc
autocmd BufWrite *.{c,cpp,h,hpp,cxx,hh,cc,java,javascript} :call DeleteTrailingWS()

" => vimgrep searching and cope displaying
" -----------------------------------------------------------------------------
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>
map <leader>cw :cw 10<cr>

" => Helper functions
" -----------------------------------------------------------------------------
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! PreviewMarkdown()
    if &filetype != 'markdown' && &filetype != 'pandoc'
        return
    endif
    " let CMD=expand($VIM) . '\tools\pandoc\pandoc'
    let CMD='pandoc'
    if !executable(CMD)
        echohl ErrorMsg | echo 'Please install pandoc first.' | echohl None
        return
    endif
    if g:isWindows
        let BROWSER_COMMAND = 'cmd.exe /c start ""'
        " let css_file = 'file://' . expand($VIM . '/github.css', 1)
        let css_file = expand($VIM . '/github.css', 1)
        silent! execute '!copy /y "' . css_file . '" github.css'
    elseif g:isLinux
        let BROWSER_COMMAND = 'xdg-open'
        let css_file = expand($HOME . '/.vim/github.css', 1)
        silent! execute '!cp -f "' . css_file . '" github.css'
    " elseif s:isMac
    "     let BROWSER_COMMAND = 'open'
    endif
    let css_file = 'github.css'
    " let output_file = tempname() . '.html'
    let output_file = expand('%:p:r') . '.html'
    let input_file = tempname() . '.md'
    " Convert buffer to UTF-8 before running pandoc
    let original_encoding = &fileencoding
    let original_bomb = &bomb
    silent! exec 'set fileencoding=utf-8 nobomb'
    " Generate html file for preview
    let content = getline(1, '$')
    let newContent = []
    for line in content
        let str = matchstr(line, '\(!\[.*\](\)\@<=.\+\.\%(png\|jpe\=g\|gif\)')
        if str != "" && match(str, 'https\=:\/\/') == -1
            let newLine = substitute(line, '\(!\[.*\]\)(' . str . ')',
                        \'\1(file://' . escape(expand("%:p:h", 1), '\') .
                        \(g:isWindows ? '\\\\' : '/') .
                        \escape(expand(str, 1), '\') . ')', 'g')
        else
            let newLine = line
        endif
        call add(newContent, newLine)
    endfor
    call writefile(newContent, input_file)
    let PARAM='-f markdown -t html5 -s -S -c "' . css_file . '" -o "' . output_file .'" "' . input_file . '"'
    silent! exec '!' CMD PARAM
    " Preview 
    silent! exec '!' . BROWSER_COMMAND . ' "' . output_file . '"'
    call delete(input_file)
    " Change encoding back
    silent! exec 'set fileencoding=' . original_encoding . ' ' . original_bomb
    exec input('Press ENTER to continue...')
    echo
    call delete(output_file)
endfunction

function! AStyle()
    let CMD=expand($VIM) . '\tools\AStyle'

    if &filetype == 'c' || &filetype == 'cpp'
        let PARAM="-A1 -s4 -xn -xk -K -xW -w -Y -m0 -M60 -f -p -H -U -y -J -O -o -c -xC120 -xL -k3 -W3 -q -z1"
        exec '!' . CMD PARAM "%"
    elseif &filetype == 'javascript'
        let PARAM="-A2 -s2 -t2 -q"
        exec '!' . CMD PARAM "%"
    endif
endfunction


" << 以下为常用工具配置 >>
" =============================================================================
"  < ctags 工具配置 >
" -----------------------------------------------------------------------------
" 对浏览代码非常的方便,可以在函数,变量之间跳转等
set tags=tags;                            " 向上级目录递归查找tags文件（好像只有在Windows下才有用）
"set tags+=e:/ctags/tags;
"au BufRead,BufNewFile,BufEnter * cd %:p:h   " 自动切换目录为当前编辑文件所在目录
" 生成tag文件
"function! GenerateTagsFile()
"    exec ":!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
"endfunction
"nnoremap <leader>ctag   :call GenerateTagsFile() <cr>

"tag命令用法：
"- Ctrl＋］  跳到当前光标下单词的标签
"- Ctrl＋O  返回上一个标签
"- Ctrl＋T  返回上一个标签
"- :tag TagName 跳到TagName标签
" 以上命令是在当前窗口显示标签，当前窗口的文件替代为包标签的文件，当前窗口光标跳到标签位置。如果不希望在当前窗口显示标签，可以使用以下命令：
"- :stag TagName 新窗口显示TagName标签，光标跳到标签处
"- Ctrl＋W + ］  新窗口显示当前光标下单词的标签，光标跳到标签处
" 当一个标签有多个匹配项时（函数 (或类中的方法) 被多次定义），":tags" 命令会跳转到第一处。如果在当前文件中存在匹配，那它将会被首先使用。
" 可以用这些命令在各匹配的标签间移动：
"- :tfirst    到第一个匹配
"- :[count]tprevious 向前 [count] 个匹配
"- :[count]tnext  向后 [count] 个匹配
"- :tlast    到最后一个匹配
" 或者使用以下命令选择要跳转到哪一个
"- :tselect TagName
" 输入以上命令后，vim会为你展示一个选择列表。然后你可以输入要跳转到的匹配代号 (在第一列)。其它列的信息可以让你知道标签在何处被定义过。
" 以下命令将在预览窗口显示标签
"- :ptag TagName 预览窗口显示TagName标签，光标跳到标签处
"- Ctrl＋W + }  预览窗口显示当前光标下单词的标签，光标跳到标签处
"- :pclose   关闭预览窗口
"- :pedit file.h 在预览窗口中编辑文件file.h（在编辑头文件时很有用）
"- :psearch atoi 查找当前文件和任何包含文件中的单词并在预览窗口中显示匹配，在使用没有标签文件的库函数时十分有用。

"  < cscope 工具配置 >
" -----------------------------------------------------------------------------
" 用Cscope自己的话说 - "你可以把它当做是超过频的ctags"
"- cscope -Rbq                "在项目的根目录运行下面的命令
" 把生成的cscope文件导入到vim中来
"- :cs add /home/wooin/vim74/cscope.out /home/wooin/vim74
"- map <F4> :cs add ./cscope.out .<CR><CR><CR> :cs reset<CR>
"- imap <F4><ESC> :cs add ./cscope.out .<CR><CR><CR> :cs reset<CR>

if has("cscope")
   "set csprg=/usr/bin/cscope               " 设置cscope命令路径
    let CS=expand($VIM) . '\tools\cscope'
    " set csprg=CS
    set cscopequickfix=s-,c-,d-,i-,t-,e-    " 设定可以使用 quickfix 窗口来查看 cscope 结果
    set csto=0                              " cstag命令查找次序：0先找cscope数据库，1先找标签文件
    set cst                                 " 同时搜索cscope数据库和标签文件
    set cscopetag                           " 使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳转

    if filereadable("cscope.out")           " 在当前目录中添加任何数据库
        cs add cscope.out
    elseif $CSCOPE_DB != ""                 " 否则添加数据库环境中所指出的
        cs add $CSCOPE_DB
    endif
    set cscopeverbose
endif
"快捷键设置
"s: C语言符号  g: 定义       d: 这个函数调用的函数  c: 调用这个函数的函数
"t: 文本       e: egrep模式  f: 文件               i: include本文件的文件
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR> :cw<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR> :cw<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR> :cw<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR> :cw<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR> :cw<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR> 
nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR> :cw<CR><CR>
nmap <F4> <C-\>c


" << windows 下解决 Quickfix 乱码问题 >>
" =============================================================================
" windows 默认编码为 cp936，而 Gvim(Vim) 内部编码为 utf-8，所以常常输出为乱码
" 以下代码可以将编码为 cp936 的输出信息转换为 utf-8 编码，以解决输出乱码问题
" 但好像只对输出信息全部为中文才有满意的效果，如果输出信息是中英混合的，那可能
" 不成功，会造成其中一种语言乱码，输出信息全部为英文的好像不会乱码
" 如果输出信息为乱码的可以试一下下面的代码，如果不行就还是给它注释掉
" if g:iswindows
"     function QfMakeConv()
"         let qflist = getqflist()
"         for i in qflist
"            let i.text = iconv(i.text, "cp936", "utf-8")
"         endfor
"         call setqflist(qflist)
"      endfunction
"      au QuickfixCmdPost make call QfMakeConv()
" endif


" << 以下为常用插件配置 >>
" =============================================================================
" matchit
let b:match_words='if:endif, function:endfunction'

" ctrlp: 文件搜索 CTRL+P 打开CtrlP搜索，CTRL+J/K 上下移动
if (&rtp =~ 'ctrlp') && isdirectory(expand("$VIM/vimfiles/bundle/ctrlp"))
    " let g:ctrlp_cmd = 'exe "CtrlP".get(["", "MRU", "Buffer"], v:count)'
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlPMRU'    " 可选命令 CtrlP CtrlPMRU CtrlPBuffer CtrlPMixed
    let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
        \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
        \ }
    let g:ctrlp_regexp = 1                  " 正则表达式匹配
    let g:ctrlp_reuse_window = 'netrw'      " 使用 <cr> 打开新文件时，允许在 netrw 窗口打开
    let g:ctrlp_working_path_mode='ra'
    " let g:ctrlp_match_window_bottom=1
    " let g:ctrlp_max_height=15
    " let g:ctrlp_match_window_reversed=0
    let g:ctrlp_follow_symlinks=1
    let g:ctrlp_mruf_max=50
    " 自定义搜索列表提示符
    let g:ctrlp_line_prefix='♪'
endif

" ctrlp-funky: 模糊搜索当前文件中所有函数
if (&rtp =~ 'ctrlp-funky') && isdirectory(expand("$VIM/vimfiles/bundle/ctrlp-funky"))
    nnoremap <Leader>fu :CtrlPFunky<Cr>         " 当前文件的函数列表搜索
    " .narrow the list down with a word under cursor
    nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>  " 搜索当前光标下单词对应的函数
    let g:ctrlp_funky_syntax_highlight = 1
    let g:ctrlp_extensions = ['funky']
endif

" vim-easymotion
" <Leader><Leader>w     跳转
" <Leader><Leader>f     搜索字符

" vim-mark
" 给不同的单词高亮，表明不同的变量时很有用，详细帮助见 :h mark.txt
if (&rtp =~ "vim-mark,") && isdirectory(expand("$VIM/vimfiles/bundle/vim-mark"))
    nmap <silent> <leader>hl <Plug>MarkSet                  " 光标下单词高亮
    vmap <silent> <leader>hl <Plug>MarkSet
    nmap <silent> <leader>hh <Plug>MarkClear                " 光标下单词取消高亮
    vmap <silent> <leader>hh <Plug>MarkClear
    nmap <silent> <leader>hr <Plug>MarkRegex                " 高亮正则表示式匹配的字符
    vmap <silent> <leader>hr <Plug>MarkRegex
    nmap <silent> <leader>hn <Plug>MarkSearchCurrentNext    " 下一处高亮
    nmap <silent> <leader>hp <Plug>MarkSearchCurrentPrev    " 上一处高亮
endif

" vim-multiple-cursors
" 默认配置如下，无需修改
if (&rtp =~ 'vim-multiple-cursors') && isdirectory(expand("$VIM/vimfiles/bundle/vim-multiple-cursors"))
    "let g:multi_cursor_next_key='<C-n>'
    "let g:multi_cursor_prev_key='<C-p>'
    "let g:multi_cursor_skip_key='<C-x>'
    "let g:multi_cursor_quit_key='<Esc>'
    let g:multi_cursor_exit_from_visual_mode=0
    let g:multi_cursor_exit_from_insert_mode=0
endif

" rainbow: 高亮括号与运算符等
if (&rtp =~ 'rainbow') && isdirectory(expand("$VIM/vimfiles/bundle/rainbow"))
    au! BufRead,BufNewFile,BufEnter *.{c,cpp,h,hpp,cxx,hh,cc,java,javascript} call rainbow#load()
endif

" indentLine: 用于显示对齐线
if (&rtp =~ 'indentLine') && isdirectory(expand("$VIM/vimfiles/bundle/indentLine"))
    let g:indentLine_char = "|"                 " 设置 Gvim 的对齐线样式
    let g:indentLine_first_char = "|"           " 设置 Gvim 的对齐线样式
    let g:indentLine_color_term = 239           " 设置终端对齐线颜色
    let g:indentLine_color_gui = '#A4E57E'      " 设置 GUI 对齐线颜色
endif

" tcomment: 代码注释。插件默认快捷键：
"- gcc           注释当前行，再输入则取消注释
"- gc{motion}    切换注释
"- g>{motion}    注释
"- g<{motion}    取消注释

" DoxygenToolkit: 快速生成许可、作者文件说明、函数等注释框架
if (&rtp =~ 'DoxygenToolkit') && isdirectory(expand("$VIM/vimfiles/bundle/DoxygenToolkit"))
    ".生成许可信息
    nmap <leader>dl :DoxLic<CR>
    ".生成文件头、作者信息
    nmap <leader>da :DoxAuthor<CR>
    ".生成函数/类注释
    nmap <leader>df :Dox<CR>
    ".生成块注释
    nmap <leader>db :DoxBlock<CR>
    let g:DoxygenToolkit_licenseTag = "Copyright (C) 2009 - 2020 All Rights Reserved"  "许可
    let g:DoxygenToolkit_authorName="zyd, johnsmithcry@163.com"     "作者
    " let g:DoxygenToolkit_commentType = "C++"        "注释类型。C++ 使用//
    let g:DoxygenToolkit_briefTag_funcName="no"
    let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------" 
    let g:DoxygenToolkit_blockFooter="--------------------------------------------------------------"
    let g:DoxygenToolkit_undocTag="DOXIGEN_SKIP_BLOCK"
    let g:doxygen_enhanced_color=1
endif

" delimitMate: 成对生成(),{},[]
if (&rtp =~ 'delimitMate') && isdirectory(expand("$VIM/vimfiles/bundle/delimitMate"))
    au FileType mail,vim let b:delimitMate_autoclose=0
endif

" wildfire: 快速选择文本对象
if (&rtp =~ 'wildfire') && isdirectory(expand("$VIM/vimfiles/bundle/wildfire"))
    map <leader>s <Plug>(wildfire-fuel)
    let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "i>", "ip", "it"]
endif

" tabular: 代码对齐
if (&rtp =~ 'tabular') && isdirectory(expand("$VIM/vimfiles/bundle/tabular"))
    nmap <leader><leader>= :Tabularize /=<CR>      " =对齐
    imap <leader><leader>= :Tabularize /=<CR>      " =对齐
    vmap <leader><leader>= :Tabularize /=<CR>      " =对齐
    " 自定义对齐
    nmap <leader><leader>/ :Tabularize /
    imap <leader><leader>/ :Tabularize /
    vmap <leader><leader>/ :Tabularize /
endif

" TaskList: 任务列表
if (&rtp =~ 'TaskList') && isdirectory(expand("$VIM/vimfiles/bundle/TaskList"))
    map <leader>tl <Plug>TaskList
    let g:tlWindowPosition = 1
    let g:tlTokenList = ['todo']
endif

" vim-bookmarks: 书签
"- mm   :BookmarkToggle     切换书签
"- mn   :BookmarkNext       下一个书签
"- mp   :BookmarkPrev       上一个书签
"- mi   :BookmarkAnnotate   注释书签
"- ma   :BookmarkShowAll    列出所有书签
"- mc   :BookmarkClear      清除当前 buffer 的书签
"- mx   :BookmarkClearAll   清除所有 buffer 的书签
"- mjj  :BookmarkMoveUp     书签下移
"- mkk  :BookmarkMoveDown   书签上移
if (&rtp =~ 'vim-bookmarks') && isdirectory(expand("$VIM/vimfiles/bundle/vim-bookmarks"))
    let g:bookmark_sign = '>>'
    let g:bookmark_annotation_sign = '##'
    let g:bookmark_auto_save = 0
    let g:bookmark_auto_close = 1
    let g:bookmark_highlight_lines = 1
endif

" easygrep:

" ctrlsf
if (&rtp =~ 'ctrlsf') && isdirectory(expand("$VIM/vimfiles/bundle/ctrlsf"))
    let g:ctrlsf_ackprg='ag'   " 设置ctrlsf 使用ag
endif

" fswitch: 用于 .h/.cpp 快速切换
if (&rtp =~ 'fswitch') && isdirectory(expand("$VIM/vimfiles/bundle/fswitch"))
    nnoremap <silent> <leader>sw :FSHere<cr>
    nnoremap <silent> <F11> :FSHere<cr>
endif

" c.vim
"快捷键：F9 编译链接     ALT+F9 编译        CTRL+F9 运行    SHIFT+F9 设置命令行参数
"let g:C_GlobalTemplateFile=$VIM.'/vimfiles/c-support/templates/Templates'
"let g:C_LocalTemplateFile=$VIM.'/vimfiles/c-support/templates/Templates'
"let g:C_CodeSnippets=$VIM.'/vimfiles/c-support/codesnippets/'
"let g:C_Styles = { '*.c' : 'default', '*.h,*.cpp,*.hpp,*.cxx,*.cc,*.hh' : 'CPP' }
"let g:C_TemplateOverwrittenMsg= 'no'
"let g:C_MapLeader=g:mapleader
"let g:C_CreateMenusDelayed = 'yes'              "在打开C/C++文件时加载该插件，可以加快启动速度
  
" echofunc: 显示函数原型
if (&rtp =~ 'echofunc') && isdirectory(expand("$VIM/vimfiles/bundle/echofunc"))
    let g:EchoFuncLangsUsed = ["c", "cpp", "h", "hpp", "cxx", "hh", "cc", "js"]
endif

" neocomplcache: 关键字补全、文件路径补全、tag补全等等，各种，非常好用，速度超快。
" 在弹出补全列表后用 <c-p> 或 <c-n> 进行上下选择效果比较好
if (&rtp =~ 'neocomplcache') && isdirectory(expand("$VIM/vimfiles/bundle/neocomplcache"))
    let g:neocomplcache_enable_at_startup = 1     "vim 启动时启用插件
    let g:neocomplcache_auto_completion_start_length=1
    " 补全菜单弹出时，按”-“，的每个候选词会被标上一个字母，再输入对应字母就可以马上完成选择。
    let g:neocomplcache_enable_quick_match = 1
    " let g:neocomplcache_disable_auto_complete = 1 "不自动弹出补全列表
    let g:neocomplcache_min_syntax_length = 3
endif

" YouComplete
if (&rtp =~ 'YouComplete') && isdirectory(expand("$VIM/vimfiles/bundle/YouComplete"))
    let g:ycm_min_num_of_chars_for_completion = 3 
    let g:ycm_autoclose_preview_window_after_completion=1
    let g:ycm_complete_in_comments = 1
    let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
    " 比较喜欢用tab来选择补全...
    function! MyTabFunction ()
        let line = getline('.')
        let substr = strpart(line, -1, col('.')+1)
        let substr = matchstr(substr, "[^ \t]*$")
        if strlen(substr) == 0
            return "\<tab>"
        endif
        return pumvisible() ? "\<c-n>" : "\<c-x>\<c-o>"
    endfunction

    inoremap <tab> <c-r>=MyTabFunction()<cr>
endif

" tern_for_vim
if (&rtp =~ 'tern_for_vim') && isdirectory(expand("$VIM/vimfiles/bundle/tern_for_vim"))
    let tern_show_signature_in_pum = 1
    let tern_show_argument_hints = 'on_hold'
    autocmd FileType javascript nnoremap <leader>d :TernDef<CR>
    autocmd FileType javascript setlocal omnifunc=tern#Complete
endif

" neosnippet: neosnippet 代码片段提示，使用 vim-snippets 的代码片段
" <c-n> 和 <c-p> 选择候选项，也可以使用 <tab>；<c-k>展开代码片段
if (&rtp =~ 'neosnippet') && isdirectory(expand("$VIM/vimfiles/bundle/neosnippet"))
    let g:neosnippet#disable_runtime_snippets = {'_':1}    "禁用默认代码片段 neosnippet-snippets
    let g:neosnippet#enable_snipmate_compatibility = 1
    if g:isWindows
        let g:neosnippet#snippets_directory='$VIM/vimfiles/bundle/vim_snippets/snippets'
    else
        let g:neosnippet#snippets_directory='~/.vim/bundle/vim_snippets/snippets'
    endif
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)
endif

" tagbar: C++大纲插件，相对 TagList 能更好的支持面向对象
if (&rtp =~ 'tagbar') && isdirectory(expand("$VIM/vimfiles/bundle/tagbar"))
    " 常规模式下输入 tb 调用插件，如果有打开 TagList 窗口则先将其关闭
    nmap tb :TagbarToggle<CR>
    let g:tagbar_ctags_bin='$VIMRUNTIME\..\tools\ctags.exe'
    let g:tagbar_width=30                       "设置窗口宽度
    let g:tagbar_left=0                         "在右侧窗口中显示
    let g:tagbar_autofocus=1                    "光标自动移动到打开的 tagbar 窗口
    let g:tagbar_autoshowtag=1                  "自动打开折叠并高亮tag
endif

" vimshell: shell控制台
if (&rtp =~ 'vimshell') && isdirectory(expand("$VIM/vimfiles/bundle/vimshell"))
    " let g:vimshell_execute_file_list = {}
    " call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
    " let g:vimshell_execute_file_list['rb'] = 'ruby'
    " let g:vimshell_execute_file_list['pl'] = 'perl'
    " let g:vimshell_execute_file_list['py'] = 'python'
    " let g:vimshell_execute_file_list['js'] = 'node'
    " call vimshell#set_execute_file('html,xhtml', 'gexe firefox')

    " 进入 VimShell
    function! OpenVimShell()
        set noautochdir
        :VimShellCurrentDir
        " :VimShellPop
    endfunction

    nmap <leader>vs <esc>:call OpenVimShell()<CR>
endif

" vim-surround: 智能包围。可以改变字符串的包围符号。
" 用法、以 'hello world!' 示例：
" 1. cs   当前符号 新符号：cs'<q> 变成 <q>hello world!</q>
" 2. cs   t        新符号：cst"   变成 "hello world!"
" 3. ds   当前符号       ：ds"    变成 hello world!
" 4. ysiw 新符号         ：ysiw]  变成 [hello] world!   光标需要放到 hello 单词上。
" 5. ( [ { 会加空格，) ] } 不会加空格
" 6. yss 新符号          ：yss]  整行添加方括号
" 7. repeat.vim 插件后，可以使用 . 命令重复cs, ds, yss 三个命令 

" vim-expand-region: 扩展选区
" vmap v <Plug>(expand_region_expand)
" vmap <C-v> <Plug>(expand_region_shrink)

" vim-table-mode: 表格插件
if (&rtp =~ 'vim-table-mode') && isdirectory(expand("$VIM/vimfiles/bundle/vim-table-mode"))
    " 管线表格 切换表格模式：<leader>tm     新行分隔线：||
    " 多行单元格：在单元格一行结尾添加'\'，在下一行书写该单元格的下一行
    " let g:table_mode_corner="|"       
    " 格框表格
    let g:table_mode_corner_corner="+"
    let g:table_mode_header_fillchar="="
endif

" vim-markdown
if (&rtp =~ 'vim-markdown') && isdirectory(expand("$VIM/vimfiles/bundle/vim-markdown"))
    let g:vim_markdown_frontmatter=1            " 支持yaml语法
    " let g:vim_markdown_folding_disabled=1       " 禁用自动折叠
    let g:vim_markdown_toc_autofit = 1          " 
endif

" markdown-preview
if (&rtp =~ 'markdown-preview') && isdirectory(expand("$VIM/vimfiles/bundle/markdown-preview"))
    let g:mkdp_path_to_chrome = 'd:\program\mozilla\firefox\firefox.exe'
    let g:mkdp_auto_start = 0       " 1 打开文件时自动在浏览器预览；0 不自动预览
    let g:mkdp_auto_open = 0        " 1 编辑时检查预览窗口是否打开；否则自动打开预览窗口
    let g:mkdp_auto_close = 1       " 1 切换 buffer 时自动关闭预览窗口；0 不关闭预览窗口
    let g:mkdp_refresh_slow = 1     " 1 只在保存、插入模式时更新预览；0 实时更新预览
endif

" vim-pandoc-syntax
if (&rtp =~ 'vim-pandoc-syntax') && isdirectory(expand("$VIM/vimfiles/bundle/vim-pandoc-syntax"))
    let g:pandoc#syntax#conceal#use = 0
    " <Leader>f    Insert new footnote 
    " <Leader>r    Return from footnote
endif

" syntastic
if (&rtp =~ 'syntastic') && isdirectory(expand("$VIM/vimfiles/bundle/syntastic"))
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_check_on_wq = 0

    " 默认保存文件时自动检查，手动执行语法检查：SyntasticChecke slint
    " js 语法检查：ESLint：sudo npm install eslint -g
    " jshint
    let g:syntastic_javascript_checkers = ['eslint', 'jshint']
endif

" vim-cpp-enhanced-highlight
if (&rtp =~ 'vim-cpp-enhanced-highlight') && isdirectory(expand("$VIM/vimfiles/bundle/vim-cpp-enhanced-highlight"))
    let g:cpp_class_scope_highlight = 1
    " let g:cpp_experimental_simple_template_highlight = 1
    let g:cpp_experimental_template_highlight = 1
    let g:cpp_concepts_highlight = 1
endif

" emmet
if (&rtp =~ "emmet") && isdirectory(expand("$VIM/vimfiles/bundle/emmet"))
    " 基本规则:
    "   E 代表HTML标签
    "   E#id 代表标签E有id属性
    "   E.class 代表E有class属性
    "   E[attr=foo] 代表某个特定属性
    "   E{info} 代表标签E包含的内容是info
    "   文本{}：E{info} 表示E包含的内容是 info。<E>info</E>
    "   后代> ：E>N 代表N是E的子元素。<E><N></N></E>
    "   兄弟+ ：E+N 代表N是E的同级兄弟元素。<E></E><N></N>
    "   上级^ ：X>E^N 代表N是E的上级元素。<X><E></E></X><N></N>
    "   分组()：X>(E>F*2)+G>P。<X><E><F></F><F></F></E> <G><P></P></G> </X>
    "   重复* ：E*5 生成5个元素E
    "   编号$ ：ul>li.item$*5 表示有5个li元素，class名为[item1,item5]
    " 下面是一些常用快捷键：
    "   <c-y>, 展开简写式
    "   <c-y>d Balance a Tag Inward(选中包围的标签?)
    "   <c-y>D Balance a Tag Outward
    "   <c-y>n 进入下个编辑点
    "   <c-y>N 进入上个编辑点
    "   <c-y>i 移动到img标签，按快捷键，自动为图片添加大小
    "   <c-y>m 合并文本行
    "   <c-y>k 删除标签
    "   <c-y>j 分解/展开空标签
    "   <c-y>/ 注释开关
    "   <c-y>a 从URL生成anchor标签
    "   <c-y>A 从URL生成引用文本
    " 只对 HTML/CSS 启用
    let g:user_emmet_install_global = 0
    autocmd FileType htm,html,css EmmetInstall
    " 设置启用模式：'i' 插入模式， 'n' 正常模式，'v' 可视模式， 'a' 所有模式
    let g:user_emmet_mode='in'
    " 修改Emmet的触发键
    " let g:user_emmet_leader_key='<C-J>'
endif

"  vim-airline and colortheme
if (&rtp =~ "vim-airline") && isdirectory(expand("$VIM/vimfiles/bundle/vim-airline"))
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '   "tabline中未激活buffer两端的分隔字符
    let g:airline#extensions#tabline#left_alt_sep = '|'      "tabline中buffer显示编号
    let g:airline#extensions#tabline#buffer_nr_show = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail'				" 标签页显示样式
    let g:airline_section_c = airline#section#create(['%t', 'readonly'])	" 状态栏仅显示文件名

    " let g:airline_left_sep='>'
    " let g:airline_right_sep='<'
    " let g:airline_detect_modified=1
    " let g:airline_detect_paste=1
    " let g:airline_detect_crypt=1
    " let g:airline_detect_spell=1
    " let g:airline_detect_spelllang=1
    " let g:airline_detect_iminsert=0
    " let g:airline_inactive_collapse=1
    " let g:airline_inactive_alt_sep=1
    let g:airline_theme='dark'
    " 关闭状态显示空白符号计数"
    let g:airline#extensions#whitespace#enabled = 0
    let g:airline#extensions#whitespace#symbol = '!'
    "设置切换Buffer快捷键"
    nnoremap <C-Tab> :bn<CR>
    nnoremap <C-S-Tab> :bp<CR>
    " 映射<leader>num到num buffer
	map <leader>1 :b 1<CR>
	map <leader>2 :b 2<CR>
	map <leader>3 :b 3<CR>
	map <leader>4 :b 4<CR>
	map <leader>5 :b 5<CR>
	map <leader>6 :b 6<CR>
	map <leader>7 :b 7<CR>
	map <leader>8 :b 8<CR>
	map <leader>9 :b 9<CR>
endif
