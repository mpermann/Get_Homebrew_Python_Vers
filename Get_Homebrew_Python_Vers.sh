#!/bin/zsh
# Extension Attribute to detect Homebrew versions of python3

function find_python_vers () {
    # Determine all Python paths
    pythonPathsArray=()
    while IFS='' read -rA dirs; do pythonPathsArray+=("$dirs"); done < <(/usr/bin/find "$PATH" -name python3 | /usr/bin/grep -v Frameworks) # find python3 executable starting in specific path based on architecture

    # Exit if we didn't find any paths
    if [[ ${#pythonPathsArray[@]} -eq 0 ]]
    then
        echo "<result></result>"
        exit 0
    else
        for path in "${pythonPathsArray[@]}"
        do
            versions+=$($path --version | /usr/bin/awk '{ print $2 }')"," # builds list of versions separated by commas
        done
    fi
    versions=${versions:0:-1} # removes trailing comma from list of versions
    echo "<result>$versions</result>"
}

arch_name="$(uname -m)"
 
if [ "${arch_name}" = "x86_64" ] # check if computer is x86_64 architecture
then
    # x86_64 architecture found set path to Intel architecture specific path
    PATH="/usr/local/Cellar"
    find_python_vers
else
    # arm64 architecture found set path to Arm64 architecture specific path
    PATH="/opt/homebrew/Cellar"
    find_python_vers
fi
