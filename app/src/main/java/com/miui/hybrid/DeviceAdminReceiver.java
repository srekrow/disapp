package com.miui.hybrid;

// 我们不再需要导入 DeviceAdminReceiver 了，所以下一行被删除了
// import android.app.admin.DeviceAdminReceiver;

import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

// 在这里，我们使用完整的类名来避免命名冲突
public class DeviceAdminReceiver extends android.app.admin.DeviceAdminReceiver {

    @Override
    public void onEnabled(Context context, Intent intent) {
        super.onEnabled(context, intent);
        Toast.makeText(context, "设备管理器已激活", Toast.LENGTH_SHORT).show();
    }

    @Override
    public CharSequence onDisableRequested(Context context, Intent intent) {
        // 当用户尝试禁用设备管理器时，返回这段文字作为提示
        return "禁用此服务可能会导致广告应用被重新安装。";
    }

    @Override
    public void onDisabled(Context context, Intent intent) {
        super.onDisabled(context, intent);
        Toast.makeText(context, "设备管理器已禁用", Toast.LENGTH_SHORT).show();
    }
}
