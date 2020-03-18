package {{.Project}}.model.pref

import com.google.gson.Gson
import {{.Project}}.model.vo.TokenData
import {{.Project}}.model.vo.ProfileData

class Pref(private val gson: Gson, preferenceFileName: String) :AbstractPref(preferenceFileName) {

    private val tokenPref = StringPref("TOKEN")
    private val aesKeyPref = StringPref("AES_KEY")
    private val ellipsizeKeyPref = BooleanPref("ELLIPSIZE_KEY")
    private val profilePref = StringPref("PROFILE")

    var token: TokenData
        get() =
            try {
                gson.fromJson(tokenPref.get(), TokenData::class.java)
            } catch (e: Exception) {
                TokenData()
            }
        set(value) {
            tokenPref.set(gson.toJson(value))
        }

    var profileData: ProfileData
        get() =
            try {
                gson.fromJson(profilePref.get(), ProfileData::class.java)
            } catch (e: Exception) {
                ProfileData()
            }
        set(value) {
            profilePref.set(gson.toJson(value))
        }

    var aesKey: String
        get() = aesKeyPref.get().toString()
        set(strAESKey) = aesKeyPref.set(strAESKey)

    var disableEllipsize: Boolean
        get() = ellipsizeKeyPref.get()
        set(disable) = ellipsizeKeyPref.set(disable)
        
    fun clearToken() {
        tokenPref.remove()
    }

    fun clearProfile() {
        profilePref.remove()
    }
}