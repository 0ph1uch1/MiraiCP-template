// MiraiCP依赖文件(只需要引入这一个)
#include <MiraiCP.hpp>
using namespace MiraiCP;

const PluginConfig CPPPlugin::config{
        "Plugin id",          // 插件id
        "Plugin name",        // 插件名称
        "Version",            // 插件版本
        "Author name",        // 插件作者
        "Plugin description",  // 可选：插件描述
        "Publish time"        // 可选：日期
};

// 插件实例
class Main : public CPPPlugin {
public:
  // 配置插件信息
  Main() : CPPPlugin() {}
  ~Main() override = default;

  // 入口函数
  void onEnable() override {
    // 请在此处监听
  }

  // 退出函数
  void onDisable() override {
    /*插件结束前执行*/
  }
};

// 绑定当前插件实例
void MiraiCP::enrollPlugin() {
  MiraiCP::enrollPlugin(new Main);
}
