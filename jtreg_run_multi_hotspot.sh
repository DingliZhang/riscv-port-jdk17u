#!/bin/bash
export git_log=`git log | head -n 1 | awk '{print $2}' |cut -c1-6`
export tier="tier1"
export mkdir_name="jtreg_jdk17u_dir_multi_hotspot_${git_log}_${tier}_`date +%Y%m%d%H%M%S`"
export jtreg_home="/home/zhangdingli/jdk-tools/jtreg-6+1-riscv64fix"
export jdk_src_home="/home/zhangdingli/riscv-port-jdk17u"
export test_home="/home/zhangdingli/jtreg_dir"
export concurrency="16"

cd $test_home
mkdir $mkdir_name
cd $mkdir_name


ps -ef |grep 'qemu-7.2.0-rv64' | grep -v grep | awk '{print $2}' | xargs kill -9
## hotspot_test
##  -javaoption:-XX:+UnlockExperimentalVMOptions -javaoption:-XX:+UseRVV
mkdir hotspot_test_$tier && cd hotspot_test_$tier
$jtreg_home/bin/jtreg \
-Djdk.lang.Process.launchMechanism=vfork \
-concurrency:$concurrency -timeout:16  \
-v:default \
-jdk:$jdk_src_home/build/linux-riscv64-server-release/images/jdk \
-compilejdk:$jdk_src_home/build/linux-x86_64-server-release/images/jdk \
-nativepath:$jdk_src_home/nativelibs \
-exclude:$jdk_src_home/test/hotspot/jtreg/ProblemList-Xcomp.txt \
-exclude:$jdk_src_home/test/hotspot/jtreg/ProblemList-zgc.txt \
-exclude:$jdk_src_home/test/hotspot/jtreg/ProblemList.txt \
$jdk_src_home/test/hotspot/jtreg:$tier | ts -s

#ps -ef |grep 'qemu-7.1.0-rc4-riscv64' | grep -v grep | awk '{print $2}' | xargs kill -9
## langtools
cd ..
#mkdir langtools_test_$tier && cd langtools_test_$tier
#$jtreg_home/bin/jtreg \
#-Djdk.lang.Process.launchMechanism=vfork \
#-concurrency:$concurrency -timeout:50 -javaoption:-XX:+UnlockExperimentalVMOptions -javaoption:-XX:+UseRVV  \
#-v:default \
#-jdk:$jdk_src_home/build/linux-riscv64-server-release/images/jdk \
#-compilejdk:$jdk_src_home/build/linux-x86_64-server-release/images/jdk \
#-nativepath:$jdk_src_home/nativelibs \
#-exclude:$jdk_src_home/test/langtools/ProblemList.txt \
#$jdk_src_home/test/langtools:$tier

ps -ef |grep 'qemu-7.2.0-rv64' | grep -v grep | awk '{print $2}' | xargs kill -9