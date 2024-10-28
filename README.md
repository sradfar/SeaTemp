# SeaTemp: SST Download Assistant

The **SeaTemp: SST Download Assistant** is a user-friendly R Shiny app designed to help users download NOAA OISST v2.1 sea surface temperature (SST) data in NetCDF format. This tool is particularly useful for researchers and analysts working on SST anomaly studies, marine heatwave detection, and oceanic climate research.

![SeaTemp Screenshot](https://github.com/sradfar/SeaTemp/blob/main/SeaTemp.jfif)

## About the NOAA OISST Dataset

The NOAA OISST v2.1 dataset provides daily global sea surface temperature data from **September 1, 1981**, updated continuously at a 0.25° resolution. It is widely used for analyzing SST anomalies and marine heatwaves.

## Key Features

- **Visual and Interactive Interface**: Simplifies the process of selecting dates and verifying URLs for data download.
- **URL Verification**: Provides the current storage link by default and allows users to specify a custom URL if needed.
- **Custom Date Range**: Easily select the start and end dates for downloading specific daily SST data.
- **User Guidance**: Built-in instructions and progress indicators to enhance the download experience.
  
## Future Plans

Future versions of the app may include a feature to select a specific geographic domain by specifying latitude and longitude bounds, making it even more versatile for regional studies.

## Usage Instructions

1. **Open the App**: Start the app by running the R Shiny app locally or accessing it through a hosted link (e.g., [https://lnkd.in/e3GpRiPG](https://lnkd.in/e3GpRiPG)).
2. **URL Verification**: Check the default NOAA OISST URL or enter a custom URL if required.
3. **Select Dates**: Choose the start and end dates to specify the range for downloading SST data.
4. **Download Data**: Click the "Download Data" button, and files will be saved to a temporary directory on your system.
5. **Access Downloaded Files**: Instructions are provided within the app for locating the download directory on Windows, macOS, and Linux systems.

## Finding the Temporary Directory

- **Windows**: Press Win+R, type `%temp%`, and press Enter.
- **macOS**: Open Terminal and type `echo $TMPDIR`, then press Enter.
- **Linux**: Open Terminal and type `echo $TMPDIR` or `echo $TEMP`, then press Enter.

_Note: The exact path may vary depending on system configuration and permissions._

## Developer

Developed by **Soheil Radfar**  
**Postdoctoral Fellow**  
**Department of Civil, Construction, and Environmental Engineering**  
**The University of Alabama, Tuscaloosa, AL, USA**  
Email: [sradfar@ua.edu](mailto:sradfar@ua.edu)

## License

This project is licensed under the MIT License.
