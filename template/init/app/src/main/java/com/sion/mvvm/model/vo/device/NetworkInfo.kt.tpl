package {{.Project}}.model.vo.device

import com.blankj.utilcode.util.NetworkUtils

data class NetworkInfo(
        val is4G: Boolean?,
        val isMobileData: Boolean?,
        val isNetworkConnected: Boolean?,
        val isNetworkAvailable: Boolean?,
        val isWifiConnected: Boolean?,
        val isWifiAvailable: Boolean?,
        val networkOperatorName: String?,
        val networkType: NetworkUtils.NetworkType?,
        val ipv4: String?,
        val ipv6: String?,
        val ipWifi: String?,
        val gateway: String?,
        val netMask: String?,
        val serverAddress: String?
)
