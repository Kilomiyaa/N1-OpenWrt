#!/bin/bash
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Modify hostname
# 修改主机名
sed -i 's/LEDE/OpenWrt/g' package/base-files/files/bin/config_generate

# Add packages
# 添加科学上网源
#openclash
git clone --depth=1 https://github.com/vernesong/OpenClash package/luci-app-openclash
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic

# 添加自定义的软件包源
#filebrowser
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-filebrowser
#Openlist
git clone https://github.com/sbwml/luci-app-openlist package/openlist

# Remove packages
# 删除lean库中的插件，使用自定义源中的包。
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
#rm -rf feeds/luci/applications/luci-app-filebrowser
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/luci/applications/luci-app-mosdns
#rm -rf feeds/luci/themes/luci-theme-design
#rm -rf feeds/luci/applications/luci-app-design-config

# Default IP
# 默认IP
sed -i 's/192.168.1.1/192.168.0.3/g' package/base-files/files/bin/config_generate

#修改默认时间格式
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' $(find ./package/*/autocore/files/ -type f -name "index.htm")
