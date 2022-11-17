#!/bin/bash
ROOT=$(pwd)

echo "请选择构建设备："
echo "1. AX1800"
echo "2. AXT1800"
read input

case $input in
1)
		echo "构建AX1800"
		DEVICE="ax1800"
		;;
2)
		echo "构建AXT1800"
		DEVICE="axt1800"
		;;
esac

#clone source tree
git clone https://github.com/gl-inet/gl-infra-builder.git $ROOT/gl-infra-builder
cp -r $ROOT/*.yml $ROOT/gl-infra-builder/profiles
cd $ROOT/gl-infra-builder
#setup
python3 setup.py -c config-wlan-ap-5.4.yml

cd wlan-ap/openwrt
./scripts/gen_config.py  $ROOT/gl-infra-builder/profiles/glinet_$DEVICE-5-4 glinet_depends

# ./scripts/feeds update -a
# ./scripts/feeds install -a
make defconfig


make -j$(expr $(nproc) + 1)  V=s