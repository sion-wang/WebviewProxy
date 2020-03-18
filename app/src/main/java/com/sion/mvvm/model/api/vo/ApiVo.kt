package com.sion.mvvm.model.api.vo

import com.google.gson.annotations.SerializedName

data class CustomCancelPaymentsReq(

    @SerializedName("id")
    var id: String = ""

)

data class CreateReceiptsCustomData(

    @SerializedName("available_balance")    //可用餘額
    var availableBalance: Long = 0,

    @SerializedName("amount")    //打單金額
    var amount: Long = 0,

    @SerializedName("count")    //欲打單次數
    var count: Long = 0

)

data class CreateReceiptsCustomResp(

    @SerializedName("large_match")    //有無拆成大單
    var largeMatch: Boolean = false,

    @SerializedName("over_quota")    //未拆單的剩餘金額
    var overQuota: Long = 0,

    @SerializedName("title")    //項目抬頭
    var title: String = "",

    @SerializedName("amount")    //欲收款金額
    var amount: Long = 0,

    @SerializedName("quota_amount")    //拆單金額
    var quotaAmount: Long = 0,

    @SerializedName("data")
    var data: ArrayList<CreateReceiptsCustomData> = arrayListOf()

)

data class CreateReceiptsPreviewCustomReq(

    @SerializedName("title")    //項目抬頭
    var title: String = "",

    @SerializedName("amount")    //欲收款金額
    var amount: Long = 0,

    @SerializedName("quota_amount")    //拆單金額
    var quotaAmount: Long = 0

)

data class CreateReceiptsCustomReq(

    @SerializedName("large_match")    //有無拆成大單
    var largeMatch: Boolean = false,

    @SerializedName("over_quota")    //未拆單的剩餘金額
    var overQuota: Long = 0,

    @SerializedName("title")    //項目抬頭
    var title: String = "",

    @SerializedName("amount")
    var amount: Long = 0,

    @SerializedName("quota_amount")    //拆單金額
    var quotaAmount: Long = 0,

    @SerializedName("data")    //收款單模板
    var data: ArrayList<CreateReceiptsCustomData> = arrayListOf()

)

data class AccountAmount(

    @SerializedName("availableBalance")
    var availableBalance: Long = 0,

    @SerializedName("amount")
    var amount: Long = 0,

    @SerializedName("count")
    var count: Int = 0

)

data class CreatePaymentsCustomReq(

    @SerializedName("data")
    var data: ArrayList<CreatePaymentsCustomData> = arrayListOf()

)

data class CreatePaymentsCustomData(

    @SerializedName("reason")
    var reason: String = "",

    @SerializedName("title")    //項目抬頭
    var title: String = "",

    @SerializedName("amount")    //欲收款金額
    var amount: Long = 0,

    @SerializedName("quota_amount")    //拆單金額
    var quotaAmount: Long = 0,

    @SerializedName("over_quota")    //未拆單的剩餘金額
    var overQuota: Long = 0,

    @SerializedName("receipt_account_id")
    var receiptAccountId: String = "",

    @SerializedName("receipt_account_name")
    var receiptAccountName: String = "",

    @SerializedName("receipt_bank_name")
    var receiptBankName: String = "",

    @SerializedName("receipt_bank_branch")
    var receiptBankBranch: String = "",

    @SerializedName("receipt_bank_code")
    var receiptBankCode: String = "",

    @SerializedName("mission_type")    //任務類型
    var missionType: Int = 0,

    @SerializedName("match")
    var match: Boolean = false,

    @SerializedName("account_amount")
    var accountAmount: ArrayList<AccountAmount> = arrayListOf()

)

data class ListPaymentsCustomReq(

    @SerializedName("page")
    var page: Long = 0,

    @SerializedName("per_page")
    var perPage: Long = 0,

    @SerializedName("id")
    var id: String = "",

    @SerializedName("state_in")
    var stateIn: ArrayList<Int> = arrayListOf(),

    @SerializedName("mission_type")
    var missionType: Int = 0,

    @SerializedName("payment_mode")
    var paymentMode: Int = 0,

    @SerializedName("complete_at")
    var completeAt: String = "",

    @SerializedName("complete_at_start")
    var completeAtStart: String = "",

    @SerializedName("complete_at_end")
    var completeAtEnd: String = "",

    @SerializedName("creator_name")
    var creatorName: String = "",

    @SerializedName("created_at")
    var createdAt: String = "",

    @SerializedName("created_at_start")
    var createdAtStart: String = "",

    @SerializedName("created_at_end")
    var createdAtEnd: String = "",

    @SerializedName("detail_id")
    var detailId: String = "",

    @SerializedName("detail_no")
    var detailNo: Int = 0,

    @SerializedName("detail_account_serial_no")
    var detailAccountSerialNo: Int = 0,

    @SerializedName("detail_account_id")
    var detailAccountId: String = "",

    @SerializedName("detail_account_name")
    var detailAccountName: String = ""

)

data class CustomPaymentMaster(

    @SerializedName("payment_mode")
    var paymentMode: Int = 0,

    @SerializedName("id")
    var id: String = "",

    @SerializedName("payable")
    var payable: Int = 0,

    @SerializedName("paid")
    var paid: Int = 0,

    @SerializedName("unmatch_amount")
    var unmatchAmount: Int = 0,

    @SerializedName("complete_at")
    var completeAt: String = "",

    @SerializedName("state")
    var state: Int = 0,

    @SerializedName("receipt_reason")
    var receiptReason: String = "",

    @SerializedName("reject_reason")
    var rejectReason: String = "",

    @SerializedName("created_at")
    var createdAt: String = "",

    @SerializedName("verifier_name")
    var verifierName: String = "",

    @SerializedName("verifier_at")
    var verifierAt: String = "",

    @SerializedName("creator_name")
    var creatorName: String = "",

    @SerializedName("updater_name")
    var updaterName: String = "",

    @SerializedName("updated_at")
    var updatedAt: String = "",

    @SerializedName("apply_count")
    var applyCount: Int = 0,

    @SerializedName("last_apply_account_at")
    var lastApplyAccountAt: String = "",

    @SerializedName("split_amount")
    var splitAmount: Int = 0

)

data class PaymentDetails(

    @SerializedName("id")
    var id: String = "",

    @SerializedName("detail_no")
    var detailNo: Int = 0,

    @SerializedName("payment_id")
    var paymentId: String = ""

)

data class CustomPaymentDetail(

    @SerializedName("id")
    var id: String = "",

    @SerializedName("detail_no")
    var detailNo: Int = 0,

    @SerializedName("payment_id")
    var paymentId: String = "",

    @SerializedName("rec_account_serial_no")
    var recAccountSerialNo: String = "",

    @SerializedName("rec_account_id")
    var recAccountId: String = "",

    @SerializedName("rec_account_name")
    var recAccountName: String = "",

    @SerializedName("rec_bank_branch")
    var recBankBranch: String = "",

    @SerializedName("rec_bank_code")
    var recBankCode: String = "",

    @SerializedName("rec_bank_name")
    var recBankName: String = "",

    @SerializedName("rec_bank_branch_region")
    var recBankBranchRegion: String = "",

    @SerializedName("rec_bank_branch_city")
    var recBankBranchCity: String = "",

    @SerializedName("pay_account_serial_no")
    var payAccountSerialNo: Int = 0,

    @SerializedName("pay_account_id")
    var payAccountId: String = "",

    @SerializedName("pay_account_name")
    var payAccountName: String = "",

    @SerializedName("pay_bank_branch")
    var payBankBranch: String = "",

    @SerializedName("pay_bank_code")
    var payBankCode: String = "",

    @SerializedName("pay_bank_name")
    var payBankName: String = "",

    @SerializedName("pay_bank_branch_region")
    var payBankBranchRegion: String = "",

    @SerializedName("pay_bank_branch_city")
    var payBankBranchCity: String = "",

    @SerializedName("customer_service_id")
    var customerServiceId: Int = 0,

    @SerializedName("state")
    var state: Int = 0,

    @SerializedName("payable")
    var payable: Int = 0,

    @SerializedName("paid")
    var paid: Int = 0,

    @SerializedName("complete_at")
    var completeAt: String = "",

    @SerializedName("created_at")
    var createdAt: String = "",

    @SerializedName("attrs")
    var attrs: ArrayList<PaymentDetailAttrs> = arrayListOf(),

    @SerializedName("transfers")
    var transfers: ArrayList<CustomTransfers> = arrayListOf()

)

data class PaymentDetailAttrs(

    @SerializedName("id")
    var id: String = ""

)

data class CustomTransfers(

    @SerializedName("id")
    var id: String = "",

    @SerializedName("payment_detail_id")
    var paymentDetailId: String = "",

    @SerializedName("trade_no")
    var tradeNo: String = "",

    @SerializedName("account_id")
    var accountId: String = "",

    @SerializedName("account_name")
    var accountName: String = "",

    @SerializedName("bank_code")
    var bankCode: String = "",

    @SerializedName("bank_name")
    var bankName: String = "",

    @SerializedName("bank_branch")
    var bankBranch: String = "",

    @SerializedName("amount")
    var amount: Int = 0,

    @SerializedName("type")
    var type: Int = 0,

    @SerializedName("attrs")
    var attrs: ArrayList<TransferAttrs> = arrayListOf(),

    @SerializedName("pay_at")
    var payAt: String = ""

)

data class TransferAttrs(

    @SerializedName("id")
    var id: String = ""

)

data class CustomListPaymentDetailsResp(

    @SerializedName("master")
    var master: CustomPaymentMaster,

    @SerializedName("detail")
    var detail: ArrayList<CustomPaymentDetail> = arrayListOf()

)

data class Excel(

    @SerializedName("id")
    var id: String = ""

)

data class ListPaymentsReq(

    @SerializedName("id")
    var id: String = ""

)

data class ListPaymentsResp(

    @SerializedName("id")
    var id: String = ""

)

data class CustomPaymentsReport(

    @SerializedName("id")
    var id: String = "",

    @SerializedName("payment_details_id")
    var paymentDetailsId: String = "",

    @SerializedName("payment_mode")
    var paymentMode: String = "",

    @SerializedName("created_at")
    var createdAt: String = "",

    @SerializedName("state")
    var state: String = "",

    @SerializedName("complete_at")    //pay payment_details.complete_at, rec pay_at
    var completeAt: String = "",

    @SerializedName("transfers_id")    //pay payment_details.payment_detail_uid, rec transfers.id
    var transfersId: String = "",

    @SerializedName("payable")
    var payable: String = "",

    @SerializedName("amount")    //pay payment_details.paid  ,rec transfers.amount
    var amount: String = "",

    @SerializedName("rec_account_serial_no")
    var recAccountSerialNo: String = "",

    @SerializedName("customer_service_id")
    var customerServiceId: String = "",

    @SerializedName("rec_bank_name")
    var recBankName: String = "",

    @SerializedName("rec_bank_branch_region")
    var recBankBranchRegion: String = "",

    @SerializedName("rec_bank_branch_city")
    var recBankBranchCity: String = "",

    @SerializedName("rec_bank_branch")
    var recBankBranch: String = "",

    @SerializedName("rec_account_name")
    var recAccountName: String = "",

    @SerializedName("rec_account_id")
    var recAccountId: String = "",

    @SerializedName("pay_bank_name")    //pay payment_details.pay_bank_name, rec transfers.bank_name
    var payBankName: String = "",

    @SerializedName("pay_bank_branch")    //pay payment_details.pay_bank_branch, rec transfers.bank_branch
    var payBankBranch: String = "",

    @SerializedName("pay_account_name")    //pay payment_details.pay_account_name, rec transfers.account_name
    var payAccountName: String = "",

    @SerializedName("pay_account_id")    //pay payment_details.pay_account_id, rec transfers.account_id
    var payAccountId: String = "",

    @SerializedName("creator_name")
    var creatorName: String = ""

)

data class RePaymentReq(

    @SerializedName("payment_id")
    var paymentId: String = ""

)
