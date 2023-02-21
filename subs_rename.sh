#!/bin/bash

starting_directory_flag=0
starting_directory_arg=0
file_ext_flag=0
file_ext_arg=0
language_codes_flag=0
language_codes_arg=0

function print_help {
    echo 'Parameters and flags:'
    echo '   [Mandatory] -d Starting directory - Ex.: ../dir/another_dir'
    echo '   [Mandatory] -t File extension / type - Ex.: srt'
    echo '   [Mandatory] -c Language codes - Ex.: "Italian-it italian-it English-en english-en French-fr french-fr"'
}

function print_help_exit {
    print_help
    exit 1
}

function get_files_by_ext {
    starting_directory="$1"
    file_type="$2"
    cmd="find $starting_directory -name '*.$file_type' -type f"
    echo >&2 "Command: ${cmd}"
    files_list=$(eval "$cmd")
    echo >&2 "[\nFiles:\n${files_list}\n]"
    retval=${files_list}
    echo "$retval"
}

function rename_files_to_dir {
    files_list="$@"
    for single_file in $files_list
    do
        directory_name=$( basename ${single_file%/*} )
        echo "Directory: $directory_name"
        file_name_with_ext="$(basename -- $single_file)"
        file_name=$(echo ${file_name_with_ext} | grep -o '^[^\.]*' )
        echo "File name: $file_name"
        file_name_to_language_code $file_name
        language_code=$( file_name_to_language_code "$file_name")
        echo "Language code: $language_code"
        file_renamed="${directory_name}.${language_code}.${file_ext_arg}"
        echo "New file name: $file_renamed"
    done
}

function file_name_to_language_code {
    file_name="$1"
    file_name_language=$(echo ${file_name} | cut -d'_' -f 2 )
    echo >&2 "File name language: $file_name_language"
    for single_code in ${language_codes_arg[@]};
    do
        #echo >&2 "$file_name_language <> $single_code"
        if [[ "$single_code" == *"$file_name_language"* ]]; then # ref.: https://linuxize.com/post/how-to-check-if-string-contains-substring-in-bash/
           language_code=$(echo ${single_code} | cut -d'-' -f 2 )
           retval=${language_code}
           echo "$retval"
        fi
    done
}

if [[ $# -eq 0 ]] ; then
    print_help_exit
fi

while getopts d:t:c: flag
do
    case "${flag}" in
        d)
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
        *)
           print_help_exit
        ;;
    esac
done

if [ $starting_directory_flag -eq 0 ] || [ $file_ext_flag -eq 0 ] || [ $language_codes_flag -eq 0 ]
then
   print_help_exit
else
   echo >&2 "Starting directory: $starting_directory_arg"
   echo >&2 "File type: $file_ext_arg"
   echo >&2 "Language codes: ${language_codes_arg[@]}"
   rename_files_to_dir $( get_files_by_ext "$starting_directory_arg" "$file_ext_arg")
   exit 0
fi
