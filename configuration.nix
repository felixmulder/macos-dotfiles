{ config, pkgs, ... }:

{
  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "bottom";
  system.defaults.dock.show-recents = false;
  system.defaults.dock.showhidden = true;

  system.defaults.finder.AppleShowAllExtensions = true;

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadRightClick = true;

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;


  environment.systemPackages =
    [
      config.programs.vim.package

      pkgs.bat
      pkgs.gist
      pkgs.hunspell
      pkgs.iterm2
      pkgs.jq
      pkgs.nodejs
    ];

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse          = "autoraise";
      mouse_follows_focus          = "off";
      window_placement             = "second_child";
      window_opacity               = "off";
      window_opacity_duration      = "0.0";
      window_border                = "off";
      window_border_placement      = "inset";
      window_border_width          = 2;
      window_border_radius         = 3;
      active_window_border_topmost = "off";
      window_topmost               = "on";
      window_shadow                = "float";
      active_window_border_color   = "0xff5c7e81";
      normal_window_border_color   = "0xff505050";
      insert_window_border_color   = "0xffd75f5f";
      active_window_opacity        = "1.0";
      normal_window_opacity        = "1.0";
      split_ratio                  = "0.50";
      auto_balance                 = "on";
      mouse_modifier               = "fn";
      mouse_action1                = "move";
      mouse_action2                = "resize";
      layout                       = "bsp";
      top_padding                  = 5;
      bottom_padding               = 5;
      left_padding                 = 5;
      right_padding                = 5;
      window_gap                   = 5;
    };
    extraConfig = ''
      # rules
      yabai -m rule --add app='System Preferences' manage=off

      # Set up spaces
      yabai -m space 1 --label main
      yabai -m space 2 --label term
      yabai -m space 3 --label misc
      yabai -m space 4 --label chat
      yabai -m space --focus main
    '';
  };

  services.skhd = {
    enable = true;

    skhdConfig = ''
      # Open terminal
      shift + alt - return : open -a iTerm --new

      # Space focus
      alt - left : yabai -m space --focus prev
      alt - right : yabai -m space --focus next
      alt - 1 : yabai -m space --focus 1
      alt - 2 : yabai -m space --focus 2
      alt - 3 : yabai -m space --focus 3
      alt - 4 : yabai -m space --focus 4

      # navigate windows on space
      alt - h : yabai -m window --focus west
      alt - j : yabai -m window --focus next
      alt - k : yabai -m window --focus prev
      alt - l : yabai -m window --focus east

      # Move window to different space
      shift + alt - 1 : yabai -m window --space 1
      shift + alt - 2 : yabai -m window --space 2
      shift + alt - 3 : yabai -m window --space 3
      shift + alt - 4 : yabai -m window --space 4

      # Move window to different space and follow
      shift + cmd + alt - 1 : yabai -m window --space 1 && \
                              yabai -m space --focus 1
      shift + cmd + alt - 2 : yabai -m window --space 2 && \
                              yabai -m space --focus 2
      shift + cmd + alt - 3 : yabai -m window --space 3 && \
                              yabai -m space --focus 3
      shift + cmd + alt - 4 : yabai -m window --space 4 && \
                              yabai -m space --focus 4
    '';
  };

  environment.darwinConfig = "$HOME/.src/macos-dotfiles/configuration.nix";

  # Configure vim to use neovim with custom config
  programs.vim.package = pkgs.neovim.override {
    configure =
      let
        extraPlugins = {
          space-vim-dark = pkgs.vimUtils.buildVimPlugin {
            pname = "space-vim-dark";
            version = "2020-08-21";
            src = pkgs.fetchFromGitHub {
              owner = "liuchengxu";
              repo = "space-vim-dark";
              rev = "d24c6c27b49c1ab49416a47d96979481281f53b5";
              sha256 = "18a9r82i1zd7db94m3lh2vybs2p67s1c9p4yq40r355pfdkadda1";
            };
           meta.homepage = "https://github.com/liuchengxu/space-vim-dark/";
          };
        };
      in {
        packages.darwin.start = with pkgs.vimPlugins; [
          # General plugins
          unite-vim
          vim-trailing-whitespace
          vim-easy-align
          nerdcommenter
          vimfiler-vim
          ctrlp-vim
          vim-gitgutter
          vim-fugitive

          # Deoplete emoji?

          # Themes
          vim-airline
          vim-airline-themes
          vim-devicons

          extraPlugins.space-vim-dark

          # Syntax plugins
          coc-css
          coc-highlight
          coc-html
          coc-java
          coc-json
          coc-nvim
          coc-solargraph
          coc-yaml

          vim-pug
          rust-vim
          vim-scala
          vim-ruby
          typescript-vim
          purescript-vim
          elm-vim
          vim-nix
        ];
        customRC = ''
          set nocompatible
          filetype off

          " LSP {
              set hidden " for operations modifying multiple buffers (e.g. rename)

              "let g:LanguageClient_serverCommands = {
              "    \ 'scala': ['dottyLanguageServer']
              "    \ }
              "nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
              "nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
              "nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
          " }

          " coc.nvim {
              " Use tab to cycle suggestions
              inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
              inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
              inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
          " }

          " Special symbols {
              inoremap lda λ
          " }

          " Enable true colors
          set termguicolors

          " Theming
          syntax enable

          " Color scheme settings {
              colorscheme space-vim-dark
              hi Comment    cterm=italic
              hi Comment    guifg=11 ctermfg=59
              "hi Comment guifg=#5C6370 ctermfg=59
              hi Normal     ctermbg=NONE guibg=NONE
              hi LineNr     ctermbg=NONE guibg=NONE
              hi SignColumn ctermbg=NONE guibg=NONE
              hi Search     ctermbg=8 ctermfg=11 guifg=NONE guibg=NONE
              hi IncSearch  ctermbg=8 ctermfg=11 guifg=NONE guibg=NONE
              "hi Visual term=reverse cterm=reverse guibg=White
          " }

          filetype plugin indent on

          " Highlight current line
          set cursorline

          " Airline commands {
              set laststatus=2
              let g:airline_powerline_fonts = 1
              "let g:airline_theme='luna'
              "let g:airline_theme='oceanicnext'
              "let g:airline_theme='one'
              "let g:airline_theme='solarized'
              let g:airline_theme='base16_spacemacs'
              let g:airline#extensions#tabline#enabled = 1
          " }

          " Focus mode {
              let g:focus_use_default_mapping = 0
              nnoremap <space>c <Plug>FocusModeToggle
          " }

          set number
          set autoindent
          set cindent
          set ruler
          set ignorecase
          set showmatch
          set incsearch

          " Clipboard {
              set mouse+=a
              set clipboard=unnamed
              " clipboard sharing Linux:
              "vnoremap <C-c> "+y
          " }

          " Smart ctags, i.e. search up
          set tags=tags;/

          " Vimfiler {
              let g:vimfiler_as_default_explorer = 1
              let g:vimfiler_safe_mode_by_default = 0
              let g:vimfiler_tree_leaf_icon = ' '
              let g:vimfiler_tree_opened_icon = '▾'
              let g:vimfiler_tree_closed_icon = '▸'
              let g:vimfiler_file_icon = '-'
              let g:vimfiler_readonly_file_icon = '✗'
              let g:vimfiler_marked_file_icon = '✓'
              nnoremap <space>f :VimFiler -toggle<CR>
          " }

          " Ctrlp {
              nnoremap <space><space> :CtrlP .<CR>
              nnoremap <space>b :CtrlPBuffer<CR>

              let g:ctrlp_custom_ignore = {
                \ 'dir':  '\v[\/](_site|dist-newstyle|dist|output|target|bower_components|node_modules|target-0.9.5|\.(git|hg|svn))$',
                \ 'file': '\v\.(swp|so|o|out|bbl|blg|aux|log|toc|jar|class)$',
                \ }
          " }

          " remap ¤ to end of line
          nnoremap ¤ <End>

          " macOS settings {
              nnoremap € <End>
              set backspace=indent,eol,start
              set list
              set listchars=nbsp:¬
          " }

          " Clear highlighting on escape in normal mode {
              set hlsearch
              nnoremap <esc> :noh<return><esc>
              nnoremap <esc>^[ <esc>^[
          " }

          " fix whitespaec marking at end of file
          let g:extra_whitespace_ignored_filetypes = ['unite']

          " EasyAlign stuff {
              " From visual mode, select portion to align, press enter then space
              vnoremap <silent> <Enter> :EasyAlign<cr>
          " }

          " Rebind leader key
          let mapleader = ","

          " Buffered tab bindings {
              nnoremap th  :tabfirst<CR>
              nnoremap tj  :tabnext<CR>
              nnoremap tk  :tabprev<CR>
              nnoremap tl  :tablast<CR>
              nnoremap tt  :tabedit<Space>
              nnoremap tn  :tabnew<CR>
              nnoremap tm  :tabm<Space>
              nnoremap td  :tabclose<CR>
          " }

          " Normalnavigation on wrapped lines {
              map j gj
              map k gk
          " }

          " Set tab rules {
              set smarttab
              set tabstop=2
              set shiftwidth=2
              set expandtab
          " }

          " Scala {
              " Set scala-docstrings
              " let g:scala_scaladoc_indent = 1
          " }

          " Highlight characters that go over X columns {
              highlight OverLength ctermbg=red ctermfg=white guibg=#592929
              autocmd BufNewFile,BufRead *.* match OverLength /\%81v.\+/
              autocmd BufNewFile,BufRead *.scala match OverLength /\%121v.\+/
              autocmd BufNewFile,BufRead *.html  match OverLength /\%251v.\+/
              autocmd BufNewFile,BufRead *.js  match OverLength /\%251v.\+/
          " }

          " Braces {
              inoremap {<CR> {<CR>}<Esc>ko
          " }

          " Move lines with C-j/k {
              nnoremap <C-j> :m .+1<CR>==
              nnoremap <C-k> :m .-2<CR>==
              inoremap <C-j> <Esc>:m .+1<CR>==gi
              inoremap <C-k> <Esc>:m .-2<CR>==gi
              vnoremap <C-j> :m '>+1<CR>gv=gv
              vnoremap <C-k> :m '<-2<CR>gv=gv
          " }

          " Enable markdown syntax in md files {
              au BufRead,BufNewFile *.md set filetype=markdown
          " }

          " Remove scroll functionality {
              nmap <ScrollWheelUp> <nop>
              inoremap <ScrollWheelUp> <nop>
              nmap <ScrollWheelDown> <nop>
              inoremap <ScrollWheelDown> <nop>
          " }

          let s:hidden_all = 0
          function! ToggleHiddenAll()
              if s:hidden_all  == 0
                  let s:hidden_all = 1
                  set noshowmode
                  set noruler
                  set laststatus=0
                  set nonumber
                  :AirlineToggle
              else
                  let s:hidden_all = 0
                  set showmode
                  set ruler
                  set laststatus=2
                  set number
                  :AirlineToggle
              endif
          endfunction
        '';
      };
  };

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
