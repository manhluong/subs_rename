#!/bin/bash

starting_directory_flag=0
starting_directory_arg=0
file_ext_flag=0
file_ext_arg=0
language_codes_flag=0
language_codes_arg=0
default_language_code_flag=0
default_language_code_arg=0
default_folder_levels_flag=0
default_folder_levels_arg=0

files_created_list=""
files_skipped_list=""

print_help() {
    echo 'Parameters and flags:'
    echo '   [Mandatory] -s Starting directory - Ex.: /absolute-path/dir/another_dir'
    echo '   [Mandatory] -t File extension / type - Ex.: srt'
    echo '   [Mandatory] -c Language codes - Ex.: "Italian-it italian-it English-en english-en French-fr french-fr"'
    echo '   [Mandatory] -d Default language code - Ex.: "en"'
    echo '   [Mandatory] -l Folder levels to move the new file to - "1" or "2"'
}

print_help_exit() {
    print_help
    exit 1
}

get_files_by_ext() {
    starting_directory="$1"
    file_type="$2"
    cmd="find $starting_directory -name '*.$file_type' -type f"
    echo >&2 "Command: ${cmd}"
    files_list=$(eval "$cmd")
    echo >&2 "[\nFiles:\n${files_list}\n]"
    retval=${files_list}
    echo "$retval"
}

rename_files_to_dir() {
    files_list="$@"
    for single_file in $files_list; do
        directory_name=$(basename ${single_file%/*})
        echo "Directory: $directory_name"
        file_name_with_ext="$(basename -- $single_file)"
        file_name=$(echo ${file_name_with_ext} | grep -o '^[^\.]*')
        echo "File name: $file_name"
        language_code=$(file_name_to_language_code "$file_name")
        echo "Language code: $language_code"

        if [[ -z "$language_code" ]]; then
            echo "No language code found. Skipping $single_file"
            files_skipped_list="${files_skipped_list}$single_file\n"
            continue
        fi

        directory_name_new_file=${single_file%/*/*}
        basename_new_file="$(basename $directory_name_new_file)"
        if [[ $default_folder_levels_arg -eq 2 ]]; then
            directory_name_new_file=${single_file%/*/*/*}
            basename_new_file="$(basename $directory_name)"
        fi
        file_renamed=""
        default_created=0

        # Check default language.
        if [[ $language_code == $default_language_code_arg ]]; then
            file_renamed_default="${directory_name_new_file}/${basename_new_file}.default.${language_code}.${file_ext_arg}"
            if [[ ! -f "$file_renamed_default" ]]; then
                echo "Default $language_code does not exists."
                default_created=1
                file_renamed="$file_renamed_default"
            fi
        fi

        # Handle multiple subs for same language.
        if [[ $default_created -eq 0 ]]; then # If the default language file is created, then skips, as we have only 1 default language.
            file_renamed="${directory_name_new_file}/${basename_new_file}.${language_code}"
            file_renamed_to_check="${file_renamed}.${file_ext_arg}" # Start checking 1 language code.
            while [ -f "$file_renamed_to_check" ]; do
                file_renamed="${file_renamed}.${language_code}" # If file exits, keep adding language codes: en.en.en.fileextension
                file_renamed_to_check="${file_renamed}.${file_ext_arg}"
            done
            file_renamed="$file_renamed_to_check"
        fi

        echo "New file name: $file_renamed"
        cmd="mv $single_file $file_renamed"
        echo "Command: ${cmd}"
        eval "$cmd"
        files_created_list="${files_created_list}${file_renamed}\n"
    done
}

file_name_to_language_code() {
    file_name="$1"
    file_name_language=$(echo ${file_name} | cut -d'_' -f 2)
    echo >&2 "File name language: $file_name_language"
    for single_code in ${language_codes_arg[@]}; do
        #echo >&2 "$file_name_language <> $single_code"
        if [[ "$single_code" == *"$file_name_language"* ]]; then # ref.: https://linuxize.com/post/how-to-check-if-string-contains-substring-in-bash/
            language_code=$(echo ${single_code} | cut -d'-' -f 2)
            retval=${language_code}
            echo "$retval"
        fi
    done
}

if [[ $# -eq 0 ]]; then
    print_help_exit
fi

while getopts s:t:c:d:l: flag; do
    case "${flag}" in
    s)
        starting_directory_flag=1
        starting_directory_arg=${OPTARG}
        ;;
    t)
        file_ext_flag=1
        file_ext_arg=${OPTARG}
        ;;
    c)
        language_codes_flag=1
        language_codes_arg=$OPTARG
        ;;
    d)
        default_language_code_flag=1
        default_language_code_arg=$OPTARG
        ;;
    l)
        default_folder_levels_flag=1
        default_folder_levels_arg=$OPTARG
        ;;
    *)
        print_help_exit
        ;;
    esac
done

if [ $starting_directory_flag -eq 0 ] || [ $file_ext_flag -eq 0 ] || [ $language_codes_flag -eq 0 ] || [ $default_language_code_flag -eq 0 ] || [ $default_folder_levels_flag -eq 0 ]; then
    print_help_exit
else
    echo >&2 "Starting directory: $starting_directory_arg"
    echo >&2 "File type: $file_ext_arg"
    echo >&2 "Language codes: ${language_codes_arg[@]}"
    echo >&2 "Default language code: $default_language_code_arg"
    echo >&2 "Folders levels to move: $default_folder_levels_arg"
    rename_files_to_dir $(get_files_by_ext "$starting_directory_arg" "$file_ext_arg")
    echo "\nSummary:\n"
    echo "Files created:\n${files_created_list}"
    echo "Files skipped:\n${files_skipped_list}"
    exit 0
fi
