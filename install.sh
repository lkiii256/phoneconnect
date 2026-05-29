#!/bin/bash

echo "=================================================="
echo "    Phone Connect Suite Auto-Installer (Nobara/Fedora) "
echo "=================================================="
echo ""

# 1. Enable official repository for the latest scrcpy build
echo "[1/4] Configuring scrcpy software repositories..."
sudo dnf copr enable -y zeno/scrcpy

# 2. Install all core Android utilities, udev rules, and scrcpy
echo "[2/4] Deploying core dependencies..."
sudo dnf install -y android-tools scrcpy android-udev-rules ffmpeg

# 3. Create the Connectphone.sh script using a clean Here Document
echo "[3/4] Generating Connectphone.sh file on your Desktop..."
cat << 'EOF' > ./Connectphone.sh
#!/bin/bash

echo -ne "\e[1;32m\e[48;5;53m"; clear

echo "Select an option:"
echo "1) Connect via USB"
echo "2) Connect via Network"

read -p "cho=> " cho

case "$cho" in
    1)
        echo "Connecting via USB"
        echo plug in your phone and make sure you use as file transfer!
echo a popup should show now if your phone asks for consent alow it
adb shell 'cmd notification post -t "PC Connect" "Tag" "Phone is connected to a PC this could mean your phone can be 100% used without you knowing "' >/dev/null 2>&1
scrcpy >/dev/null 2>&1
echo if you see this, something has gone wrong maybe you closed the window or USB debugging is off
        ;;
    2)
        echo "Connecting via Network"
        echo go to dev options on your device and click on the wireless debugging text and the switch and click “Pair device with pairing code”

        # Ask for the pairing IP and Port
        read -p "Enter IP and Port from the pairing popup: " pair_info
        adb pair "$pair_info"

        echo ""
        echo now close that menu and make sure you are in the wireless debugging menu and not the pairing code menu

        # Ask for the connection IP and Port
        read -p "Enter the new IP and Port from the main screen: " connect_info
        adb connect "$connect_info"
        echo just a sec...
        echo alright, enjoy!
        scrcpy >/dev/null 2>&1
        ;;
    *)
        echo "Invalid selection"
        ;;
esac
EOF

# 4. Clean up any accidental Windows artifacts and assign execution flags
echo "[4/4] Finalizing application permissions..."
sed -i 's/\r$//' ./Connectphone.sh
chmod +x ./Connectphone.sh

echo Setup Finished! Connectphone.sh is ready to use.
echo You can now close this terminal window safely.
echo To run it right click Connectphone.sh and click Run In Konsole.
