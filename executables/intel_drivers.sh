#!/bin/bash

sudo pacman -Syu --noconfirm intel-media-driver libva vulkan-intel vulkan-tools mesa

#Set environment variable to use the i965
export LIBVA_DRIVER_NAME=i965

# Set symlink for the Intel Vulkan driver 
sudo ln -sf /usr/lib/dri/intel-media-driver/iHD_drv_video.so /usr/lib/dri/iHD_drv_video.so

# Add Vulkan environment variables
echo 'export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json' >> ~/.bashrc
echo 'export VK_LAYER_PATH=/usr/share/vulkan/explicit_layer.d' >> ~/.bashrc

#Reload the shell configuration
source ~/.bashrc



