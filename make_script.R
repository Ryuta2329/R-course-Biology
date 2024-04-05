library(ymlthis)
library(fs)

# Creando Directorio Principal
project_path <- path(getwd(), "R_Course")

# Crea el Proyecto
usethis::create_project(project_path, rstudio = FALSE)

# Finaliza la creación de otros directorios y archivos importantes
fig_dir <- dir_create(path(course_dir, "fig"))
tex_dir <- dir_create(path(course_dir, "latex"))
output_dir <- dir_create(path(course_dir, "docs"))

# Aqui deberia crear un ReadMe.md
usethis::use_readme_md() # Añade contenido

# Encabezados
rcourse_yml <- yml_empty() %>% 
  yml_title("R para Biologos.") %>%
  yml_subtitle("Yet Another Course on R!") %>%
  yml_author("Marcelo J. Molinatti", email="molinatti.marc.029@gmail.com") %>%
  yml_date(format(Sys.Date(), "%B %d, %Y")) %>%
  yml_toc(toc=TRUE, toc_depth=2, toc_title="Índice.") %>%
  yml_latex_opts(
    fontsize = "12pt",
    geometry = c("left=3cm", "right=3cm", "top=2.5cm", "bottom=2.5cm"),
    lof = FALSE, lot = FALSE,
    linestretch = 1.5, 
    secnumdepth = 2, 
    colorlinks = TRUE, 
    natbiboptions = c("authoryear", "comma")) %>%
  yml_citations(
    bibliography = fs::path_rel(here::here("latex", "RCourseRefs.bib")),
    biblio_style = "apalike", 
    biblio_title = "Referencias",  
    link_citations = TRUE,
    nocite = "@*") %>%
  yml_bookdown_opts(
    book_filename = "R-Biologos",
    rmd_files = c("index.Rmd", list.files(here::here(), pattern = ".Rmd")),
    output_dir = fs::path_rel(here::here("docs"))
  ) %>%
  yml_lang("es-ES")

# Creo archivo _bookdown.yml
rcourse_yml %>% 
  use_bookdown_yml(path = here::here())

# Creo archivo _output.yml
rcourse_yml %>%
  yml_output(
    bookdown::gitbook(
      split_by = "section",
      split_bib = TRUE
    ),
    bookdown::pdf_book()
  ) %>% 
  use_output_yml(path = here::here())

# Creando index.Rmd
index_file <- file_create(here::here("index.Rmd"))
cat("# Prefacio {-}", file = index_file, sep = "\n\n")

# Renderizado
bookdown::render_book(here::here("index.Rmd"))