if status is-interactive
    # Commands to run in interactive sessions can go here
    # Enable color output
set -U fish_color_autosuggestion '555'  'brblack'
set -U fish_color_cancel -r
set -U fish_color_command blue
set -U fish_color_comment red
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_end green
set -U fish_color_error brred
set -U fish_color_escape brcyan
set -U fish_color_history_current --bold
set -U fish_color_host normal
set -U fish_color_match --background=brblue
set -U fish_color_normal normal
set -U fish_color_operator cyan
set -U fish_color_param cyan
set -U fish_color_quote yellow
set -U fish_color_redirection cyan
set -U fish_color_search_match 'bryellow'  '--background=brblack'
set -U fish_color_selection 'white'  '--bold'  '--background=brblack'
set -U fish_color_status red
set -U fish_color_user brgreen
set -U fish_color_valid_path --underline

# Use better ls colors
set -Ux LSCOLORS gxfxbEaEBxxEhEhBaDaCaD`
end
