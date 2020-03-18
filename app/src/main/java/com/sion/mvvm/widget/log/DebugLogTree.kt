package com.sion.mvvm.widget.log

import androidx.annotation.Nullable
import timber.log.Timber

class DebugLogTree : Timber.DebugTree() {

    val TAG_GLOBAL = "APP"

    val FORMAT_MESSAGE = "%s: %s"

    /**
     * Log format: (ClassName:lineNumber) message
     */
    override fun log(priority: Int, tag: String?, message: String, t: Throwable?) {
        var priority = priority
        var tag = tag
        var message = message

        message = String.format(FORMAT_MESSAGE, tag, message)

        tag = TAG_GLOBAL

        super.log(priority, tag, message, t)
    }

    override fun createStackElementTag(element: StackTraceElement): String? {
        return "(${element.fileName}:${element.lineNumber})"
    }

    override fun isLoggable(@Nullable tag: String?, priority: Int): Boolean {
        return super.isLoggable(tag, priority)
    }

}