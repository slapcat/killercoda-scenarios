echo -e '\n\n\nInstalling scenario...\nThis can take up to 1-2 minutes...\nScreen will clear when ready.\n'
while [ ! -f /tmp/finished ]; do sleep 1; done
echo -e '\n\nDONE!'
clear
