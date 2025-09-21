public class DeviceAdminReceiver extends android.app.admin.DeviceAdminReceiver {
    @Override
    public void onEnabled(Context context, Intent intent) {
        super.onEnabled(context, intent);
    }
    
    @Override
    public void onDisableRequested(Context context, Intent intent) {
        // 可以在这里提示用户
    }
}