# 最低cmake版本
cmake_minimum_required(VERSION 3.14)

# C++ 标准：17+
set(CMAKE_CXX_STANDARD 17) # 可以为20
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 在64位编译
set(BUILD_USE_64BITS on)

# 声明C++项目
project(MIRAICP_TEMPLATE LANGUAGES CXX)

# 寻找库的头文件
set(
        MIRAICP_SOURCE_HEADER_PATH
        ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/json
        ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/json/nlohmann
        ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/utf8
        ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/utf8/utf8
        ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/polym
        ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include
        ${CMAKE_CURRENT_SOURCE_DIR}/single_include/MiraiCP
)

# 添加src目录下所有源文件（每次新增文件不要修改cmake，只需重新执行cmake命令）
file(GLOB PLUGIN_SOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)

# 添加动态库编译目标
set(MIRAICP_TARGET_NAME MiraiCPPlugin)
add_library(
        ${MIRAICP_TARGET_NAME}
        SHARED
        single_include/MiraiCP/MiraiCP.cpp # MiraiCP 源文件
        ${PLUGIN_SOURCE_PATH}
)

# json库启用C++17标准
target_compile_definitions(${MIRAICP_TARGET_NAME} PUBLIC JSON_HAS_CPP_17)

if (WIN32)
    # See Warning C4668
    target_compile_definitions(${MIRAICP_TARGET_NAME} PUBLIC WIN32_LEAN_AND_MEAN)
endif (WIN32)

# MSVC设置
if (MSVC)
    # C++17标准；异常处理模型：标准 C++ stack unwinding ；启用多线程编译；禁止无返回值的函数；禁用两个与 dll export 相关的 warnings ；加入 __cplusplus 宏支持
    target_compile_options(${MIRAICP_TARGET_NAME} PUBLIC /W4 /EHs /MP /std:c++17 /we4715 /wd4251 /wd4275 /wd5045 /wd4068 /Zc:__cplusplus /utf-8)
    # 注意：如果在其他文件使用 wstring 以及非 utf-8 编码，删除 /utf-8 参数并使用：
    # set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/single_include/MiraiCP/MiraiCP.cpp PROPERTIES COMPILE_FLAGS /utf-8)
else ()
    # 禁止无返回值的函数；隐藏符号表
    target_compile_options(${MIRAICP_TARGET_NAME} PUBLIC -Wall -Werror=return-type -fvisibility=hidden)
endif (MSVC)

# 引入全部头文件路径
target_include_directories(${MIRAICP_TARGET_NAME} PUBLIC ${MIRAICP_SOURCE_HEADER_PATH})

# 需要的预定义宏
target_compile_definitions(${MIRAICP_TARGET_NAME} PUBLIC JSON_MultipleHeaders=ON MIRAICP_LIB_SDK)

#################################################################################################

# 优化选项，需要使用cmake -DCMAKE_BUILD_TYPE=Release 启用，可按需删除
if (CMAKE_BUILD_TYPE MATCHES ".*Rel.*")
    message("Release build detected, enabling maximal optimization")
    if (MSVC)
        target_compile_options(${MIRAICP_TARGET_NAME} PUBLIC /Ox)
    else ()
        target_compile_options(${MIRAICP_TARGET_NAME} PUBLIC -O3)
    endif (MSVC)
endif (CMAKE_BUILD_TYPE MATCHES ".*Rel.*")

# 关闭所有warning，请按需使用
# target_compile_options(${MIRAICP_TARGET_NAME} PUBLIC -w)

# 保证插件移植性，注意如果存在无法静态链接的其他依赖，仍然无法移植
# 请按需删除下面所有的cmake内容
set_target_properties(${MIRAICP_TARGET_NAME} PROPERTIES LINK_SEARCH_START_STATIC 1)
set_target_properties(${MIRAICP_TARGET_NAME} PROPERTIES LINK_SEARCH_END_STATIC 1)

if (WIN32)
    if (MSVC)
        if (CMAKE_BUILD_TYPE MATCHES ".*Rel.*")
            target_compile_options(${MIRAICP_TARGET_NAME} PUBLIC /MT)
        else ()
            target_compile_options(${MIRAICP_TARGET_NAME} PUBLIC /MTd)
        endif ()
    else (MSVC)
        target_link_options(${MIRAICP_TARGET_NAME} PUBLIC -static)
    endif (MSVC)
endif (WIN32)

if (UNIX)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    target_link_options(${MIRAICP_TARGET_NAME} PUBLIC -static-libstdc++ -static-libgcc)
endif (UNIX)
