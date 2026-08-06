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
