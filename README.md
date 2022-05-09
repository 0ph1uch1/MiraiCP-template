# MiraiCP-template
> 留意和MiraiCP loader/plugin 的版本对应
> 
> 当前文件版本是 [![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Nambers/MiraiCP?include_prereleases)](https://github.com/Nambers/MiraiCP/releases/) 
> 
> 如果要旧版去tag里找

使用方法:
- clone

- Linux环境：执行`./export.sh`导出`JAVA_HOME`环境变量（Windows跳过这一步）

- 通过cmake编译出库文件

  - Windows上使用Visual Studio开发：首先需要[下载cmake](https://cmake.org/download/)并确保cmake已经被添加到PATH。在MiraiCP目录下新建文件夹`build`，在`build`文件夹中打开powershell窗口，执行

    ```powershell
    cmake ..
    ```

    即可生成Visual Studio项目。双击`MiraiCP.sln`打开项目编写。

  - Linux：

    ```shell
    mkdir build
    cd build
    cmake ..
    ```

    在`build`文件夹中使用`make`编译代码。

- 和MiraiCP loader/plugin 配合用(在loader/plugin的config.json里写路径, 见[MiraiCP文档](https://github.com/Nambers/MiraiCP/blob/main/README.md#32-%E5%90%AF%E5%8A%A8sdk))

