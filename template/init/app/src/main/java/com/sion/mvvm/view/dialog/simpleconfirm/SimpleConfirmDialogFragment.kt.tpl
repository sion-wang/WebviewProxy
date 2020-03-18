package {{.Project}}.view.dialog.simpleconfirm

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import {{.Project}}.databinding.FragmentSimpleConfirmDialogBinding
import {{.Project}}.view.base.BaseDialogFragment
import kotlinx.android.synthetic.main.fragment_simple_confirm_dialog.*

class SimpleConfirmDialogFragment : BaseDialogFragment<FragmentSimpleConfirmDialogBinding>() {

    companion object {
        private const val KEY_MESSAGE = "KEY_MESSAGE"
        private const val KEY_POSITIVE_BTN_TEXT = "KEY_POSITIVE_BTN_TEXT"
        private const val KEY_NEGATIVE_BTN_TEXT = "KEY_NEGATIVE_BTN_TEXT"
        fun newInstance(
            message: String,
            positiveBtnText: String,
            negativeBtnText: String,
            listener: OnSimpleDialogListener? = null
        ): SimpleConfirmDialogFragment {
            val fragment = SimpleConfirmDialogFragment()
            val args = Bundle()
            args.putString(KEY_MESSAGE, message)
            args.putString(KEY_POSITIVE_BTN_TEXT, positiveBtnText)
            args.putString(KEY_NEGATIVE_BTN_TEXT, negativeBtnText)
            fragment.arguments = args
            fragment.onSimpleDialogListener = listener
            return fragment
        }
    }

    var onSimpleDialogListener: OnSimpleDialogListener? = null

    override fun getViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?
    ): FragmentSimpleConfirmDialogBinding {
        return FragmentSimpleConfirmDialogBinding.inflate(inflater, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val message = arguments?.getString(KEY_MESSAGE)
        val positiveBtnText = arguments?.getString(KEY_POSITIVE_BTN_TEXT)
        val negativeBtnText = arguments?.getString(KEY_NEGATIVE_BTN_TEXT)

        tv_message.text = message
        btn_confirm.text = positiveBtnText
        btn_cancel.text = negativeBtnText

        btn_confirm.setOnClickListener {
            dismiss()
            onSimpleDialogListener?.onConfirm()
        }

        btn_cancel.setOnClickListener {
            dismiss()
            onSimpleDialogListener?.onCancle()
        }
    }

    override fun isFullLayout(): Boolean {
        return true
    }
}