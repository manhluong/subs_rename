#!/bin/bash

function create_scenario {
    sub_folder="$2"
    scenario_number="$3"
    root_folder="$1_${scenario_number}"
    sub_folder="${root_folder}/${sub_folder}_${scenario_number}"

    cmd="mkdir $root_folder"
    echo "Command: ${cmd}"
    eval "$cmd"
    cmd="mkdir $sub_folder"
    echo "Command: ${cmd}"
    eval "$cmd"

    sub_sub_folders_base_name="$4"
    sub_sub_folders_number="$5"
    file_extension="$6"
    shift 6
    language_names=("$@")

    for ((c = 1; c <= $sub_sub_folders_number; c++)); do
        new_sub_sub_folder="${sub_folder}/${sub_sub_folders_base_name}_$c"
        cmd="mkdir $new_sub_sub_folder"
        echo "Command: ${cmd}"
        eval "$cmd"
        for m in "${language_names[@]}"; do
            new_file_language="${new_sub_sub_folder}/${m}.${file_extension}"
            cmd="touch $new_file_language"
            echo "Command: ${cmd}"
            eval "$cmd"
        done
    done
}

# Common test scenarios variables
test_root_folder="test_scenario"
test_sub_folder="test_scenario_sub"
test_sub_sub_folders_base_name="ep_mov"
test_file_extension="srt"

# Variables per scenario
test_scenario_number=1
test_sub_sub_folders_number=8
test_language_names=("1_English" "12_English" "3_Italian" "4_French" "20_Spanish" "7_German")

create_scenario "$test_root_folder" "$test_sub_folder" "$test_scenario_number" "$test_sub_sub_folders_base_name" "$test_sub_sub_folders_number" "$test_file_extension" "${test_language_names[@]}"

test_scenario_number=2
test_sub_sub_folders_number=3
test_language_names=("1_English" "12_English" "30_Italian" "25_Italian" "20_Chinese" "7_Korean")

create_scenario "$test_root_folder" "$test_sub_folder" "$test_scenario_number" "$test_sub_sub_folders_base_name" "$test_sub_sub_folders_number" "$test_file_extension" "${test_language_names[@]}"
