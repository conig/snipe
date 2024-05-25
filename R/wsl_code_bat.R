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
   file.copy(bat_path, paste0(path,"/wsl_code.bat"), overwrite = FALSE)
}