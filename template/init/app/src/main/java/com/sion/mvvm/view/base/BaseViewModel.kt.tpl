package {{.Project}}.view.base

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import {{.Project}}.model.api.ApiResult.*
import {{.Project}}.model.api.ExceptionResult
import {{.Project}}.model.api.ExceptionResult.Crash
import {{.Project}}.model.api.ExceptionResult.HttpError
import {{.Project}}.model.manager.AccountManager
import {{.Project}}.model.manager.DeviceManager
import {{.Project}}.model.manager.DomainManager
import {{.Project}}.model.pref.Pref
import {{.Project}}.model.api.vo.LogItem
import {{.Project}}.widget.utility.AppUtils
import com.google.gson.Gson
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch
import org.koin.core.KoinComponent
import org.koin.core.inject
import timber.log.Timber

abstract class BaseViewModel : ViewModel(), KoinComponent {

    val domainManager: DomainManager by inject()
    val accountManager: AccountManager by inject()
    val deviceManager: DeviceManager by inject()
    val pref: Pref by inject()
    val gson: Gson by inject()

    private fun sendCrashReport(data: String) {
        viewModelScope.launch {
            deviceManager.sendCrashReport(data)
                    .collect {
                        when (it) {
                            is Empty -> Timber.d("SendCrashReport Complete")
                            is Error -> Timber.e("SendCrashReport Error: $it")
                        }
                    }
        }
    }

    fun sendLog(clazz: String, eventType: String, action: String, msg: String) {
        val logItem = LogItem(
                clazz = clazz,
                eventType = eventType,
                action = action,
                msg = msg,
                account = pref.profileData.account
        )
        sendLog(gson.toJson(logItem))
    }

    fun sendLog(data: String) {
        viewModelScope.launch {
            deviceManager.sendLog(data)
                    .collect {
                        when (it) {
                            is Success -> Timber.d("sendLog Success")
                            is Error -> Timber.e("sendLog Error: $it")
                        }
                    }
        }
    }

//    fun sendDeviceInfo() {
//        viewModelScope.launch {
//            deviceManager.sendDeviceInfo()
//                    .collect {
//                        when (it) {
//                            is Empty -> Timber.d("SendDeviceInfo Complete")
//                            is Error -> Timber.e("SendDeviceInfo Error: $it")
//                        }
//                    }
//        }
//    }

    fun processException(exceptionResult: ExceptionResult) {
        when (exceptionResult) {
            is Crash -> {
                sendCrashReport(AppUtils.getExceptionDetail(exceptionResult.throwable))
            }
            is HttpError -> {
                sendCrashReport(AppUtils.getExceptionDetail(exceptionResult.httpExceptionData.httpExceptionClone))
            }
        }
    }

    fun logoutLocal() {
        accountManager.logoutLocal()
    }
}