#  set -x

function addition () {
    local sprint_program=($1)
    local current_index=$2
    
    local first_index=$(( ${current_index} + 1 ))
    local second_index=$(( ${current_index} + 2 ))
    local third_index=$(( ${current_index} + 3 ))
    
    local first_number=${sprint_program[${sprint_program[$first_index]}]}
    local second_number=${sprint_program[${sprint_program[$second_index]}]}
    
    if [[ -z "$first_number"  ]] || [[ -z "$second_number"  ]]
    then
        echo "Addition : Array location you're trying to access was not intialized."
        return 1
    fi


    local sum=$(( $first_number + $second_number ))
    local storing_location=${sprint_program[${third_index}]}
    local sprint_program[${storing_location}]=$sum
    
    echo "${sprint_program[@]}"
}

function interpreter () {
    local sprint_program=($1)
    local index=0
    while [[ ${sprint_program[$index]} -ne 99 ]] && [[ ${sprint_program[$index]} -ne "" ]]
    do
        if [[ ${sprint_program[$index]} -eq 1 ]]
        then
            sprint_program=($( addition "`echo ${sprint_program[@]}`" "$index" ))
            addition_status=$?
            if [[ ${addition_status} -eq 1 ]]
            then
                echo ${sprint_program[@]}
                return 1
            fi
            index=$(( ${index} + 2 ))
        fi
        if [[ ${sprint_program[$index]} -eq 2 ]]
        then
            local first_index=$(( $index + 1 ))
            local second_index=$(( $index + 2 ))
            local third_index=$(( $index + 3 ))
            local first_number=${sprint_program[${sprint_program[$first_index]}]}
            local second_number=${sprint_program[${sprint_program[$second_index]}]}
            index=$(( ${index} + 3 ))
            if [[ ${first_number} -lt ${second_number} ]]
            then
                index=${sprint_program[$third_index]}
            fi
            continue
        fi
        echo ${sprint_program[@]}
        index=$(( $index + 1 ))
    done
}

function main () {
    local sprint_program="$1"
    # if [[ -z ${sprint_program} ]]
    # then
    #     echo "Code string is empty"
    #     exit
    # fi
    interpreter "${sprint_program}"
    interpreter_status=$?
    if [[ $interpreter_status -eq 1 ]]
    then
        exit 1
    fi
}