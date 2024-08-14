create_manhattan_plot <- function(data) {
  data <- data |>
    dplyr::group_by(CHR) |>
    dplyr::summarise(chr_len = max(BP, na.rm = TRUE)) |>
    dplyr::mutate(tot = cumsum(as.numeric(chr_len)) - as.numeric(chr_len)) |>
    dplyr::left_join(data, by = "CHR") |>
    dplyr::arrange(CHR, BP) |>
    dplyr::mutate(BPcum = BP + tot)

  # Remove rows with NA values in BPcum
  data <- data |>
    dplyr::filter(!is.na(BPcum))

  axisdf <- data |>
    dplyr::group_by(CHR) |>
    dplyr::summarize(center = (max(BPcum, na.rm = TRUE) + min(BPcum, na.rm = TRUE)) / 2)

  p <- ggplot2::ggplot(data, ggplot2::aes(x = BPcum, y = -log10(P))) +
    ggplot2::geom_point(ggplot2::aes(color = as.factor(CHR)), alpha = 0.8, size = 1.3) +
    ggplot2::scale_color_manual(values = rep(c("grey", "skyblue"), 22)) +
    ggplot2::scale_x_continuous(labels = axisdf$CHR, breaks = axisdf$center) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      legend.position = "none",
      panel.border = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor.x = ggplot2::element_blank()
    )
  return(p)
}
