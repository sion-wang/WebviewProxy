package {{.Project}}.model.api

import {{.Project}}.BuildConfig
import {{.Project}}.widget.utility.AESUtils

object DomainInfo {

    private fun da(): String = "50ABA922F8FFE66A22E220112AEAC2A2679BE8DDA8273F86658D598C1450371E"
    private fun ben(): String = "6F622E3052228C27549638184693C780F02FB162E5D4658F692E2624E6F48E62"

    const val FLAVOR_DEV = "dev"
    const val FLAVOR_SIT = "sit"

    fun getDomain(): List<String> {
        return when (BuildConfig.FLAVOR) {
            FLAVOR_DEV,
            FLAVOR_SIT -> mutableListOf(BuildConfig.API_HOST)
            else -> getProdDomain()
        }
    }

    private fun getProdDomain(): List<String> {
        val arrayList: MutableList<String> = mutableListOf()
        arrayList.add(AESUtils.hardDecrypt(da()))
        arrayList.add(AESUtils.hardDecrypt(ben()))
        return arrayList
    }
}
