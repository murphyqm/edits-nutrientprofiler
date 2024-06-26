#' NPMAssess function
#'
#' This function aims to apply the various scoring functions
#' across a data.frame on a row by row basis.
#' It is expected that you would use this function in conjunction with a
#' call to `lapply` or on a single row.
#' The function returns a data.frame containing the A score, C score,
#' NPM score and NPM assessment.
#'
#' @export
#' @param row, the row from an NPMScore call
#' @return a data.frame containing A score, C score, NPM score, and NPM assessment for each row
NPMAssess <- function(row) {
    stopifnot(
        "Score columns not detected. Please ensure you have called NPMScore on your data" =
            c(
                "energy_score", "sugar_score", "satfat_score",
                "protein_score", "fvn_score", "fibre_score", "salt_score"
            ) %in% names(row)
    )

    A_score <- A_scorer(
        energy_score = row[["energy_score"]],
        sugar_score = row[["sugar_score"]],
        satfat_score = row[["satfat_score"]],
        salt_score = row[["salt_score"]]
    )

    C_score <- C_scorer(
        fvn_score = row[["fvn_score"]],
        protein_score = row[["protein_score"]],
        fibre_score = row[["fibre_score"]]
    )

    NPM_score <- NPM_total(A_score, C_score, row[["fvn_score"]], row[["fibre_score"]])

    NPM_assessment <- NPM_assess(NPM_score, row[["product_type"]])

    npm_df <- data.frame(
        "A_score" = A_score, "C_score" = C_score, "NPM_score" = NPM_score, "NPM_assessment" = NPM_assessment,
        stringsAsFactors = FALSE
    )

    return(npm_df)
}

#' A score function
#'
#' A scores are defined as the scores for
#' energy, sugars, sat fat and salt summed together
#'
#' @param energy_score, numeric value for energy score
#' @param sugar_score, numeric value for sugar score
#' @param satfat_score, numeric value for sat fat score
#' @param salt_score, numeric value for salt score
#' @return a numeric value of the A score
#' @export
A_scorer <- function(energy_score, sugar_score, satfat_score, salt_score) {
    return(sum(energy_score, sugar_score, satfat_score, salt_score))
}

#' C score function
#'
#' C score is defined as the scores for fruit/veg/nut percentage,
#' protein and fibre summed together
#'
#' @param fvn_score, numeric value for fruit/vegetables/nuts percentage score
#' @param protein_score, numeric value for protein score
#' @param fibre_score, numeric value for fibre score
#' @return a numeric value of the C score
#' @export
C_scorer <- function(fvn_score, protein_score, fibre_score) {
    return(sum(fvn_score, protein_score, fibre_score))
}

#' NPM_total
#'
#' A function to calculate total NPM score
#' Logic for this function is documented in
#' [Nutrient Profiling Technical Guidance](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/216094/dh_123492.pdf)
#' page 6.
#'
#' @param a_score, a numeric value for the A score
#' @param c_score, a numeric value for the C score
#' @param fvn_score, a numeric value for the specific score for fruit/veg/nuts percentage
#' @param fibre_score, a numeric value for the fibre score
#' @return a numeric value for the overall NPM score
#' @export
NPM_total <- function(a_score, c_score, fvn_score, fibre_score) {
    npm_score <- if (a_score >= 11 && fvn_score < 5) {
        a_score - (fvn_score + fibre_score)
    } else {
        a_score - c_score
    }
}

#' NPM Assess function
#'
#' This function takes an NPM score and returns either "PASS" or "FAIL"
#' depending on the `type` argument. Where `type` is either "food" or "drink".
#'
#' @param NPM_score, a numeric value for the NPM score
#' @param type, a character value of either "food" or "drink" to determine how to assess the score
#' @returns a character value of either "PASS" or "FAIL"
#' @export
NPM_assess <- function(NPM_score, type) {
    assessment <- switch(tolower(type),
        "food" = ifelse(NPM_score >= 4, "FAIL", "PASS"),
        "drink" = ifelse(NPM_score >= 1, "FAIL", "PASS"),
        stop(paste0(
            "NPM_assess passed invalid type: ",
            type
        ))
    )

    return(assessment)
}
