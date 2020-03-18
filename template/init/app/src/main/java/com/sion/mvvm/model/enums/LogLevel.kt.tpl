package {{.Project}}.model.enums

// Log Level (0:Debug | 1:Info | 2:Warn | 3:Error | 4:Panic | 5:Fatal)
enum class LogLevel(val value: Int) {
    DEBUG(0),
    INFO(1),
    WARN(2),
    ERROR(3),
    PANIC(4),
    FATAL(5);

    fun getString(): String {
        return when (this) {
            DEBUG -> "app_debug"
            INFO -> "app_info"
            WARN -> "app_warn"
            ERROR -> "app_error"
            PANIC -> "app_panic"
            FATAL -> "app_fatal"
        }
    }
}