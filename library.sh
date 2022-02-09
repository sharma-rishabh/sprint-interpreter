
function addition () {
    local program=($1)
    local current_index=$2
    
    local first_index=$(( ${current_index} + 1 ))
    local second_index=$(( ${current_index} + 2 ))
    local third_index=$(( ${current_index} + 3 ))
    
    local first_number=${program[$first_index]}
    local second_number=${program[$second_index]}
    
    local sum=$(( $first_number + $second_number ))
    local storing_location=${program[${third_index}]}
    local program[${storing_location}]=$sum
    
    echo "${program[@]}"
}

function interpreter () {
    local program=($1)
    local index=0
    while [[ ${program[$index]} -ne 99 ]] && [[ ${program[$index]} -ne "" ]]
    do
        if [[ ${program[$index]} -eq 1 ]]
        then
            program=($( addition "`echo ${program[@]}`" "$index" ))
            index=$(( ${index} + 2 ))
        fi
        
        index=$(( $index + 1 ))
    done
    echo ${program[@]}
}

function main () {
    local program="$1"
    # if [[ -z ${program} ]]
    # then
    #     echo "Code string is empty"
    #     exit
    # fi
    interpreter "${program}"
}

main "$1"