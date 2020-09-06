0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

plugin_dir="${0:h}"

if [[ ! -f $plugin_dir/bin/zunit ]]; then
    # Clear the file to start with
    if [[ ! -d bin ]]; then
        command mkdir $plugin_dir/bin \
        > /dev/null 2>&1
    fi
    cat /dev/null > $plugin_dir/bin/zunit

    # Start with the shebang
    echo "#!/usr/bin/env zsh\n" >> $plugin_dir/bin/zunit

    # We need to do some fancy globbing
    setopt EXTENDED_GLOB

    # Print each of the source files into the target, removing any comments
    # and blank lines from the compiled executable
    cat $plugin_dir/src/**/(^zunit).zsh | grep -v -E '^(\s*#.*[^"]|\s*)$' >> $plugin_dir/bin/zunit

    # Print the main command last
    cat $plugin_dir/src/zunit.zsh | grep -v -E '^(\s*#.*[^"]|\s*)$' >> bin/zunit

    # Make sure the file is executable
    chmod u+x $plugin_dir/bin/zunit

    # Let the user know we're finished
    echo "\033[0;32m✔\033[0;m ZUnit built successfully"

fi

path=("${0:h}/bin" $path)
fpath=("${0:h}/src_comp" $fpath)
