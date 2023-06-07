bash configure \
--with-jtreg=/home/dingli/jdk-tools/jtreg-6+1-riscv64fix \
--with-gtest=/home/dingli/jdk-tools/googletest-1.8.1 \
--with-boot-jdk=/home/dingli/jdk-bin/jdk-17
make test TEST="tier3" JTREG="TIMEOUT_FACTOR=16" | ts -s
make test TEST="tier1 tier2 tier3" JTREG="TIMEOUT_FACTOR=16" | ts -s

make test TEST="jdk:tier1" JTREG="TIMEOUT_FACTOR=16" | ts -s

8293007 -- 8291947 -- 8291893
https://bugs.openjdk.org/browse/JDK-8230552?focusedCommentId=14334977&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-14334977
https://github.com/yadongw/jdk17u-dev/commit/312039f1659dd233736952a40364963c5a64cb73
./java -XX:+UnlockExperimentalVMOptions -XX:+UseRVC -XX:+PrintFlagsFinal -version | grep UseRVC
./java -XX:+UnlockExperimentalVMOptions -XX:+PrintFlagsFinal -version | grep UseRVC
./java -XX:+UnlockExperimentalVMOptions -XX:+UseRVV -XX:+PrintFlagsFinal -version | grep UseRVV

0. https://bugs.openjdk.org/browse/JDK-8290496
- To resolve build warnings-as-errors

1. https://bugs.openjdk.org/browse/JDK-8290164
- TEST: compiler/runtime/TestConstantsInError.java

2. https://bugs.openjdk.org/browse/JDK-8292407
- TEST: compiler/unsafe/JdkInternalMiscUnsafeAccessTestChar.java
- TEST: java/lang/invoke/VarHandles/VarHandleTestAccessChar.java
- And others

3. https://bugs.openjdk.org/browse/JDK-8293100
- TEST: vmTestbase/nsk/stress/jni/jnistress002.java

4. https://bugs.openjdk.org/browse/JDK-8285437
- To resolve JVM crash with -XX:+VerifyOops

5.       Patch list for backport
5.1 patch for bugfix
8293007: riscv: failed to build after JDK-8290025                              # fail after https://bugs.openjdk.org/browse/JDK-8290025
8284191: Replace usages of 'a the' in hotspot and java.base                    # baseline not apply
# 8287552: riscv: Fix comment typo in li64                                       ## 8287552.patch
8287970: riscv: jdk/incubator/vector/*VectorTests failing                      ## 8287970.patch
8291893: riscv: remove fence.i used in user space                              # 8291893.patch not cleanly
8291947: riscv: fail to build after JDK-8290840                                # baseline not apply
8294012: RISC-V: get/put_native_u8 missing the case when address&7 is 6        ## 8294012.patch
8294087: RISC-V: RVC: Fix a potential alignment issue and add more alignment assertions for the patchable calls/nops # 8294087.patch not cleanly
8294190: Incorrect check messages in SharedRuntime::generate_uncommon_trap_blob # with aarch64 and x86 
8295016: Make the arraycopy_epilogue signature consistent with its usage        # with aarch64
8295926: RISC-V: C1: Fix LIRGenerator::do_LibmIntrinsic                         ## 8295926.patch git add test/hotspot/jtreg/compiler/floatingpoint/TestLibmIntrinsics.java
8296448: RISC-V: Fix temp usages of heapbase register killed by MacroAssembler::en/decode_klass_not_null # 8296448.patch not cleanly
# 8296771: RISC-V: C2: assert(false) failed: bad AD file                          ## 8296771.patch


5.       Patch list for backport
5.1 patch for bugfix
# 8287552: riscv: Fix comment typo in li64                                       ## 8287552.patch
# 8296771: RISC-V: C2: assert(false) failed: bad AD file                          ## 8296771.patch
# 8287970: riscv: jdk/incubator/vector/*VectorTests failing                      ## 8287970.patch | JDK-8284960 added a new vector operation VectorOperations.BIT_COUNT, which needs the support of PopCountV*. The following tests failed when enabling UseRVV:
8294012: RISC-V: get/put_native_u8 missing the case when address&7 is 6        ## 8294012.patch
# 8295926: RISC-V: C1: Fix LIRGenerator::do_LibmIntrinsic                         ## 8295926.patch git add test/hotspot/jtreg/compiler/floatingpoint/TestLibmIntrinsics.java

8293007: riscv: failed to build after JDK-8290025                              # backport-8293007.patch | only need g1BarrierSetAssembler_riscv.cpp other are high version
# 8291947: riscv: fail to build after JDK-8290840                                # backport-8291947.patch not cleanly | no 8290840, Refactor the "os" class
# * 8291893: riscv: remove fence.i used in user space                              # backport-8291893_20230314.patch backport-8291893.patch not cleanly | linenumber
8294190: Incorrect check messages in SharedRuntime::generate_uncommon_trap_blob ## with aarch64 and x86 wyd_8294190.patch | linenumber
8295016: Make the arraycopy_epilogue signature consistent with its usage        ## with aarch64  backport-8295016.patch | linenumber




8294012: RISC-V: get/put_native_u8 missing the case when address&7 is 6           ## 8294012.patch
8293007: riscv: failed to build after JDK-8290025                                 # backport-8293007.patch | only need g1BarrierSetAssembler_riscv.cpp other are high version
8294190: Incorrect check messages in SharedRuntime::generate_uncommon_trap_blob   ## with aarch64 and x86 wyd_8294190.patch | linenumber
8295016: Make the arraycopy_epilogue signature consistent with its usage          ## with aarch64  backport-8295016.patch | linenumber
8284191: Replace usages of 'a the' in hotspot and java.base                       # wyd_8284191.patch | only apply riscv, rm vector_op_pre_select_sz_estimate which no use from 8281375
# 8294087: RISC-V: RVC: Fix a potential alignment issue and add more alignment assertions for the patchable calls/nops 
# backport-8294087.patch not cleanly | some high version patch from 8293007(emit_entry_barrier_stub)
# address call_pc = pc(); in 8293840
# 8296448: RISC-V: Fix temp usages of heapbase register killed by MacroAssembler::en/decode_klass_not_null 
# not cleanly    backport-8296448.patch | no 8295457: Make the signatures of write barrier methods consistent  
# no 8293290: RISC-V: Explicitly pass a third temp register to MacroAssembler::store_heap_oop for tmp3
# | src/hotspot/cpu/riscv/macroAssembler_riscv.hpp::access_store_at different para
                                                                                                                                                               # assert_different_registers in C1_MacroAssembler::initialize_header has modify when (UseBiasedLocking & !len->is_valid()) is true


5.2   Other refactoring patches
#8290137: riscv: small refactoring for add_memory_int32/64
8292867: RISC-V: Simplify weak CAS return value handling
8293050: RISC-V: Remove redundant non-null assertions about macro-assembler
8293290: RISC-V: Explicitly pass a third temp register to MacroAssembler::store_heap_oop
#8293474: RISC-V: Unify the way of moving function pointer
8293524: RISC-V: Use macro-assembler functions as appropriate
8293566: RISC-V: Clean up push and pop registers
8293769: RISC-V: Add a second temporary register for BarrierSetAssembler::load_at
8293781: RISC-V: Clarify types of calls
8293840: RISC-V: Remove cbuf parameter from far_call/far_jump/trampoline_call
## 8294086: RISC-V: Cleanup InstructionMark usages in the backend
8294100: RISC-V: Move rt_call and xxx_move from SharedRuntime to MacroAssembler
## 8294187: RISC-V: Unify all relocations for the backend into AbstractAssembler::relocate()
## 8294366: RISC-V: Partially mark out incompressible regions
#8294430: RISC-V: Small refactoring for movptr_with_offset
#8294492: RISC-V: Use li instead of patchable movptr at non-patchable callsites
## 8295110: RISC-V: Mark out relocations as incompressible
#8295270: RISC-V: Clean up and refactoring for assembler functions
8295273: Remove unused argument in [load/store]_sized_value on aarch64 and riscv
8295396: RISC-V: Cleanup useless CompressibleRegions
8295703: RISC-V: Remove implicit noreg temp register arguments in MacroAssembler
8295968: RISC-V: Rename some assembler intrinsic functions for RVV 1.0



8290137: riscv: small refactoring for add_memory_int32/64                          8290137.diff
8293474: RISC-V: Unify the way of moving function pointer                          backport-8293474-2.patch  line number  , 8299168 changes
8294430: RISC-V: Small refactoring for movptr_with_offset                          backport-8294430.patch | 17u no emit_etnry_barrier_stub, introduce with 8293007
8294492: RISC-V: Use li instead of patchable movptr at non-patchable callsites     backport-8294492.patch | 17u no 8293769, 8296916, 8294100
8295270: RISC-V: Clean up and refactoring for assembler functions                  backport-8295270-2.patch | origin patch has no eden_allocate, which removed with 8290706

# other_errors.txt
tools/javac/6257443/T6257443.java
tools/javac/8074306/TestSyntheticNullChecks.java
tools/javac/StringConcat/TestIndyStringConcat.java
tools/javac/jvm/ClassRefDupInConstantPoolTest.java
tools/javac/warnings/suppress/PackageInfo.java

# newfailures.txt
jdk/javadoc/doclet/testSerialVersionUID/TestSerialVersionUID.java
jdk/javadoc/doclet/testTagMisuse/TestTagMisuse.java
jdk/javadoc/doclet/testThrows/TestThrows.java
jdk/javadoc/doclet/testThrowsHead/TestThrowsHead.java
jdk/javadoc/doclet/testUnnamedPackage/TestUnnamedPackage.java
jdk/javadoc/tool/nonConstExprs/Test.java


## included
https://bugs.openjdk.org/browse/JDK-8284068
https://bugs.openjdk.org/browse/JDK-8284937
https://bugs.openjdk.org/browse/JDK-8285303
https://bugs.openjdk.org/browse/JDK-8287418
https://bugs.openjdk.org/browse/JDK-8297644
https://bugs.openjdk.org/browse/JDK-8291952


#8292867: RISC-V: Simplify weak CAS return value handling         # 8292867.diff
#8293524: RISC-V: Use macro-assembler functions as appropriate    # backport-8293524.patch 17u already had 8295396 8295110 8294187, no 8276901
#8293566: RISC-V: Clean up push and pop registers                 # backport-8293566.patch 17u already had 8295396 8295968
#8294012: RISC-V: get/put_native_u8 missing the case when address&7 is 6  # 8294012.diff
#8294679: RISC-V: Misc crash dump improvements                    # 8294679.diff


#8296435: RISC-V: Small refactoring for increment/decrement                     # backport-8296435.patch 8296435.diff   no bind(no_count)
#8296916: RISC-V: Move some small macro-assembler functions to header file      # backport-8296916.patch 8296916.diff  no JDK-8294100(object_move) no vneg_v
#8297359: RISC-V: improve performance of floating Max Min intrinsics            # 8297359.diff
#8297697: RISC-V: Add support for SATP mode detection                           # backport-8297697.patch
#8301067: RISC-V: better error message when reporting unsupported satp modes    # backport-8301067.patch



#8301036: RISC-V: Factor out functions baseOffset & baseOffset32 from MacroAssembler    # backport-8301036.patch 8301036.diff not clean because of whitespace
#8301153: RISC-V: pipeline class for several instructions is not set correctly          # 8301153.diff
#8301628: RISC-V: c2 fix pipeline class for several instructions                        # backport-8301628.patch 8301628.diff   no 8293695
#8301818: RISC-V: Factor out function mvw from MacroAssemble                            # backport-8301818.patch 8301818.diff   no 8286301 8290154
#8302114: RISC-V: Several foreign jtreg tests fail with debug build after JDK-8301818   # backport-8302114.patch 8302114.diff  no 8286301 8290154
#8301852: RISC-V: Optimize class atomic when order is memory_order_relaxed              # 8301852.diff

##8302289: RISC-V: Use bgez instruction in arraycopy_simple_check when possible                 # 8302289.diff
8305008: RISC-V: Factor out immediate checking functions from assembler_riscv.inline.hpp      # backport-8305008.patch 8305008.diff no 8295948 8294100  

#8307651: RISC-V: stringL_indexof_char instruction has wrong format string
#8307446: RISC-V: Improve performance of floating point to integer conversion
#8307150: RISC-V: Remove remaining StoreLoad barrier with UseCondCardMark for Serial/Parallel GC



8301033: RISC-V: Handle special cases for MinI/MaxI nodes for Zbb                    # 8301033.diff
61a5f114eee3a90cfff9ab8b815bacca8985c211

Hi, please review this backport to riscv-port-jdk17u.
Backport of [JDK-8301033](https://bugs.openjdk.org/browse/JDK-8301033). Applies cleanly.

Testing:
- https://github.com/openjdk/jdk/blob/master/test/hotspot/jtreg/compiler/intrinsics/math/TestMinMaxIntrinsics.java (Note that 17u dose not have this case yet)
- tier1-3 tests on QEMU-System w/ and w/o UseZbb (release build)
- tier1-3 tests on unmatched board w/o UseZbb (release build)


8305728: RISC-V: Use bexti instruction to do single-bit testing                      # backport-8305728.patch 8305728.diff no 8299089 8301995
137513025dad06fc08818fa832edb4a487298f81

Hi, please review this backport to riscv-port-jdk17u.
Backport of [JDK-8305728](https://bugs.openjdk.org/browse/JDK-8305728). The original patch cannot be directly applied because jdk17u has no [JDK-8299089](https://bugs.openjdk.org/browse/JDK-8299089) and [JDK-8301995](https://bugs.openjdk.org/browse/JDK-8301995).

Testing:
- tier1-3 tests on QEMU-System w/ and w/o UseZbs (release build)
- tier1-3 tests on unmatched board w/o UseZbs (release build)


root@qemuriscv64:~/STAP# jdk/bin/java -version
openjdk version "17.0.8-internal" 2023-07-18
OpenJDK Runtime Environment (build 17.0.8-internal+0-adhoc.zhangdingli.riscv-port-jdk17u)
OpenJDK 64-Bit Server VM (build 17.0.8-internal+0-adhoc.zhangdingli.riscv-port-jdk17u, mixed mode)


root@qemuriscv64:~/STAP# ./jdk/bin/java -version
Error occurred during initialization of VM
Unsupported satp mode: sv57. Only satp modes up to sv48 are supported for now.


8308997   # backport-8308997.patch 8308997.diff  no 8294100 8301496