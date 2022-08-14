// MiraiCP依赖文件(只需要引入这一个)
#include <MiraiCP.hpp>
using namespace MiraiCP;

const PluginConfig CPPPlugin::config {
        "Plugin id",          // 插件id，如果和其他插件id重复将会被拒绝加载！
        "Plugin name",        // 插件名称
        "Version",            // 插件版本
        "Author name",        // 插件作者
        "Plugin description"  // 可选：插件描述
        "Publish time"        // 可选：日期
};

// 插件实例
class PluginMain : public CPPPlugin {
public:
  // 配置插件信息
  PluginMain() : CPPPlugin() {}
  ~PluginMain() override = default; // override关键字是为了防止内存泄漏

  // 入口函数。插件初始化时会被调用一次，请在此处注册监听
  void onEnable() override {
    /*插件启动时执行一次*/
  }

  // 退出函数。请在这里结束掉所有子线程，否则可能会导致程序崩溃
  void onDisable() override {
    /*插件结束前执行*/
  }
};

// 绑定当前插件实例。需传入enrollPlugin()一个用new生成的Main指针，
// 不可以传入静态或栈上分配的Main对象地址；该对象生命周期将交给MiraiCP管理
void MiraiCP::enrollPlugin() {
  MiraiCP::enrollPlugin(new PluginMain);
}
