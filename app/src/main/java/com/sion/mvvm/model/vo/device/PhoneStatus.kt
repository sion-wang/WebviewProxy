package com.sion.mvvm.model.vo.device

data class PhoneStatus(
        val deviceId: String? = "",
        val deviceSoftwareVersion: String? = "",
        val line1Number: String? = "",
        val networkCountryIso: String? = "",
        val networkOperator: String? = "",
        val networkOperatorName: String? = "",
        val networkType: String? = "",
        val phoneType: String? = "",
        val simCountryIso: String? = "",
        val simOperator: String? = "",
        val simOperatorName: String? = "",
        val simSerialNumber: String? = "",
        val simState: String? = "",
        val subscriberId: String? = "",
        val voiceMailNumber: String? = ""
)
