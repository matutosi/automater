#' Make shortcut using WsShell on Windows
#' 
#' See detail in the URL below.
#' https://learn.microsoft.com/troubleshoot/windows-client/admin-development/create-desktop-shortcut-with-wsh
#' 
#' @name make_shortcut
#' @param exe,shortcut,dir,arg,wd  A string of exe file, shortcut name, directory of shortcut, 
#'                                 command line arguments, and working directory.
#' @param new_path                  A string of path to add.
#' @return size  A numeric for window size. 1: normal, 3: max, 7: min.
#' @return make_shortcut() returns A list including shortcut path, and result of shell(), 
#'         add_path() returns A result of shell().
#' @examples
#' library(magrittr)
#' exe <- fs::path(Sys.getenv("R_HOME"), "bin/x64/Rgui.exe")
#' shortcut <- "r"
#' arg <- "--no-restore --no-save --sdi --silent"
#' wd <- Sys.getenv("R_USER")
#' make_shortcut(exe, shortcut = shortcut, arg = arg, wd = wd)
#' 
#' @export
make_shortcut <- function(exe, shortcut = NULL, dir = NULL,
                          arg = NULL, size = 1, wd = NULL){
  exe <- double_quote(exe)
  if(is.null(dir)){
    dir <- fs::path(Sys.getenv("USERPROFILE"), "shortcut")
    if(!fs::dir_exists(dir)){
      fs::dir_create(dir)
    }
  }else{
    if(!fs::dir_exists(dir)){
      stop("directory ", dir, " not found!")
    }
  }
  if(is.null(shortcut)){
    shortcut <- fs::path_file(exe)
  }
  shortcut <- 
    fs::path(dir, shortcut) %>%
    fs::path_ext_set("lnk") %>%
    double_quote()
  wsh    <- paste0("$WsShell = New-Object -ComObject WScript.Shell;")
  create <- paste0("$Shortcut = $WsShell.CreateShortcut(", shortcut, ");")
  target <- paste0("$Shortcut.TargetPath = ", exe, ";")
  icon   <- paste0("$Shortcut.IconLocation = ", exe, ";")
  size   <- paste0("$ShortCut.WindowStyle = ", size, ";")
  if(!is.null(arg)){ # command line arguments
    arg <- double_quote(arg)
    arg <- paste0("$ShortCut.Arguments = ", arg, ";")
  }
  if(!is.null(wd)){ # working directory
    wd <- double_quote(wd)
    wd <- paste0("$ShortCut.WorkingDirectory = ", wd, ";")
  }
  finish <- "$Shortcut.Save()"
  input <- paste0(wsh, create, target, icon, size, arg, wd, finish)
  cmd <- "powershell"
  res <- shell(cmd, input = input, intern = TRUE)
  shortcut <- stringr::str_remove_all_all(shortcut, "\"")
  return(list(shortcut = shortcut, res = res))
}


#' Add path on Windows
#' 
#' @rdname make_shortcut
#' @export
add_path <- function(new_path){
  #   if(!fs::dir_exists(dir)){
  #     stop("path ", new_path, " not found!")
  #   }
  cmd <- 'reg query "HKEY_CURRENT_USER\\Environment" /v "path"'
  path <- 
    shell(cmd, intern = TRUE)[3] %>%
    stringr::str_remove(" *path *REG_[A-z]* *") %>%
    double_quote()
  cmd <- paste0("setx path ", normalizePath(new_path), ";", path)
  shell(cmd, intern = TRUE)
}
