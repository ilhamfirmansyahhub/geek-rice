# Ryoku palette for fish and fzf. Rendered by the theme daemon; do not edit.
#
# Dropped straight into conf.d, which fish sources on its own, so nothing in the
# shipped config has to include it. Your ~/.config/fish/user.fish loads last and
# still wins.

# Syntax highlighting.
set -g fish_color_normal A6B5B1
set -g fish_color_command 1E9177
set -g fish_color_keyword 26A589
set -g fish_color_quote 167A63
set -g fish_color_redirection 99A8A4
set -g fish_color_end 26A589
set -g fish_color_error 933636
set -g fish_color_param A6B5B1
set -g fish_color_comment 1B6352
set -g fish_color_selection --background=0F251F
set -g fish_color_operator 26A589
set -g fish_color_escape 167A63
set -g fish_color_autosuggestion 1B6352
set -g fish_color_cancel 933636
set -g fish_color_search_match --background=0F251F
set -g fish_color_valid_path --underline

# Completion pager.
set -g fish_pager_color_progress 99A8A4
set -g fish_pager_color_prefix 1E9177
set -g fish_pager_color_completion A6B5B1
set -g fish_pager_color_description 1B6352
set -g fish_pager_color_selected_background --background=0F251F

# fzf takes the same palette, so Ctrl-R and Ctrl-T match the terminal they open
# in. Appended to whatever options are already set rather than replacing them.
set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
--color=fg:#A6B5B1,bg:-1,hl:#1E9177 \
--color=fg+:#A6B5B1,bg+:#0F251F,hl+:#1E9177 \
--color=info:#167A63,prompt:#1E9177,pointer:#26A589 \
--color=marker:#26A589,spinner:#167A63,header:#1B6352 \
--color=border:#123c32"
