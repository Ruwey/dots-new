# Autostart
# Load Xresources 
xrdb -merge .config/Xresources

# Composite Manager
picom &

# Notification Manager
dunst &

# Set Background
#{%@@ if colorscheme == "Nord" @@%}#
xwallpaper --zoom $HOME/Pictures/PFPrism.png &
#{%@@ elif colorscheme == "Mntns" @@%}#
xwallpaper --zoom $HOME/Pictures/Mntns.png &
#{%@@ endif @@%}#
