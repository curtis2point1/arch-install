#!/bin/bash
main() {

	current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	source "$current_dir/utilities.sh"

	local files_to_remove=(
	  "$HOME/Work/.mise.toml"
	)

	local directories_to_remove=(
	  "$HOME"/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos,Work}
	)

	local directories_to_add=(
  	  "$HOME"/{desktop,downloads,pictures,sync,vaults}
      "$HOME"/dev/{curtis,datm,ripe,two-point-one}
      "$HOME"/.local/bin
	)

	remove_files "${files_to_remove[@]}"
	remove_directories "${files_to_remove[@]}"
	add_directories "${directories_to_add[@]}"

	echo "Directory setup complete!"
}

main "$@"
