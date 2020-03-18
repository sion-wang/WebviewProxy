package {{.Project}}.widget.utility

import android.util.Base64
import {{.Project}}.App
import timber.log.Timber
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

object AESUtils {

    private val keyValue = byteArrayOf(
            'd'.toByte(),
            'a'.toByte(),
            'b'.toByte(),
            'e'.toByte(),
            'n'.toByte(),
            'x'.toByte(),
            'i'.toByte(),
            'a'.toByte(),
            'n'.toByte(),
            'g'.toByte(),
            'l'.toByte(),
            'e'.toByte(),
            'g'.toByte(),
            'e'.toByte(),
            'n'.toByte(),
            'd'.toByte()
    )

    @Throws(Exception::class)
    fun hardEncrypt(cleartext: String): String {
        val rawKey = getHardRawKey()
        val result = hardEncrypt(rawKey, cleartext.toByteArray())
        return toHex(result)
    }

    @Throws(Exception::class)
    fun hardDecrypt(encrypted: String): String {
        val enc = toByte(encrypted)
        val result = hardDecrypt(enc)
        return String(result)
    }

    @Throws(Exception::class)
    private fun getHardRawKey(): ByteArray {
        val key = SecretKeySpec(keyValue, "AES")
        return key.encoded
    }

    @Throws(Exception::class)
    private fun hardEncrypt(raw: ByteArray, clear: ByteArray): ByteArray {
        val skeySpec = SecretKeySpec(raw, "AES")
        val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
        val iv = IvParameterSpec("0102030405060708".toByteArray())
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, iv)
        return cipher.doFinal(clear)
    }

    @Throws(Exception::class)
    private fun hardDecrypt(encrypted: ByteArray): ByteArray {
        val skeySpec = SecretKeySpec(keyValue, "AES")
        val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
        val iv = IvParameterSpec("0102030405060708".toByteArray())
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv)
        return cipher.doFinal(encrypted)
    }

    @Throws(Exception::class)
    fun encrypt(cleartext: String): String {
        val rawKey = getRawKey()
        val result = encrypt(rawKey, cleartext.toByteArray())
        return toHex(result)
    }

    @Throws(Exception::class)
    fun decrypt(encrypted: String): String {
        val enc = toByte(encrypted)
        val result = decrypt(enc)
        return String(result)
    }

    @Throws(Exception::class)
    private fun getRawKey(): ByteArray {
        val key = SecretKeySpec(getAESkey(), "AES")
        return key.encoded
    }

    @Throws(Exception::class)
    private fun encrypt(raw: ByteArray, clear: ByteArray): ByteArray {
        val skeySpec = SecretKeySpec(raw, "AES")
        val cipher = Cipher.getInstance("AES")
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec)
        return cipher.doFinal(clear)
    }

    @Throws(Exception::class)
    private fun decrypt(encrypted: ByteArray): ByteArray {
        val skeySpec = SecretKeySpec(getAESkey(), "AES")
        val cipher = Cipher.getInstance("AES")
        cipher.init(Cipher.DECRYPT_MODE, skeySpec)
        return cipher.doFinal(encrypted)
    }

    fun toByte(hexString: String): ByteArray {
        val len = hexString.length / 2
        val result = ByteArray(len)
        for (i in 0 until len)
            result[i] = Integer.valueOf(
                    hexString.substring(2 * i, 2 * i + 2),
                    16
            ).toByte()
        return result
    }

    fun toHex(buf: ByteArray?): String {
        if (buf == null)
            return ""
        val result = StringBuffer(2 * buf.size)
        for (i in buf.indices) {
            appendHex(result, buf[i])
        }
        return result.toString()
    }

    private const val HEX = "0123456789ABCDEF"

    private fun appendHex(sb: StringBuffer, b: Byte) {
        sb.append(HEX[b.toInt() shr 4 and 0x0f]).append(HEX[b.toInt() and 0x0f])
    }

    private fun getAESkey(): ByteArray {
        return decodeAESKey(
                if (App.pref?.aesKey!!.isBlank()) {
                    genAESKey()
                } else {
                    App.pref?.aesKey!!
                }
        )
    }

    @Throws(Exception::class)
    private fun genAESKey(): String {
        Timber.i("genAESKey")
        // Generate AES-Key
        val aesByteArray = ByteArray(16)
        val secureRandom = SecureRandom()
        secureRandom.nextBytes(aesByteArray)
        val str64 = Base64.encodeToString(aesByteArray, Base64.DEFAULT)
        App.pref?.aesKey = str64
        return str64
    }

    private fun decodeAESKey(strKey: String): ByteArray {
        return Base64.decode(strKey, Base64.DEFAULT)
    }
}