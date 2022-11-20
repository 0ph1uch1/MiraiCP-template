# 最低cmake版本
cmake_minimum_required(VERSION 3.13)

# 声明C++项目
project(MiraiCPPlugin LANGUAGES CXX)

# C++ 标准：17+
set(CMAKE_CXX_STANDARD 17) # 可以为20
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 在64位编译
set(BUILD_USE_64BITS on)

# json库启用C++17标准
add_compile_definitions(JSON_HAS_CPP_17)

if(WIN32)
    # See Warning C4668
    add_compile_definitions(WIN32_LEAN_AND_MEAN)
endif(WIN32)

# MSVC设置
if(MSVC)
    SET(CMAKE_GENERATOR_PLATFORM x64)

    # C++17标准；以utf8编译；异常处理模型：标准 C++ stack unwinding；启用多线程编译；禁止无返回值的函数；禁用两个与dll export相关的warning；加入__cplusplus宏支持
    add_compile_options(/utf-8 /EHa /MP /we4715 /wd4251 /wd4275 /Zc:__cplusplus)

    # Disable RTTI
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /GR-")
else()
    # 禁止无返回值的函数
    add_compile_options(-Wall -Werror=return-type)

    # Disable RTTI；隐藏符号表
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti -fvisibility=hidden")
endif(MSVC)

# 优化选项，需要使用cmake -DCMAKE_BUILD_TYPE=Release 命令启用
if(CMAKE_BUILD_TYPE MATCHES ".*Rel.*")
    message("Release build detected, enabling maximal optimization")

    if(MSVC)
        add_compile_options(/Ox)
    else()
        add_compile_options(-O3)
    endif(MSVC)
endif(CMAKE_BUILD_TYPE MATCHES ".*Rel.*")

# 寻找库的头文件
set(
    SOURCE_HEADER_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/json
    ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/json/nlohmann
    ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/utf8
    ${CMAKE_CURRENT_SOURCE_DIR}/single_include/3rd_include/utf8/utf8
    ${CMAKE_CURRENT_SOURCE_DIR}/single_include/MiraiCP
)

# 添加src目录下所有源文件（每次新增文件不要修改cmake，只需重新执行cmake命令）
file(GLOB PLUGIN_SOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)

# 添加动态库编译目标
add_library(
    MiraiCPPlugin
    SHARED
    single_include/MiraiCP/MiraiCP.cpp # MiraiCP 源文件
    ${PLUGIN_SOURCE_PATH}
)

# 引入全部头文件路径
target_include_directories(MiraiCPPlugin PUBLIC ${SOURCE_HEADER_PATH})

# 需要的预定义宏
target_compile_definitions(MiraiCPPlugin PUBLIC JSON_MultipleHeaders=ON MIRAICP_LIB_SDK)

# 开启所有warning
target_compile_options(MiraiCPPlugin PUBLIC -Wall)

# 关闭所有warning
# target_compile_options(MiraiCPPlugin PUBLIC -w)

# 保证插件移植性，注意如果存在无法静态链接的其他依赖，仍然无法移植
set_target_properties(MiraiCPPlugin PROPERTIES LINK_SEARCH_START_STATIC 1)
set_target_properties(MiraiCPPlugin PROPERTIES LINK_SEARCH_END_STATIC 1)

if(WIN32)
    if(MSVC)
        if(CMAKE_BUILD_TYPE MATCHES ".*Rel.*")
            target_compile_options(MiraiCPPlugin PUBLIC /MT)
        else()
            target_compile_options(MiraiCPPlugin PUBLIC /MTd)
        endif()
    else()
        target_link_options(MiraiCPPlugin PUBLIC -static)
    endif(MSVC)
endif(WIN32)

if(UNIX)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    target_link_options(MiraiCPPlugin PUBLIC -static-libstdc++ -static-libgcc)
endif(UNIX)
