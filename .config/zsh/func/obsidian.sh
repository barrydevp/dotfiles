nn() {
	if [[ -z $OBSIDIAN_VAULT_PATH ]]; then
		echo "OBSIDIAN_VAULT_PATH is not set."
	else
		cd $OBSIDIAN_VAULT_PATH
		OBSIDIAN_NOTE_DAILY="notes/daily/$(date '+%Y/%m-%B/%Y-%m-%d-%A').md"

		if test -f $OBSIDIAN_NOTE_DAILY; then
			nvim $OBSIDIAN_NOTE_DAILY
		else
			echo "No daily note found, creating a new one in Obsidian App first."
		fi
	fi
}
