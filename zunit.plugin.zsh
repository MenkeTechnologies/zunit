0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

zunit_plugin_dir="${0:h}"

if [[ ! -f $zunit_plugin_dir/bin/zunit ]]; then
    # Clear the file to start with
    if [[ ! -d bin ]]; then
        command mkdir $zunit_plugin_dir/bin \
        > /dev/null 2>&1
    fi
    cat /dev/null > $zunit_plugin_dir/bin/zunit

    # Start with the shebang
    echo "#!/usr/bin/env zsh\n" >> $zunit_plugin_dir/bin/zunit

    # We need to do some fancy globbing
    setopt EXTENDED_GLOB

    # Print each of the source files into the target, removing any comments
    # and blank lines from the compiled executable
    cat $zunit_plugin_dir/src/**/(^zunit).zsh | grep -v -E '^(\s*#.*[^"]|\s*)$' >> $zunit_plugin_dir/bin/zunit

    # Print the main command last
    cat $zunit_plugin_dir/src/zunit.zsh | grep -v -E '^(\s*#.*[^"]|\s*)$' >> $zunit_plugin_dir/bin/zunit

    # Make sure the file is executable
    chmod u+x $zunit_plugin_dir/bin/zunit

    # Let the user know we're finished
    echo "\033[0;32m✔\033[0;m ZUnit built successfully"

fi

unset zunit_plugin_dir

path=("${0:h}/bin" $path)
fpath=("${0:h}/src_comp" $fpath)
