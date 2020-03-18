package {{.Project}}.model.vo.device

data class GsmInfo(
        val mcc: String?,
        val mnc: String?,
        val lac: String?,
        val cid: String?,
        val rssi: String?
)
