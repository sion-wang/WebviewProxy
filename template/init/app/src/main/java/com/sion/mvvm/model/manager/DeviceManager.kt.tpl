package {{.Project}}.model.manager

import android.Manifest.permission.READ_PHONE_STATE
import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Context.*
import android.content.Intent
import android.content.IntentFilter
import android.location.LocationManager
import android.net.wifi.WifiManager
import android.os.Build
import android.telephony.*
import android.telephony.cdma.CdmaCellLocation
import android.telephony.gsm.GsmCellLocation
import androidx.annotation.RequiresPermission
import com.blankj.utilcode.util.DeviceUtils
import com.blankj.utilcode.util.NetworkUtils
import com.blankj.utilcode.util.PhoneUtils
import {{.Project}}.App
import {{.Project}}.BuildConfig
import {{.Project}}.model.api.ApiResult
import {{.Project}}.model.api.vo.LogRequest
import {{.Project}}.model.enums.LogLevel.ERROR
import {{.Project}}.model.enums.LogLevel.INFO
import {{.Project}}.model.vo.device.*
import {{.Project}}.widget.utility.AppUtils
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.HttpException
import timber.log.Timber

class DeviceManager(private val domainManager: DomainManager) {

    companion object {
        const val PLATFORM_ANDROID = "Android"

        const val CELL_INFO_LTE = "CellInfoLte"
        const val CELL_INFO_CDMA = "CellInfoCdma"
        const val CELL_INFO_GSM = "CellInfoGsm"
        const val CDMA_MCC = "460"
        const val CDMA_MNC = "0"
        const val CDMA_LAC = "0"
    }

    private var wifiInfoList = arrayListOf<WifiInfo>()
    private val gsmLocList = arrayListOf<GsmLoc>()
    private val cdmaLocList = arrayListOf<CdmaLoc>()
    private val gsmSignalList = arrayListOf<GsmSignal>()
    private val cdmaSignalList = arrayListOf<CdmaSignal>()
    private val evdoSignalList = arrayListOf<EvdoSignal>()

    private val wifiManager = App.applicationContext().getSystemService(WIFI_SERVICE) as WifiManager
    private val telephonyManager =
            App.applicationContext().getSystemService(TELEPHONY_SERVICE) as TelephonyManager
    private val locationManager =
            App.applicationContext().getSystemService(LOCATION_SERVICE) as LocationManager

    private var isRegisterListener = false

    @SuppressLint("MissingPermission")
    fun sendCrashReport(data: String) =
            flow {
                val request = getMobileInfo(ERROR.getString(), ERROR.value)
                request.errorMessage = data
                val result = domainManager.getApiRepository().sendLog(request)
                if (!result.isSuccessful) throw HttpException(result)
                emit(ApiResult.success(result))
            }
                    .flowOn(Dispatchers.IO)
                    .catch { e -> emit(ApiResult.error(e)) }

    @SuppressLint("MissingPermission")
    fun sendLog(data: String) =
           flow {
                val request = getMobileInfo(INFO.getString(), INFO.value)
                request.errorMessage = data
                val result = domainManager.getApiRepository().sendLog(request)
                if (!result.isSuccessful) throw HttpException(result)
                emit(ApiResult.success(result))
            }
                    .flowOn(Dispatchers.IO)
                    .catch { e -> emit(ApiResult.error(e)) }

    @SuppressLint("MissingPermission")
//    fun sendDeviceInfo() =
//            flow {
//                val deviceData = fetchDeviceData()
//                val request = getMobileInfo(EVENT_DEVICE_INFO, LEVEL_DEVICE_INFO)
//                request.data = deviceData
//                val location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER)
//                if (location != null) {
//                    val latitude = location.latitude.toString()
//                    val longitude = location.longitude.toString()
//                    request.location =
//                            StringBuilder(latitude).append(SIGN_LOCATION).append(longitude).toString()
//                }
//                val result = domainManager.getApiRepository().sendDeviceEvent(request)
//                if (!result.isSuccessful) throw HttpException(result)
//                emit(ApiResult.success(result))
//            }
//                    .flowOn(Dispatchers.IO)
//                    .catch { e -> emit(ApiResult.error(e)) }

    private fun getMobileInfo(event: String, level: Int): LogRequest {
        return LogRequest(
                level = level,
                osVersion = Build.VERSION.SDK_INT.toString(),
                appVersion = BuildConfig.VERSION_NAME,
                deviceId = AppUtils.getAndroidID(),
                deviceTime = System.currentTimeMillis() / 1000,
                event = event,
                platform = PLATFORM_ANDROID
        )
    }

    private fun fetchDeviceData(): DeviceData {
        return DeviceData(
                getDeviceInfo(),
                getNetworkInfo(),
                getPhoneInfo(),
                getGsmInfo(),
                wifiInfoList,
                gsmLocList,
                cdmaLocList,
                gsmSignalList,
                cdmaSignalList,
                evdoSignalList
        )
    }

    fun registerListener() {
        if (!isRegisterListener) {
            isRegisterListener = true
            telephonyManager.listen(phoneStateListener, PhoneStateListener.LISTEN_CELL_INFO)
            telephonyManager.listen(phoneStateListener, PhoneStateListener.LISTEN_CELL_LOCATION)
            telephonyManager.listen(phoneStateListener, PhoneStateListener.LISTEN_SIGNAL_STRENGTHS)

            val intentFilter = IntentFilter()
            intentFilter.addAction(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION)
            App.applicationContext().registerReceiver(wifiScanReceiver, intentFilter)
            startWifiScan()
        }
    }

    fun unregisterListener() {
        if (isRegisterListener) {
            isRegisterListener = false
            telephonyManager.listen(phoneStateListener, PhoneStateListener.LISTEN_NONE)
            App.applicationContext().unregisterReceiver(wifiScanReceiver)
        }
    }

    private val phoneStateListener = object : PhoneStateListener() {
        override fun onCellLocationChanged(location: CellLocation?) {
            super.onCellLocationChanged(location)
            when (location) {
                is GsmCellLocation -> {
                    if (gsmLocList.size < 11) {
                        Timber.d("Location: $location")
                        val gsmLoc = GsmLoc(location.lac, location.cid, location.psc)
                        gsmLocList.add(gsmLoc)
                    }
                }
                is CdmaCellLocation -> {
                    if (cdmaLocList.size < 11) {
                        Timber.d("Location: $location")
                        val cdmaLoc = CdmaLoc(
                                location.baseStationId,
                                location.baseStationLatitude,
                                location.baseStationLongitude,
                                location.networkId,
                                location.systemId
                        )
                        cdmaLocList.add(cdmaLoc)
                    }
                }
            }
        }

        override fun onSignalStrengthsChanged(signalStrength: SignalStrength) {
            super.onSignalStrengthsChanged(signalStrength)
            Timber.d("onSignalStrengthsChanged: $signalStrength")
            when {
                signalStrength.isGsm -> {
                    val gsmSignal =
                            GsmSignal(signalStrength.gsmBitErrorRate, signalStrength.gsmSignalStrength)
                    gsmSignalList.add(gsmSignal)
                }
                signalStrength.cdmaDbm > 0 -> {
                    val cdmaSignal = CdmaSignal(signalStrength.cdmaDbm, signalStrength.cdmaEcio)
                    cdmaSignalList.add(cdmaSignal)
                }
                else -> {
                    val evdoSignal = EvdoSignal(
                            signalStrength.evdoDbm,
                            signalStrength.evdoEcio,
                            signalStrength.evdoSnr
                    )
                    evdoSignalList.add(evdoSignal)
                }
            }
        }
    }

    private fun startWifiScan() {
        if (!wifiManager.isWifiEnabled) {
            wifiManager.isWifiEnabled = true
        }
        wifiManager.startScan()
    }

    private val wifiScanReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val success = intent.getBooleanExtra(WifiManager.EXTRA_RESULTS_UPDATED, false)
            if (success) {
                wifiInfoList = scanSuccess()
            }
        }
    }

    private fun scanSuccess(): ArrayList<WifiInfo> {
        val wifiInfoList = arrayListOf<WifiInfo>()
        val results = wifiManager.scanResults
        results.forEach {
            val wifiInfo = WifiInfo(
                    it.SSID,
                    it.BSSID,
                    it.capabilities,
                    it.centerFreq0,
                    it.centerFreq1,
                    it.channelWidth,
                    it.frequency,
                    it.level,
                    it.is80211mcResponder,
                    it.isPasspointNetwork,
                    it.operatorFriendlyName.toString(),
                    it.venueName.toString(),
                    it.timestamp,
                    it.describeContents()
            )
            wifiInfoList.add(wifiInfo)
        }
        return wifiInfoList
    }

    private fun getDeviceInfo(): DeviceInfo {
        return DeviceInfo(
                DeviceUtils.getSDKVersionCode(),
                DeviceUtils.getSDKVersionName(),
                DeviceUtils.getAndroidID(),
                DeviceUtils.getMacAddress(),
                DeviceUtils.getManufacturer(),
                DeviceUtils.getModel(),
                DeviceUtils.getABIs().toMutableList()
        )
    }

    private fun getNetworkInfo(): NetworkInfo {
        return NetworkInfo(
                NetworkUtils.is4G(),
                NetworkUtils.isMobileData(),
                NetworkUtils.isConnected(),
                NetworkUtils.isAvailableByPing(),
                NetworkUtils.isWifiConnected(),
                NetworkUtils.isWifiAvailable(),
                NetworkUtils.getNetworkOperatorName(),
                NetworkUtils.getNetworkType(),
                NetworkUtils.getIPAddress(true),
                NetworkUtils.getIPAddress(false),
                NetworkUtils.getIpAddressByWifi(),
                NetworkUtils.getGatewayByWifi(),
                NetworkUtils.getNetMaskByWifi(),
                NetworkUtils.getServerAddressByWifi()
        )
    }

    @SuppressLint("MissingPermission")
    private fun getPhoneInfo(): PhoneInfo {
        return PhoneInfo(
                PhoneUtils.getDeviceId(),
                PhoneUtils.getSerial(),
                PhoneUtils.getIMEI(),
                PhoneUtils.getMEID(),
                PhoneUtils.getIMSI(),
                PhoneUtils.getPhoneType(),
                PhoneUtils.isSimCardReady(),
                PhoneUtils.getSimOperatorName(),
                PhoneUtils.getSimOperatorByMnc(),
                getPhoneStatus()
        )
    }

    @SuppressLint("HardwareIds")
    @RequiresPermission(READ_PHONE_STATE)
    private fun getPhoneStatus(): ArrayList<PhoneStatus> {
        val phoneStatus = PhoneStatus(
                telephonyManager.deviceId,
                telephonyManager.deviceSoftwareVersion,
                telephonyManager.line1Number,
                telephonyManager.networkCountryIso,
                telephonyManager.networkOperator,
                telephonyManager.networkOperatorName,
                telephonyManager.networkType.toString(),
                telephonyManager.phoneType.toString(),
                telephonyManager.simCountryIso,
                telephonyManager.simOperator,
                telephonyManager.simOperatorName,
                telephonyManager.simSerialNumber,
                telephonyManager.simState.toString(),
                telephonyManager.subscriberId,
                telephonyManager.voiceMailNumber
        )
        return arrayListOf(phoneStatus)
    }

    @SuppressLint("MissingPermission")
    private fun getGsmInfo(): ArrayList<GsmInfo> {
        val gsmInfoList = arrayListOf<GsmInfo>()
        val allCellInfo = telephonyManager.allCellInfo
        if (allCellInfo == null || allCellInfo.isEmpty()) return gsmInfoList
        allCellInfo.forEach {
            val type = it.toString().split(":")[0]
            Timber.d("Type : $type")
            when (type) {
                CELL_INFO_LTE -> {
                    val cellInfoLte = it as CellInfoLte
                    val cellIdentity = cellInfoLte.cellIdentity
                    val gsmInfo = GsmInfo(
                            cellIdentity.mcc.toString(),
                            cellIdentity.mnc.toString(),
                            cellIdentity.tac.toString(),
                            cellIdentity.ci.toString(),
                            (-131 + 2 * cellInfoLte.cellSignalStrength.dbm).toString()
                    )
                    gsmInfoList.add(gsmInfo)
                }
                CELL_INFO_CDMA -> {
                    val cellInfoCdma = it as CellInfoCdma
                    val cellIdentity = cellInfoCdma.cellIdentity
                    val gsmInfo = GsmInfo(
                            CDMA_MCC,
                            CDMA_MNC,
                            CDMA_LAC,
                            cellIdentity.basestationId.toString(),
                            cellInfoCdma.cellSignalStrength.dbm.toString()
                    )
                    gsmInfoList.add(gsmInfo)
                }
                CELL_INFO_GSM -> {
                    val cellInfoGsm = it as CellInfoGsm
                    val cellIdentity = cellInfoGsm.cellIdentity
                    val gsmInfo = GsmInfo(
                            cellIdentity.mcc.toString(),
                            cellIdentity.mnc.toString(),
                            cellIdentity.lac.toString(),
                            cellIdentity.cid.toString(),
                            cellInfoGsm.cellSignalStrength.dbm.toString()
                    )
                    gsmInfoList.add(gsmInfo)
                }
            }
        }
        return gsmInfoList
    }
}
