#!/bin/bash

sh ../subs_rename.sh -s ./test_scenario_1 -t srt -c "Italian-it italian-it English-en english-en French-fr french-fr" -d en -l 2

sh ../subs_rename.sh -s ./test_scenario_2 -t srt -c "Italian-it italian-it English-en english-en" -d it -l 2

sh ../subs_rename.sh -s ./test_scenario_3 -t srt -c "Italian-it italian-it English-en english-en" -d en -l 1
