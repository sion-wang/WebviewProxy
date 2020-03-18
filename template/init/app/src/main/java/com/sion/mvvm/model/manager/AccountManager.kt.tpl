package {{.Project}}.model.manager

import android.text.TextUtils
import {{.Project}}.model.api.ApiResult
import {{.Project}}.model.pref.Pref
import {{.Project}}.model.vo.ProfileData
import {{.Project}}.model.vo.TokenData
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import retrofit2.HttpException

class AccountManager(private val pref: Pref,
                     private val domainManager: DomainManager) {

    fun getProfile(): ProfileData? {
        return pref.profileData
    }

    private fun setupProfile(profileData: ProfileData) {
        pref.profileData = profileData
    }

    private fun clearProfile() {
        pref.clearProfile()
    }

    fun isAutoLogin(): Boolean {
        return (!TextUtils.isEmpty(pref.token.accessToken)
                && !TextUtils.isEmpty(pref.token.refreshToken))
    }

    fun setupToken(tokenData: TokenData) {
        if (TextUtils.isEmpty(tokenData.refreshToken)) {
            pref.token = TokenData(tokenData.accessToken, pref.token.refreshToken)
        } else {
            pref.token = tokenData
        }
    }

    private fun clearToken() {
        pref.clearToken()
    }

    fun refreshToken() =
            flow {
                val result =
                        domainManager.getApiRepository().refreshToken(pref.token.refreshToken)
                if (!result.isSuccessful) throw HttpException(result)
                val refreshTokenItem = result.body()?.data
                setupToken(TokenData(refreshTokenItem!!.accessToken, refreshTokenItem.refreshToken))
                emit(ApiResult.success(null))
            }
                    .flowOn(Dispatchers.IO)
                    .catch { e ->
                        emit(ApiResult.error(e))
                    }


    fun logoutLocal() {
        clearProfile()
        clearToken()
    }

}
