#!/usr/bin/env Rscript

# Run this line in the terminal first:
## ln -s ../../pre-commit.sh .git/hooks/pre-commit

if (!requireNamespace("readxl")) { install.packages("readxl") }
if (!requireNamespace("readr")) { install.packages("readr") }


write_each_sheet_to_csv <- function(path, sheet) {
  form_name <- gsub("\\.XLS|\\.xls", "", basename(path))
  
  new_path <- file.path(
    dirname(path), "csv"
  )
  
  if (!dir.exists(new_path)) { dir.create(new_path) }
  
  readr::write_csv(
    readxl::read_excel(path, sheet), 
    path = file.path(new_path, paste0(form_name, "_", sheet, ".csv")), 
    na = "",
    )
  
  invisible()
}

write_xls_to_csv <- function(path) {
  sheets <- readxl::excel_sheets(path)
  
  lapply(
    sheets,
    write_each_sheet_to_csv,
    path = path
    )
  
  invisible()
}

xls_files <- list.files(
  ".", 
  pattern = "\\.XLS$|\\.xls$",
  full.names = T
)

lapply(xls_files, write_xls_to_csv)

system2("git", "add -- './csv/*.csv'")