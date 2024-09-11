#' Ontario Municipal Boundaries
#' 
#' Simplified boundaries for all Ontario municipalities.
#' @rdname on_municipal_boundaries
#' @name on_municipal_boundaries
#' @source Land Information Ontario (LIO) via Ontario GeoHub:
#' \describe{
#'   \item{LT/ST}{
#'     \href{https://geohub.lio.gov.on.ca/datasets/64fb702e16204c3e88b528d9759f1174_14/about}{Municipal Boundaries (Lower and Single Tier)}
#'   }
#'   \item{UT/D}{
#'     \href{https://geohub.lio.gov.on.ca/datasets/11be9127e6ae43c4850793a3a2ee943c_13/about}{Municipal Boundaries (Upper and District)}
#'   }
#' }
#' @description 
#' Raw data, available from the source links below, represent boundaries at a much higher resolution, 
#' and include separate entries for mainland, island, and water areas within municipalities.
#' The combined data are simplified using `rmapshaper::ms_simplify` with a `keep` value of 0.001.
#' After simplification, boundaries internal to municipalities are dissolved using `rmapshaper::ms_dissolve`.
#' @format ## `on_municipal_boundaries`
#' A 'simple features collection' (sf) with 657 rows and 4 columns:
#' \describe{
#'   \item{\code{munid} \code{<chr>}}{Municipality ID (linkable)}
#'   \item{\code{municipality} \code{<chr>}}{Municipality name (esoteric)}
#'   \item{\code{tier_code} \code{<fct>}}{
#'     Tier code for the municipality. One of: 
#'     \describe{
#'       \item{\code{D}}{District}
#'       \item{\code{UT}}{Upper Tier Municipality}
#'       \item{\code{LT}}{Lower Tier Municipality}
#'       \item{\code{ST}}{Single Tier Municipality}}}
#'   \item{\code{geometry} \code{<sfc_MULTIPOLYGON>}}{Geometry of the municipality}}
NULL

#' @rdname on_municipal_boundaries
#' @name on_municipal_boundaries_dry
#' @description code{on_municipal_boundaries_dry} land-only boundaries for all Ontario municipalities
"on_municipal_boundaries_dry"

#' @rdname on_municipal_boundaries
#' @name on_municipal_boundaries_wet
#' @description \code{on_municipal_boundaries_wet} combined land and water boundaries for all Ontario municipalities
"on_municipal_boundaries_wet"