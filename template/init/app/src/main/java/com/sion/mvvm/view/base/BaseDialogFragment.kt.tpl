package {{.Project}}.view.base

import android.app.Dialog
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.*
import androidx.fragment.app.DialogFragment
import androidx.viewbinding.ViewBinding
import com.afollestad.materialdialogs.MaterialDialog
import com.afollestad.materialdialogs.lifecycle.lifecycleOwner
import {{.Project}}.R
import {{.Project}}.model.enums.HttpErrorMsgType
import {{.Project}}.widget.utility.GeneralUtils
import com.kaopiz.kprogresshud.KProgressHUD
import retrofit2.HttpException

abstract class BaseDialogFragment<B : ViewBinding> : DialogFragment() {

    var progressHUD: KProgressHUD? = null

    private var _binding: B? = null
    val binding get() = _binding!!

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val dialog = super.onCreateDialog(savedInstanceState)
        dialog.window!!.requestFeature(Window.FEATURE_NO_TITLE)
        return dialog
    }

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        _binding = getViewBinding(inflater, container)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        progressHUD = KProgressHUD.create(context)
                .setStyle(KProgressHUD.Style.SPIN_INDETERMINATE)
    }

    override fun onStart() {
        super.onStart()
        if (dialog != null) {
            if (isFullLayout()) {
                dialog!!.window!!.setLayout(
                        WindowManager.LayoutParams.MATCH_PARENT,
                        WindowManager.LayoutParams.MATCH_PARENT
                )
                dialog!!.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
            } else {
                val widthPixels = (resources.displayMetrics.widthPixels * 0.8).toInt()
                dialog!!.window!!.setLayout(widthPixels, ViewGroup.LayoutParams.WRAP_CONTENT)
                dialog!!.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
            }
        }
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }

    abstract fun isFullLayout(): Boolean

    abstract fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?): B

    fun showHttpErrorDialog(type: HttpErrorMsgType = HttpErrorMsgType.API_FAILED) {
        when (type) {
            HttpErrorMsgType.API_FAILED -> showErrorDialog(getString(R.string.api_failed_msg))
            HttpErrorMsgType.CHECK_NETWORK -> showErrorDialog(getString(R.string.server_error))
        }
    }

    fun showHttpErrorToast(e: HttpException) {
        GeneralUtils.showToast(context!!, "$e")
    }

    fun showErrorDialog(message: String) {
        MaterialDialog(context!!).show {
            cancelable(false)
            message(text = message)
            positiveButton(R.string.confirm) { dialog ->
                dialog.dismiss()
            }
            lifecycleOwner(this@BaseDialogFragment)
        }
    }
}