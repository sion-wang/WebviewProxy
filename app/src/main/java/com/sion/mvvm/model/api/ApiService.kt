package com.sion.mvvm.model.api

import com.sion.mvvm.model.api.vo.*
import retrofit2.Response
import retrofit2.http.*

interface ApiService {

    /**********************************************************
     *
     *                  UI
     *
     ***********************************************************/
    // 更新Token
    @GET("v2/auth/token/refresh/{op_refresh_token}")
    suspend fun refreshToken(@Path("op_refresh_token") refreshToken: String): Response<ApiBaseItem<RefreshTokenItem>>

    /**********************************************************
     *
     *                  Other
     *
     ***********************************************************/
    // Elasticsearch Event
    @POST("publicPlatforms/v1/devicesEvent")
    suspend fun sendDeviceEvent(@Body request: DeviceEventRequest): Response<Void>

    // Send Log
    @POST("publicPlatforms/v1/mobile/logs")
    suspend fun sendLog(@Body request: LogRequest): Response<Void>

    // 取得Domain List
    @Headers("Authorization: 35ecc42a-9116-491c-ba9b-1cb153b7d39e")
    @GET("publicPlatforms/v1/domains")
    suspend fun getDomains(): Response<ApiBaseItem<ArrayList<DomainItem>>>
    

    @GET("/apis/v1/receipts")
    suspend fun customListReceipts(): Response<ListPaymentsResp>

    @POST("/apis/v1/receipts")
    suspend fun customCreateReceipts(@Body request: CreateReceiptsCustomReq, @Query("large_match") largeMatch: Boolean = false, @Query("over_quota") overQuota: Long = 0, @Query("title") title: String = "", @Query("amount") amount: Long = 0, @Query("quota_amount") quotaAmount: Long = 0, @Query("data") data: ArrayList<CreateReceiptsCustomData> = arrayListOf()): Response<Void>

    @GET("/apis/v1/receiptsx/excel")
    suspend fun customListReceiptsExcel(): Response<Excel>

    @GET("/apis/v1/receipts/{paymentID}")
    suspend fun customListReceiptDetails(@Path("paymentID") paymentID: String): Response<CustomListPaymentDetailsResp>

    @GET("/apis/v1/receipts/{paymentID}/excel/{test}")
    suspend fun customListReceiptDetailsExcel(@Path("paymentID") paymentID: String, @Path("test") test: String): Response<Excel>

    @GET("/apis/v1/payments")
    suspend fun customListPayments(): Response<ListPaymentsResp>

    @GET("/apis/v1/paymentsx/excel")
    suspend fun customListPaymentsExcel(): Response<Excel>

    @GET("/apis/v1/payments/{paymentID}")
    suspend fun customListPaymentDetails(@Path("paymentID") paymentID: String): Response<CustomListPaymentDetailsResp>

    @POST("/apis/v1/payments/{paymentID}/rePayment")
    suspend fun rePayment(@Body request: RePaymentReq, @Path("paymentID") paymentID: String, @Query("payment_id") paymentId: String = ""): Response<Void>

    @GET("/apis/v1/paymentDetails/{ID}")
    suspend fun customPaymentDetails(@Path("ID") ID: String, @Query("id") id: String = "", @Query("detail_no") detailNo: Int = 0, @Query("payment_id") paymentId: String = ""): Response<ApiBaseItem<CustomPaymentDetail>>

    @GET("/apis/v1/payments/{paymentID}/excel")
    suspend fun customListPaymentDetailsExcel(@Path("paymentID") paymentID: String): Response<Excel>

    @GET("/apis/v1/receipts/preview")
    suspend fun customPreviewCreateReceipts(): Response<ApiBaseItem<CreateReceiptsCustomResp>>

    @GET("/apis/v1/receipts/unfinished")
    suspend fun customUnfinishedReceipts(@Body request: ListPaymentsReq, @Query("id") id: String = ""): Response<ApiBaseItem<ListPaymentsResp>>

    @GET("/apis/v1/payments/unfinished")
    suspend fun customUnfinishedPayments(@Body request: ListPaymentsReq, @Query("id") id: String = ""): Response<ApiBaseItem<ListPaymentsResp>>

    @POST("/apis/v1/payments")
    suspend fun customCreatePayments(@Body request: CreatePaymentsCustomReq, @Query("data") data: ArrayList<CreatePaymentsCustomData> = arrayListOf()): Response<Void>

    @POST("/apis/v1/payments/cancel")
    suspend fun customCancelPayments(@Body request: CustomCancelPaymentsReq, @Query("id") id: String = ""): Response<Void>
}