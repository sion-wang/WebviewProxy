package com.sion.mvvm.view.base

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.viewbinding.ViewBinding
import com.afollestad.materialdialogs.MaterialDialog
import com.afollestad.materialdialogs.lifecycle.lifecycleOwner
import com.sion.mvvm.R
import com.sion.mvvm.model.enums.HttpErrorMsgType
import com.sion.mvvm.view.main.MainViewModel
import com.sion.mvvm.widget.utility.GeneralUtils
import com.kaopiz.kprogresshud.KProgressHUD
import retrofit2.HttpException

abstract class BaseFragment<B : ViewBinding> : Fragment() {

    open var mainViewModel: MainViewModel? = null
    var progressHUD: KProgressHUD? = null

    private var _binding: B? = null
    val binding get() = _binding!!

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        activity?.let {
            mainViewModel = ViewModelProvider(it).get(MainViewModel::class.java)
        }
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

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }

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
            lifecycleOwner(this@BaseFragment)
        }
    }
}
