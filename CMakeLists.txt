# 最低cmake版本
cmake_minimum_required(VERSION 3.10)
# 以utf8编译
add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
# C++ 标准17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# 解决本地编译放到运行环境出现/usr/lib/x86_64-linux-gnu/libstdc++.so.6: GLIBCXX_3.4.26 not found的问题
#set(CMAKE_EXE_LINKER_FLAGS "-static-libstdc++")  # 编译出来的东西会大一点，默认关闭，适合多服务器。
# 声明C++项目
project(MiraiCP LANGUAGES CXX)
# 寻找本地JNI文件
set(JAVA_AWT_LIBRARY NotNeeded)
set(JAVA_JVM_LIBRARY NotNeeded)
set(JAVA_AWT_INCLUDE_PATH NotNeeded)
find_package(JNI REQUIRED)
if (JNI_FOUND)
    message (STATUS "FOUND JNI IN ${JAVA_INCLUDE_PATH}")
    # 依赖文件路径
    set(SOURCE_PATH
            ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include
            ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/utf8
            ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/utf8/utf8
            ${CMAKE_CURRENT_SOURCE_DIR}/single_include/MiraiCP
            ${JAVA_INCLUDE_PATH}/
            ${JAVA_INCLUDE_PATH2}/
            )
else()
    message(STATUS "Cannot find JNI")
endif()
# 添加动态库编译目标
add_library(
        MiraiCP
        SHARED
        single_include/MiraiCP/MiraiCP.cpp # MiraiCP 源文件
        main.cpp
)
# 引入全部依赖文件路径
target_include_directories(MiraiCP PUBLIC ${SOURCE_PATH})
