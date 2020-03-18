package com.sion.mvvm.view.splash

import com.apollographql.apollo.ApolloCall
import com.apollographql.apollo.ApolloClient
import com.apollographql.apollo.api.Response
import com.apollographql.apollo.exception.ApolloException
import com.sion.PodcastQuery
import com.sion.mvvm.view.base.BaseViewModel
import org.koin.core.inject
import timber.log.Timber

class SplashViewModel : BaseViewModel() {

    val apolloClient: ApolloClient by inject()

    fun testApollo() {
        val podcastQuery = PodcastQuery.builder().build()
        Timber.d("podcastQuery: ${podcastQuery.queryDocument()}")
        apolloClient.query(podcastQuery)
            .enqueue(object : ApolloCall.Callback<PodcastQuery.Data>() {
                override fun onFailure(e: ApolloException) {
                    e.printStackTrace()
                }

                override fun onResponse(response: Response<PodcastQuery.Data>) {
                    Timber.d("onResponse: $response")
                    val data = response.data()
                    Timber.d("data: $data")
                    if(response.hasErrors()) {
                        val error = response.errors()
                        Timber.d("error: $error")
                    }
                }

            })
    }

}