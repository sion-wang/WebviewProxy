package {{.Project}}.model.vo.device

data class DeviceInfo(
        val sdkVersionCode: Int?,
        val sdkVersionName: String?,
        val androidId: String?,
        val macAddress: String?,
        val manufacturer: String?,
        val model: String?,
        val abis: MutableList<String>?
)
