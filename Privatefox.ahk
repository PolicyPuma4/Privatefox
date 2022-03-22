; Created by https://github.com/PolicyPuma4
; Official repository https://github.com/PolicyPuma4/Privatefox

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;@Ahk2Exe-ExeName Privatefox.exe
;@Ahk2Exe-SetMainIcon firefox_2.ico

EnvGet, LOCALAPPDATA, LOCALAPPDATA
EnvGet, PROGRAMS, PROGRAMFILES
FLAG := A_Args[1]

INSTALL_PATH := LOCALAPPDATA "\Programs\Privatefox"
INSTALL_FULL_PATH := INSTALL_PATH "\Privatefox.exe"
if (not FLAG)
{
  FileCreateDir, % INSTALL_PATH
  FileCopy, % A_ScriptFullPath, % INSTALL_FULL_PATH

  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Privatefox, DisplayIcon, % """" INSTALL_FULL_PATH """"
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Privatefox, DisplayName, Privatefox
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Privatefox, InstallLocation, % """" INSTALL_PATH """"
  RegWrite, REG_DWORD, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Privatefox, NoModify, 0x00000001
  RegWrite, REG_DWORD, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Privatefox, NoRepair, 0x00000001
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Privatefox, UninstallString, % """" INSTALL_FULL_PATH """ uninstall"

  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\RegisteredApplications, Privatefox, Software\Clients\StartMenuInternet\Privatefox\Capabilities

  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Classes\PrivatefoxHTML, , Privatefox HTML Document
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Classes\PrivatefoxHTML\Application, ApplicationName, Privatefox
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Classes\PrivatefoxHTML\Application, ApplicationDescription, Redirects opened URLs and files in Firefox Private Browsing.
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Classes\PrivatefoxHTML\shell\open\command, , % """" INSTALL_FULL_PATH """ redirect ""`%1"""

  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Clients\StartMenuInternet\Privatefox, , Privatefox
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Clients\StartMenuInternet\Privatefox\Capabilities, ApplicationDescription, Redirects opened URLs and files in Firefox Private Browsing.
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Clients\StartMenuInternet\Privatefox\Capabilities, ApplicationIcon, % """" INSTALL_FULL_PATH """"
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Clients\StartMenuInternet\Privatefox\Capabilities, ApplicationName, Privatefox
  FILE_ASSOCIATIONS := [".avif", ".htm", ".html", ".pdf", ".shtml", ".svg", ".webp", ".xht", ".xhtml"]
  for _, ASSOCIATION in FILE_ASSOCIATIONS
  {
    RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Clients\StartMenuInternet\Privatefox\Capabilities\FileAssociations, % ASSOCIATION, PrivatefoxHTML
  }
  URL_ASSOCIATIONS := ["http", "https", "mailto"]
  for _, ASSOCIATION in URL_ASSOCIATIONS
  {
    RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Clients\StartMenuInternet\Privatefox\Capabilities\URLAssociations, % ASSOCIATION, PrivatefoxHTML
  }
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Clients\StartMenuInternet\Privatefox\DefaultIcon, , % """" INSTALL_FULL_PATH """"
  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Clients\StartMenuInternet\Privatefox\shell\open\command, , % """" INSTALL_FULL_PATH """ run"

  MsgBox, Install complete.

  ExitApp
}

if (FLAG = "uninstall")
{
  RegDelete, HKEY_CURRENT_USER\SOFTWARE\RegisteredApplications, Privatefox

  RegDelete, HKEY_CURRENT_USER\SOFTWARE\Classes\PrivatefoxHTML

  RegDelete, HKEY_CURRENT_USER\SOFTWARE\Clients\StartMenuInternet\Privatefox

  RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce, Privatefox, % """C:\Windows\System32\cmd.exe"" /c rmdir /q /s """ INSTALL_PATH """"

  RegDelete, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Privatefox

  MsgBox, Uninstall complete.

  ExitApp
}

FIREFOX_PATHS := [LOCALAPPDATA "\Mozilla Firefox\firefox.exe", PROGRAMS "\Mozilla Firefox\firefox.exe"]
RegRead, FIREFOX_STORE, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe
if (not ErrorLevel)
{
  FIREFOX_PATHS.Push(FIREFOX_STORE)
}
for _, PATH in FIREFOX_PATHS
{
  if (FileExist(PATH))
  {
    FIREFOX := PATH
    break
  }
}
if (not FIREFOX)
{
  MsgBox, Unable to find Firefox.
  ExitApp
}

if (FLAG = "run")
{
  Run, % FIREFOX " -private-window"

  ExitApp
}

ADDRESS := A_Args[2]
if (FLAG = "redirect")
{
  Run, % FIREFOX " -private-window """ ADDRESS """"

  ExitApp
}
