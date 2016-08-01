#!/bin/bash

echo "移動先を指定してください(例):[../Lavender/]"; read directory;

cp ./app.rb directory; mv ./bot.rb directory 

echo "完了！"

