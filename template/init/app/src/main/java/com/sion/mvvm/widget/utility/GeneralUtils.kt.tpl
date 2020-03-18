package {{.Project}}.widget.utility

import android.content.Context
import android.graphics.Bitmap
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.fragment.app.FragmentActivity
import com.blankj.utilcode.util.EncodeUtils
import com.blankj.utilcode.util.ImageUtils
import {{.Project}}.App
import {{.Project}}.model.manager.DeviceManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch
import org.koin.core.KoinComponent
import org.koin.core.inject
import timber.log.Timber
import kotlin.math.floor
import kotlin.math.sqrt

object GeneralUtils : KoinComponent {

    private val deviceManager: DeviceManager by inject()

    fun showToast(context: Context, text: String) {
        Toast.makeText(context, text, Toast.LENGTH_SHORT).show()
    }

    fun hideKeyboard(activity: FragmentActivity) {
        val view = activity.currentFocus
        if (view != null) {
            val inputManager =
                    activity.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            inputManager.hideSoftInputFromWindow(view.windowToken, 0)
        }
    }

    fun showKeyboard(context: Context, editText: View) {
        val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.showSoftInput(editText, InputMethodManager.SHOW_FORCED)
    }

    fun getEllipsizeString(text: String, startIndex: Int = 2, endIndex: Int = 2): String {
        Timber.i("Disable ellipsize :${App.pref?.disableEllipsize}")
        val disableEllipsize = App.pref?.disableEllipsize
        if (disableEllipsize != null && disableEllipsize) return text

        var ellipsize = ""

        if (text.length == 2) {
            ellipsize = "${text[0]}*"
        } else {
            text.forEachIndexed { index, char ->
                ellipsize += if (index < startIndex || index >= text.length - endIndex) {
                    char.toString()
                } else {
                    "*"
                }
            }
        }
        return ellipsize
    }

    fun bitmapToBase64(bitmap: Bitmap): String {
        val bytes = ImageUtils.bitmap2Bytes(bitmap, Bitmap.CompressFormat.PNG)
        return EncodeUtils.base64Encode2String(bytes)
    }

    fun bitmapCompress(bitmap: Bitmap, maxSizeInKB: Int): Bitmap {
        val currentWidth: Int = bitmap.width
        val currentHeight: Int = bitmap.height
        val currentPixels = currentWidth * currentHeight
        // Get the amount of max pixels:
        // 1 pixel = 4 bytes (R, G, B, A)
        val maxPixels = 1024 * 1024 * (maxSizeInKB / 1000.0) / 4 // Floored

        if (currentPixels <= maxPixels) { // Already correct size:
            return bitmap
        }
        // Scaling factor when maintaining aspect ratio is the square root since x and y have a relation:
        val scaleFactor = sqrt(maxPixels / currentPixels.toDouble())
        val newWidthPx = floor(currentWidth * scaleFactor).toInt()
        val newHeightPx = floor(currentHeight * scaleFactor).toInt()
        CoroutineScope(Dispatchers.IO).launch {
            deviceManager.sendLog("bitmapCompress compress to $maxSizeInKB KB. Scaled bitmap sizes are $newWidthPx x $newHeightPx when original sizes are $currentWidth x $currentHeight and currentPixels $currentPixels and maxPixels $maxPixels and scaled total pixels are: ${newWidthPx * newHeightPx}")
                    .collect()
        }
        return Bitmap.createScaledBitmap(bitmap, newWidthPx, newHeightPx, true)
    }
}