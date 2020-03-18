package com.sion.mvvm.model.vo.device

data class WifiInfo(
        val ssid: String?,
        val bssid: String?,
        val capabilities: String?,
        val centerFreq0: Int?,
        val centerFreq1: Int?,
        val channelWidth: Int?,
        val frequency: Int?,
        val level: Int?,
        val is80211mcResponder: Boolean?,
        val isPassPointNetwork: Boolean?,
        val operatorFriendlyName: String?,
        val venueName: String?,
        val timestamp: Long?,
        val describeContents: Int?
)
