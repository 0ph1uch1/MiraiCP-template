# 最低cmake版本
cmake_minimum_required(VERSION 3.10)

# MSVC设置: 以utf8编译
add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
# MSVC设置: 异常处理模型
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/EHa>")
add_compile_options("$<$<C_COMPILER_ID:MSVC>:/EHa>")

# C++ 标准：17+
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 声明C++项目
project(MiraiCPPlugin LANGUAGES CXX)

# 寻找库的头文件
set(SOURCE_HEADER_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include
    ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/utf8
    ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/utf8/utf8
    ${CMAKE_CURRENT_SOURCE_DIR}/single_include/MiraiCP
)

# 添加src目录下所有源文件（每次新增文件不要修改cmake，只需重新执行cmake命令）
# file(GLOB PLUGIN_SOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)

# 添加动态库编译目标
add_library(
        MiraiCPPlugin
        SHARED
        ${CMAKE_CURRENT_SOURCE_DIR}/single_include/MiraiCP/MiraiCP.cpp # MiraiCP 源文件
        ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
        ${PLUGIN_SOURCE_PATH}
)

# 引入全部头文件路径
target_include_directories(MiraiCPPlugin PUBLIC ${SOURCE_HEADER_PATH})

# 插件移植性
if (WIN32)
    target_link_libraries(MiraiCPPlugin -static)
endif (WIN32)
if (UNIX)
    target_link_libraries(MiraiCPPlugin -static-libstdc++ -static-libgcc)
endif (UNIX)