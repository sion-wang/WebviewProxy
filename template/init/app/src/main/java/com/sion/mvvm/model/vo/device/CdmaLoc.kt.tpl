package {{.Project}}.model.vo.device

data class CdmaLoc(
        val stationId: Int?,
        val stationLatitude: Int?,
        val stationLongitude: Int?,
        val networkId: Int?,
        val systemId: Int?
)
