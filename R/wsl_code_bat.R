#' wsl_vscode_bat
#' 
#' Creates a .bat file that opens a Windows directory in WSL (mounted) and launches Visual Studio Code in that directory.
#' @param path Path to the Windows directory to open in WSL and launch Visual Studio Code.
#' @export
wsl_vscode_bat <- function(path) {
   bat_path <- system.file("wsl_code.bat", package = "snipe")

    # Ensure path is a folder
    if (tools::file_ext(path) != "") {
        stop("Path must be a folder.")
    }

    # check if environment is wsl
    if (Sys.getenv("WSL_DISTRO_NAME") != "") {
        # convert windows path to wsl path
        path <- gsub("C:/", "/mnt/c/", path)
    }
    # copy bat to location
   success <- file.copy(bat_path, paste0(path,"/wsl_code.bat"), overwrite = FALSE)
   if(success){
        message("wsl_code.bat created successfully.")
   }else{
        message("wsl_code.bat couldn't be created")
   } 
    
}

#' wsl_nvim_bat
#'
#' Creates a .bat file that opens a Windows directory in WSL (mounted) and launches Neovim in that directory.
#' @param path Path to the Windows directory to open in WSL and launch Neovim.
#' @export

wsl_nvim_bat <- function(path) {
   bat_path <- system.file("wsl_nvim.bat", package = "snipe")

    # Ensure path is a folder
    if (tools::file_ext(path) != "") {
        stop("Path must be a folder.")
    }

    # check if environment is wsl
    if (Sys.getenv("WSL_DISTRO_NAME") != "") {
        # convert windows path to wsl path
        path <- gsub("C:/", "/mnt/c/", path)
    }
    # copy bat to location
   success <- file.copy(bat_path, paste0(path,"/wsl_nvim.bat"), overwrite = FALSE)
   if(success){
        message("wsl_nvim.bat created successfully.")
   }else{
        message("wsl_nvim.bat couldn't be created")
   } 
    
}


