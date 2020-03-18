package com.sion.mvvm.model.api

import com.sion.mvvm.model.api.vo.*
import retrofit2.Response

class ApiRepository(private val apiService: ApiService) {

    companion object {
        const val X_APP_VERSION = "x-app-version"
        const val X_REQUEST_ID = "x-request-id"
        const val BEARER = "Bearer "
        const val AUTHORIZATION = "Authorization"
        const val MEDIA_TYPE_JSON = "application/json"

        fun isRefreshTokenFailed(code: String?): Boolean {
            return code == ErrorCode.TOKEN_NOT_FOUND
        }
    }

    /**********************************************************
     *
     *                  UI
     *
     ***********************************************************/
    // 更新Token
    suspend fun refreshToken(token: String): Response<ApiBaseItem<RefreshTokenItem>> {
        return apiService.refreshToken(token)
    }

    /**********************************************************
     *
     *                  Other
     *
     ***********************************************************/
    // Elasticsearch Event
    suspend fun sendDeviceEvent(request: DeviceEventRequest): Response<Void> {
        return apiService.sendDeviceEvent(request)
    }

    // Send Log
    suspend fun sendLog(request: LogRequest): Response<Void> {
        return apiService.sendLog(request)
    }

    suspend fun getDomains(): Response<ApiBaseItem<ArrayList<DomainItem>>> {
        return apiService.getDomains()
    }


    suspend fun customListReceipts(): Response<ListPaymentsResp> {
        return apiService.customListReceipts()  
    }

    suspend fun customCreateReceipts(request: CreateReceiptsCustomReq, largeMatch: Boolean = false, overQuota: Long = 0, title: String = "", amount: Long = 0, quotaAmount: Long = 0, data: ArrayList<CreateReceiptsCustomData> = arrayListOf()): Response<Void> {
        return apiService.customCreateReceipts(request, largeMatch, overQuota, title, amount, quotaAmount, data)  
    }

    suspend fun customListReceiptsExcel(): Response<Excel> {
        return apiService.customListReceiptsExcel()  
    }

    suspend fun customListReceiptDetails(paymentID: String): Response<CustomListPaymentDetailsResp> {
        return apiService.customListReceiptDetails(paymentID)  
    }

    suspend fun customListReceiptDetailsExcel(paymentID: String, test: String): Response<Excel> {
        return apiService.customListReceiptDetailsExcel(paymentID, test)  
    }

    suspend fun customListPayments(): Response<ListPaymentsResp> {
        return apiService.customListPayments()  
    }

    suspend fun customListPaymentsExcel(): Response<Excel> {
        return apiService.customListPaymentsExcel()  
    }

    suspend fun customListPaymentDetails(paymentID: String): Response<CustomListPaymentDetailsResp> {
        return apiService.customListPaymentDetails(paymentID)  
    }

    suspend fun rePayment(request: RePaymentReq, paymentID: String, paymentId: String = ""): Response<Void> {
        return apiService.rePayment(request, paymentID, paymentId)  
    }

    suspend fun customPaymentDetails(ID: String, id: String = "", detailNo: Int = 0, paymentId: String = ""): Response<ApiBaseItem<CustomPaymentDetail>> {
        return apiService.customPaymentDetails(ID, id, detailNo, paymentId)  
    }

    suspend fun customListPaymentDetailsExcel(paymentID: String): Response<Excel> {
        return apiService.customListPaymentDetailsExcel(paymentID)  
    }

    suspend fun customPreviewCreateReceipts(): Response<ApiBaseItem<CreateReceiptsCustomResp>> {
        return apiService.customPreviewCreateReceipts()  
    }

    suspend fun customUnfinishedReceipts(request: ListPaymentsReq, id: String = ""): Response<ApiBaseItem<ListPaymentsResp>> {
        return apiService.customUnfinishedReceipts(request, id)  
    }

    suspend fun customUnfinishedPayments(request: ListPaymentsReq, id: String = ""): Response<ApiBaseItem<ListPaymentsResp>> {
        return apiService.customUnfinishedPayments(request, id)  
    }

    suspend fun customCreatePayments(request: CreatePaymentsCustomReq, data: ArrayList<CreatePaymentsCustomData> = arrayListOf()): Response<Void> {
        return apiService.customCreatePayments(request, data)  
    }

    suspend fun customCancelPayments(request: CustomCancelPaymentsReq, id: String = ""): Response<Void> {
        return apiService.customCancelPayments(request, id)  
    }
}

