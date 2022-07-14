# MiraiCP-template
> 留意和MiraiCP loader/plugin 的版本对应
> 
> 当前文件版本是 [![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Nambers/MiraiCP?include_prereleases)](https://github.com/Nambers/MiraiCP/releases/) 
> 
> 如果要旧版去tag里找

您可以完全自定义您的cmake项目。如果您对cmake不太了解，请参考如下使用方法。
- clone本仓库，或下载zip并解压

- 通过cmake生成项目。推荐使用Clion进行开发，可以自动加载、重载cmake项目，否则请参考下面的项目生成tips。源文件以及头文件请添加进`src/`目录。每次添加或重命名`.cpp`文件时，需要在Clion中重新加载cmake项目，或者重新执行下面的cmake命令。

  - Windows上使用Visual Studio开发：首先需要[下载cmake](https://cmake.org/download/)并确保`cmake`已经被添加到`PATH`。在本目录下新建文件夹`build`，在`build`文件夹中打开powershell窗口，执行

    ```powershell
    cmake .. --config Release
    ```

    即可生成Visual Studio项目。双击`MiraiCPPlugin.sln`打开项目编写、编译。

  - Linux：请先根据您的发行版安装`cmake`。在本目录下执行

    ```shell
    mkdir build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release ..
    ```

    在`build`文件夹中使用`make`编译代码。

- 生成的文件在build目录下，后缀为`.dll`或`.so`。和MiraiCP loader/plugin 配合用（在loader/plugin的config.json里写路径, 见[MiraiCP文档](https://github.com/Nambers/MiraiCP/blob/main/README.md#32-%E5%90%AF%E5%8A%A8sdk)）

