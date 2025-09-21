package com.miui.hybrid;

import android.app.admin.DeviceAdminReceiver;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

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
