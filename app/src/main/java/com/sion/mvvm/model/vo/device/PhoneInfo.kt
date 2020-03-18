package com.sion.mvvm.model.vo.device

data class PhoneInfo(
        val deviceId: String?,
        val serial: String?,
        val imei: String?,
        val meid: String?,
        val imsi: String?,
        val phoneType: Int?,
        val isSimCardReady: Boolean?,
        val simOperatorName: String?,
        val simOperatorByMnc: String?,
        val phoneStatusList: ArrayList<PhoneStatus>?
)
