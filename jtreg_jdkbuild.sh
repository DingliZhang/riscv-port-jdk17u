#!/bin/bash
export PATH=/home/zhangdingli/riscv/bin:$PATH
export riscvpath="/home/zhangdingli/riscv"
export jdk_src_home="/home/zhangdingli/riscv-port-jdk17u"
#export package_shell_path="/home/zhangdingli/prepare_rv64v.sh"
export package_shell_path="/home/zhangdingli/prepare_rv64.sh"
export BOOT_JDK="/home/zhangdingli/jdk-bin/jdk-17"
export sysroot="$riscvpath/sysroot"

cd $jdk_src_home
rm -rf build/linux-x86_64-server-release
## build x86
bash configure \
--with-boot-jdk=$BOOT_JDK \
--disable-warnings-as-errors \
--with-native-debug-symbols=none \
--with-cups=/home/zhangdingli/jdk-libs/x64/sysroot/usr \
--with-debug-level=release
make images CONF=linux-x86_64-server-release

## build rvv
rm -rf build/linux-riscv64-server-release
#CC=$riscvpath/bin/riscv64-unknown-linux-gnu-gcc \
#CXX=$riscvpath/bin/riscv64-unknown-linux-gnu-g++ \
bash configure \
--with-boot-jdk=$BOOT_JDK \
--openjdk-target=riscv64-unknown-linux-gnu \
--with-sysroot=$sysroot \
--disable-warnings-as-errors \
--with-native-debug-symbols=none \
--with-debug-level=release
make all CONF=linux-riscv64-server-release

## package bin
bash $package_shell_path $jdk_src_home/build/linux-riscv64-server-release/images/jdk

## mv libs
rm -rf $jdk_src_home/nativelibs && mkdir $jdk_src_home/nativelibs
cp $jdk_src_home/build/linux-riscv64-server-release/images/test/hotspot/jtreg/native/*.so $jdk_src_home/nativelibs
cp $jdk_src_home/build/linux-riscv64-server-release/images/test/jdk/jtreg/native/*.so $jdk_src_home/nativelibs

## start test
if [ "$1" == "jdk" ]
then
    echo "Build finish and just run jdk tests."
    export test_type="jdk"
elif [ "$1" == "hotspot" ]
then
    echo "Build finish and just run hotspot tests."
    export test_type="hotspot"
elif [ "$1" == "build" ]
then
    echo "Build finish and exit."
    exit 0
else
    echo "Build finish and run jdk/hotspot tests."
fi


# export tmux_name="tmux_zdl_`date +%Y%m%d%H%M%S`"


# if [ -n "$1" ]
# then
#     tmux new-session -s $tmux_name 'bash jtreg_run.sh $test_type'
# else
#     tmux new-session -s $tmux_name 'bash jtreg_run_multi.sh'
# i

# grep -wo "Passed." JTwork/jtData/harness.trace | wc -l && grep -wo "Starting:" JTwork/jtData/harness.trace | wc -l && grep -wo "Finished:" JTwork/jtData/harness.trace | wc -l

# grep -wo "Passed." JTwork/jtData/harness.trace | wc -l && grep -wo "starting:" JTwork/jtData/harness.trace | wc -l && grep -wo "finished:" JTwork/jtData/harness.trace | wc -l

# use:
# $ bash jtreg_jdkbuild.sh jdk
# $ bash jtreg_run.sh hotspots




# grep -wo "Passed." hotspot_test/JTwork/jtData/harness.trace | wc -l && \
# grep -wo "starting:" hotspot_test/JTwork/jtData/harness.trace | wc -l && \
# grep -wo "finished:" hotspot_test/JTwork/jtData/harness.trace | wc -l && \
# grep -wo "Passed." jdk_test/JTwork/jtData/harness.trace | wc -l && \
# grep -wo "starting:" jdk_test/JTwork/jtData/harness.trace | wc -l && \
# grep -wo "finished:" jdk_test/JTwork/jtData/harness.trace | wc -l
