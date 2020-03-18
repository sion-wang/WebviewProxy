package com.sion.mvvm.view.splash

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.lifecycle.lifecycleScope
import com.sion.mvvm.databinding.FragmentSplashBinding
import com.sion.mvvm.view.base.BaseFragment
import com.sion.mvvm.widget.utility.ProxySettings
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.launch
import org.koin.androidx.viewmodel.ext.android.viewModel
import timber.log.Timber


class SplashFragment : BaseFragment<FragmentSplashBinding>() {


    private val viewModel by viewModel<SplashViewModel>()

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
//        binding.title.text = "Android"
//        viewModel.testApollo()

        binding.webView.webViewClient = object: WebViewClient() {
            override fun shouldInterceptRequest(
                view: WebView?,
                request: WebResourceRequest?
            ): WebResourceResponse? {
                Timber.d("InterceptRequest url: ${request?.url}")
//                val result = ProxySettings.setProxy(context, "prod-video-proxy-tw-01-private.prod.silkrode.com.tw", 8888)
                val result = ProxySettings.setProxy(context, "127.0.0.1", 8080)
                Timber.d("result: $result")
                return super.shouldInterceptRequest(view, request)
            }

            override fun shouldOverrideUrlLoading(
                view: WebView?,
                request: WebResourceRequest?
            ): Boolean {
                return super.shouldOverrideUrlLoading(view, request)
            }
        }

        lifecycleScope.launch {
            flow {
                emit(true)
                golib.Golib.start("127.0.0.1:8080")
            }.flowOn(Dispatchers.IO).collect{
                Timber.d("collect result: $it")
//                binding.webView.loadUrl("https://whatismyipaddress.com/")
                binding.webView.loadUrl("https://www.google.com/")
            }
        }
    }

    override fun getViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?
    ): FragmentSplashBinding {
        return FragmentSplashBinding.inflate(inflater, container, false)
    }
}