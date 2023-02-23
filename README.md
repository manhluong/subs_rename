# Subs Renamer

This script is to rename subtitles files that are in the format that you can find with rarbg torrents.

The format is:

Serie folder

- Video 1
- Video 2
- Video 3
- Subs folder
- - Episode 1
- - - Subtitle file 1
- - - Subtitle file 2
- - - Subtitle file 3
- - Episode 2
- - - Subtitle file 1
- - - Subtitle file 2
- - Episode 3
- - - Subtitle file 1
- - - Subtitle file 2
- - - Subtitle file 3
- - - Subtitle file 4

Or:

Movie folder

- Video
- Subs folder
- - Subtitle file 1
- - Subtitle file 2
- - Subtitle file 3

The renaming will move all subtitles files to the folder containing the video file and will rename them with language code and with default.

## Usage

To run the script, you will need to pass some parameters.

Pass no parameters to show the usage message with the parameters' list.

To see some examples, check the script that runs the test scenarios inside the `test` folder.

## Test

Inside the `test` folder you will find some e2e test harness in place.

Is not perfect but it can cover some scenarios.

First create the scenarios, with one script then run the tests with the other script.

## Code style

The formatting is done via the `shell-format` plugin of vscode:

https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format
