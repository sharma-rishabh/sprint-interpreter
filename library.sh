#  set -x

ADD=1
JUMP_LT=2
STOP=99

ERROR_ARRAY=( "No Error" "Addition : Array location you're trying to access is not intialized." "Jump_lt : Array location you're trying to access is not intialized." "Jump_lt : Cannot jump to the requested location as it is not initialized." )

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
        return 1
    fi


    local sum=$(( $first_number + $second_number ))
    local storing_location=${sprint_program[${third_index}]}
    local sprint_program[${storing_location}]=$sum
    
    echo "${sprint_program[@]}"
}

function jump_lt() {
    local sprint_program=($1)
    local current_index=$2
    
    local first_index=$(( $current_index + 1 ))
    local second_index=$(( $current_index + 2 ))
    local third_index=$(( $current_index + 3 ))
    
    local first_number=${sprint_program[${sprint_program[$first_index]}]}
    local second_number=${sprint_program[${sprint_program[$second_index]}]}

    if [[ -z "$first_number"  ]] || [[ -z "$second_number"  ]]
    then
        return 2
    fi
    
    current_index=$(( ${current_index} + 3 ))
    if [[ ${first_number} -lt ${second_number} ]]
    then
        current_index=${sprint_program[$third_index]}
    fi

    if [[ -z ${sprint_program[$current_index]} ]]
    then
        return 3
    fi
    
    echo $current_index
}

function error_handler () {
    local error_status=$1
    echo ${ERROR_ARRAY[$error_status]}
}


function interpreter () {
    local sprint_program=($1)
    local index=0
    while [[ ${sprint_program[$index]} -ne $STOP ]] && [[ -z ${sprint_program[$index]} ]]
    do
        if [[ ${sprint_program[$index]} -eq $ADD ]]
        then
            sprint_program=($( addition "`echo ${sprint_program[@]}`" "$index" ))
            addition_status=$?
            
            if [[ ${addition_status} -ne 0 ]]
            then
                return ${addition_status}
            fi
            
            index=$(( ${index} + 3 ))
            continue
        fi

        if [[ ${sprint_program[$index]} -eq $JUMP_LT ]]
        then
            index=$( jump_lt "`echo ${sprint_program[@]}`" "$index" )
            jump_lt_status=$?
            
            if [[ ${jump_lt_status} -ne 0 ]]
            then
                return ${jump_lt_status}
            fi
            continue
        fi
        
        echo ${sprint_program[@]}
        index=$(( $index + 1 ))
    done
}

function main () {
    local sprint_program="$1"
    
    interpreter "${sprint_program}"
    interpreter_status=$?
    
    if [[ $interpreter_status -ne 0 ]]
    then
        error_handler $interpreter_status
        exit 1
    fi
}