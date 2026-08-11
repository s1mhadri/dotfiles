# Creates a project idea directory, populates 000-braindump.md, and moves into it
newidea() {
  if [ -z "$1" ]; then
    echo "Error: Please provide a project name."
    echo "Usage: newidea <project-name>"
    return 1
  fi

  local date_prefix=$(date +%Y%m%d)
  local project_dir="$HOME/Documents/personal/project-ideas"
  local target_dir="$project_dir/${date_prefix}-$1"

  if [ -d "$target_dir" ]; then
    echo "Warning: Directory '$target_dir' already exists."
    cd "$target_dir" || return 1
    return 0
  fi

  mkdir -p "$target_dir" &&
    touch "$target_dir/000-braindump.md" &&
    {
      echo "Created: $target_dir/000-braindump.md"
      cd "$target_dir" || return 1
    }
}

# Brain Dump: append timestamped notes to a markdown file
#bd () {
#  # Help flag check
#  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
#    cat << 'EOF' | command less -R
#NAME
#    bd - Brain Dump: append timestamped notes to a markdown file
#
#SYNOPSIS
#    bd [TEXT...]
#    bd [-h | --help]
#
#DESCRIPTION
#    Appends thoughts, quick notes, or reminders to ~/personal/thoughts.md. 
#    Each entry is formatted with a Markdown level-1 header containing 
#    the current date and time.
#
#OPERANDS
#    TEXT...
#        The text to append. If multiple arguments are passed, they are joined 
#        with spaces. If no arguments are provided, multi-line mode is used.
#
#MULTI-LINE MODE
#    When run with no arguments, bd prompts for input from STDIN. Type or 
#    paste your text and press Ctrl+D on a new line to save.
#
#FILES
#    ~/personal/braindump.md
#        The target file where all thoughts are recorded.
#
#EXAMPLES
#    bd Buy groceries on the way home
#        Appends "Buy groceries on the way home" under a new timestamp header.
#
#    bd
#        Opens multi-line mode for longer notes.
#EOF
#    return 0
#  fi
#
#  local dir="$HOME/personal"
#  local file="$dir/braindump.md"
#  mkdir -p "$dir"
#
#  local text
#  if [ $# -eq 0 ]; then
#    echo "Enter your thoughts (press Ctrl+D when done):"
#    text=$(cat)
#  else
#    text="$*"
#  fi
#
#  {
#    echo ""
#    echo "# $(date '+%Y-%m-%d %H:%M:%S')"
#    echo "$text"
#  } >> "$file"
#
#  echo "Saved to $file"
#}
