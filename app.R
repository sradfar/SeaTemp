options(rsconnect.max.bundle.size = 8148728000)

library(shiny)
library(dplyr)
library(lubridate)

# Define the UI
ui <- fluidPage(
  titlePanel("SeaTemp: SST Download Assistant"),
  
  # Use fluidRow and column to create a two-column layout
  fluidRow(
    column(4,
           img(src = "oisst-removebg-preview.png", height = '400px', width = '400px'),
           tags$br(),  # Add space after image
           tags$br(),  # Add an additional line break if more space is needed
           
           tags$p("This app allows users to download NOAA OISST data by selecting a date range. 
           The current version of the app has been launched for downloading", strong("NOAA OISST 
                  v2.1 daily sea surface temperature data"), "in NetCDF format."),
           tags$p("You can find the dataset description at:", 
                  a(href = "https://www.ncei.noaa.gov/products/optimum-interpolation-sst", 
                    "https://www.ncei.noaa.gov/products/optimum-interpolation-sst", target = "_blank")),
           
           tags$br(),  # Space before "Developed by"
           tags$p(strong("Developed by,")),
           
           tags$p(strong("Soheil Radfar")),
           
           tags$p("Postdoctoral Fellow | Department of Civil, Construction, and Environmental Engineering,
                  The University of Alabama, Tuscaloosa, AL, USA"),
           
           tags$p("Email: ", 
                  a(href = "mailto:sradfar@ua.edu", "sradfar@ua.edu", target = "_blank"))
           
    ),
    
    # Right column
    column(8,
           # URL verification box
           wellPanel(
             tags$style(type = 'text/css', ".well { background-color: #f5f5f5; }"),
             tags$h4("URL Verification", style = "color: #333;"),
             textOutput("defaultUrl"),
             checkboxInput("customUrlCheck", "I have a different URL", FALSE),
             conditionalPanel(
               condition = "input.customUrlCheck == true",
               textInput("customUrl", "Enter your custom URL", value = "https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr/")
             )
           ),
           
           # Time and download box
           wellPanel(
             tags$h4("Select Date and Download", style = "color: #333;"),
             dateInput('startDate', 'Start Date', value = Sys.Date() - 30),
             dateInput('endDate', 'End Date', value = Sys.Date()),
             actionButton("downloadBtn", "Download Data"),
             textOutput("downloadStatus")
           ),
           
           # Guide for finding temp directory
           wellPanel(
             tags$h4("Finding Your Temp Directory", style = "color: #333;"),
             tags$p("After downloading, files are saved as a subfolder in your system's temporary ('temp') directory. To find this location:"),
             tags$ul(
               tags$li("On Windows, press Win+R, type ", tags$code("%temp%"), ", and press Enter."),
               tags$li("On macOS, open Terminal and type ", tags$code("echo $TMPDIR"), ", then press Enter."),
               tags$li("On Linux, open Terminal and type ", tags$code("echo $TMPDIR"), " or ", tags$code("echo $TEMP"), ", then press Enter.")
             ),
             tags$p("Note: Paths may vary based on system configuration and user permissions.")
           )
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  output$defaultUrl <- renderText({
    "The default URL is: https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr/"
  })
  
  observeEvent(input$downloadBtn, {
    # Determine the base URL to use
    OISST_base_url <- if (input$customUrlCheck && input$customUrl != "") {
      input$customUrl  # Use custom URL if provided
    } else {
      "https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr/"  # Default URL
    }
    
    # Generate file URLs
    OISST_dates <- data.frame(t = seq(as.Date(input$startDate), as.Date(input$endDate), by = "day"))
    OISST_files <- OISST_dates %>% 
      mutate(t_day = gsub("-", "", as.character(t)),
             t_month = substr(t_day, 1, 6),
             file_name = paste0(OISST_base_url, t_month, "/", "oisst-avhrr-v02r01.", t_day ,".nc"))
    
    file_urls <- OISST_files$file_name
    total_files <- length(file_urls)  # Total number of files to be downloaded
    
    # Create subfolder
    subfolder <- file.path(tempdir(), "oisst", paste0(format(input$startDate, "%Y%m%d"), "_", format(input$endDate, "%Y%m%d")))
    dir.create(subfolder, recursive = TRUE, showWarnings = FALSE)
    
    # Initialize progress bar
    output$downloadStatus <- renderText({ "Preparing to download..." })
    
    # Download data directly to subfolder
    withProgress(message = 'Downloading in progress', value = 0, {
      for (i in seq_along(file_urls)) {
        tryCatch({
          url <- file_urls[i]
          progress_percentage <- (i - 1) / total_files * 100  # Calculate progress percentage
          progress_message <- sprintf("(%.1f%%)\nDownloading:\n%s", progress_percentage, basename(url))
          setProgress((i - 1) / total_files, detail = progress_message)
          destfile <- file.path(subfolder, basename(url))
          download.file(url, destfile, method = "libcurl", quiet = TRUE)
          setProgress(i / total_files)  # Update progress after download
        }, error = function(e) {
          cat("Error downloading file: ", url, "\n")
        })
      }
    })
    
    # Display completion message and open the folder
    output$downloadStatus <- renderText({
      # Split the path into components
      path_parts <- unlist(strsplit(subfolder, split = "/"))
      
      # Extract relevant parts
      temp_folder_name <- path_parts[length(path_parts) - 2]
      oisst_folder_name <- path_parts[length(path_parts) - 1]
      date_folder_name <- path_parts[length(path_parts)]
      
      # Construct the message
      paste("Download complete. Go to '", temp_folder_name, "' folder in your temp directory, then open '", 
            oisst_folder_name, "' folder and locate subfolder '", date_folder_name, "' that contains your data.", sep = "")
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)