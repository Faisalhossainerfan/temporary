# sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/Project-Awaken/android_manifest.git -b 12.1 -g default,-mips,-darwin,-notdefault
git clone https://github.com/Faisalhossainerfan/local_manifest-1.git --depth 1 -b main .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch awaken_santoni-user
export WITH_GAPPS=true
export TARGET_GAPPS_ARCH=arm64
export TZ=Asia/Dhaka #put before last build command
make bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
