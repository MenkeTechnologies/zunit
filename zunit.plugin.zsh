builtin cd "${0:h}"

if [[ ! -f bin/zunit ]]; then
    # Clear the file to start with
    if [[ ! -d bin ]]; then
        command mkdir bin
    fi
    cat /dev/null > bin/zunit

    # Start with the shebang
    echo "#!/usr/bin/env zsh\n" >> bin/zunit

    # We need to do some fancy globbing
    setopt EXTENDED_GLOB

    # Print each of the source files into the target, removing any comments
    # and blank lines from the compiled executable
    cat src/**/(^zunit).zsh | grep -v -E '^(\s*#.*[^"]|\s*)$' >> bin/zunit

    # Print the main command last
    cat src/zunit.zsh | grep -v -E '^(\s*#.*[^"]|\s*)$' >> bin/zunit

    # Make sure the file is executable
    chmod u+x bin/zunit

    # Let the user know we're finished
    echo "\033[0;32m✔\033[0;m ZUnit built successfully"
        
fi

path=("${0:h}/bin" $path)
fpath=("${0:h}/src_comp" $fpath)

builtin cd -
