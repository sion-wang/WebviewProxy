package {{.Project}}.model.vo.device

data class DeviceData(
        var deviceInfo: DeviceInfo?,
        var networkInfo: NetworkInfo?,
        var phoneInfo: PhoneInfo?,
        var gsmInfoList: ArrayList<GsmInfo>?,
        var wifiInfoList: ArrayList<WifiInfo>?,
        var gsmLocList: ArrayList<GsmLoc>?,
        var cdmaLocList: ArrayList<CdmaLoc>?,
        var gsmSignalList: ArrayList<GsmSignal>?,
        var cdmaSignalList: ArrayList<CdmaSignal>?,
        var evdoSignalList: ArrayList<EvdoSignal>?
)