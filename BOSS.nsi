﻿;BOSS NSIS Installer Script

;--------------------------------
;Include NSIS files.

	!include "MUI2.nsh"
    !include "x64.nsh"
	!include "LogicLib.nsh"
	!include "nsDialogs.nsh"

;--------------------------------
;General

	;Name, file and version info for installer.
	Name "BOSS v2.3.0"
	OutFile "BOSS Installer.exe"
	VIProductVersion 2.3.0.0

	;Request application privileges for Windows Vista/7
	RequestExecutionLevel admin

	;Icon for installer\uninstaller
	!define MUI_ICON "BOSS.ico"
	!define MUI_UNICON "BOSS.ico"

	; This causes an "are you sure?" message to be displayed if you try to quit the installer or uninstaller.
	!define MUI_ABORTWARNING
	!define MUI_UNABORTWARNING

	;Checks that the installer's CRC is correct (means we can remove installer CRC checking from BOSS).
	CRCCheck force

	;The SOLID lzma compressor gives the best compression ratio.
	SetCompressor /SOLID lzma

;--------------------------------
;Interface Settings



;--------------------------------
;Pages

	!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

	!insertmacro MUI_PAGE_WELCOME
	!insertmacro MUI_PAGE_DIRECTORY
	!insertmacro MUI_PAGE_INSTFILES
	!define MUI_FINISHPAGE_NOAUTOCLOSE
	!define MUI_FINISHPAGE_RUN "$INSTDIR\BOSS.exe"
	!define MUI_FINISHPAGE_RUN_TEXT "$(Text_Run)"
	!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\Docs\BOSS ReadMe.html"
	!define MUI_FINISHPAGE_SHOWREADME_TEXT "$(Text_ShowReadme)"
	!insertmacro MUI_PAGE_FINISH

	!insertmacro MUI_UNPAGE_WELCOME
	!insertmacro MUI_UNPAGE_COMPONENTS
	!insertmacro MUI_UNPAGE_CONFIRM
	!insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

	!insertmacro MUI_LANGUAGE "English"
	!insertmacro MUI_LANGUAGE "Russian"
	!insertmacro MUI_LANGUAGE "German"
	!insertmacro MUI_LANGUAGE "Spanish"
	!insertmacro MUI_LANGUAGE "SimpChinese"
	!insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
;English Strings

	VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "BOSS"
	VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "BOSS Development Team"
	VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© 2009-2014 BOSS Development Team"
	VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Installer for BOSS 2.3.0"
	VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "2.3.0"

	LangString TEXT_MESSAGEBOX ${LANG_ENGLISH} "BOSS is already installed, and must be uninstalled before continuing. $\n$\nClick `OK` to remove the previous version or `Cancel` to cancel this upgrade."
	LangString TEXT_RUN ${LANG_ENGLISH} "Run BOSS"
	LangString TEXT_SHOWREADME ${LANG_ENGLISH} "View Readme"
	LangString TEXT_MAIN ${LANG_ENGLISH} "All BOSS's files, minus userlists and the BOSS.ini."
	LangString TEXT_USERFILES ${LANG_ENGLISH} "BOSS's userlist files and BOSS.ini file."

;--------------------------------
;Russian (Русский) Strings

	VIAddVersionKey /LANG=${LANG_RUSSIAN} "ProductName" "BOSS"
	VIAddVersionKey /LANG=${LANG_RUSSIAN} "CompanyName" "BOSS Development Team"
	VIAddVersionKey /LANG=${LANG_RUSSIAN} "LegalCopyright" "© 2009-2014 BOSS Development Team"
	VIAddVersionKey /LANG=${LANG_RUSSIAN} "FileDescription" "Установщик для BOSS 2.3.0"
	VIAddVersionKey /LANG=${LANG_RUSSIAN} "FileVersion" "2.3.0"

	LangString TEXT_MESSAGEBOX ${LANG_RUSSIAN} "BOSS уже установлен и должен быть удален перед продолжением. $\n$\nНажмите `OK` для удаления предыдущей версии или `Отмена` для отмены обновления."
	LangString TEXT_RUN ${LANG_RUSSIAN} "Запустить BOSS"
	LangString TEXT_SHOWREADME ${LANG_RUSSIAN} "Смотреть BOSS-Readme"
	LangString TEXT_MAIN ${LANG_RUSSIAN} "Все файлы BOSS, кроме пользовательских списков и BOSS.ini"
	LangString TEXT_USERFILES ${LANG_RUSSIAN} "Файлы пользовательских списков и BOSS.ini."

;--------------------------------
;German (Deutsch) Strings

	VIAddVersionKey /LANG=${LANG_GERMAN} "ProductName" "BOSS"
	VIAddVersionKey /LANG=${LANG_GERMAN} "CompanyName" "BOSS Development Team"
	VIAddVersionKey /LANG=${LANG_GERMAN} "LegalCopyright" "© 2009-2014 BOSS Development Team"
	VIAddVersionKey /LANG=${LANG_GERMAN} "FileDescription" "Installer für BOSS 2.3.0"
	VIAddVersionKey /LANG=${LANG_GERMAN} "FileVersion" "2.3.0"

	LangString TEXT_MESSAGEBOX ${LANG_GERMAN} "BOSS ist bereits installiert und muss deinstalliert werden, bevor fortgefahren wird. $\n$\nKlicke auf `Ok` um die vorherige Version zu entfernen oder auf `Abbrechen` um das Upgrade abzubrechen."
	LangString TEXT_RUN ${LANG_GERMAN} "BOSS starten"
	LangString TEXT_SHOWREADME ${LANG_GERMAN} "Readme lesen"
	LangString TEXT_MAIN ${LANG_GERMAN} "Alle Dateien von BOSS ohne die Benutzerlisten und die BOSS.ini."
	LangString TEXT_USERFILES ${LANG_GERMAN} "Benutzerliste von BOSS und die BOSS.ini-Datei."

;--------------------------------
;Spanish (castellano) Strings

	VIAddVersionKey /LANG=${LANG_SPANISH} "ProductName" "BOSS"
	VIAddVersionKey /LANG=${LANG_SPANISH} "CompanyName" "BOSS Development Team"
	VIAddVersionKey /LANG=${LANG_SPANISH} "LegalCopyright" "© 2009-2014 BOSS Development Team"
	VIAddVersionKey /LANG=${LANG_SPANISH} "FileDescription" "El instalador para BOSS 2.3.0"
	VIAddVersionKey /LANG=${LANG_SPANISH} "FileVersion" "2.3.0"

	LangString TEXT_MESSAGEBOX ${LANG_SPANISH} "BOSS está instalado, y debe ser desinstalado antes de continuar. $\n$\nPresione `OK` para eliminar la versión anterior o `Cancel` para cancelar la actualización."
	LangString TEXT_RUN ${LANG_SPANISH} "Ejecutar BOSS"
	LangString TEXT_SHOWREADME ${LANG_SPANISH} "Ver Léame"
	LangString TEXT_MAIN ${LANG_SPANISH} "Todos los archivos de BOSS, menos BOSS.ini y listas de usuarios."
	LangString TEXT_USERFILES ${LANG_SPANISH} "BOSS.ini y listas de usuarios."

;--------------------------------
;Simplified Chinese (简体中文) Strings

VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "ProductName" "BOSS"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "CompanyName" "BOSS Development Team"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "LegalCopyright" "© 2009-2014 BOSS Development Team"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "FileDescription" "BOSS 2.3.0安装包"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "FileVersion" "2.3.0"

LangString TEXT_MESSAGEBOX ${LANG_SIMPCHINESE} "检测到旧版BOSS，您需要先卸载旧版才能安装新版。$\n$\n单击“确定”卸载旧版本或者“取消”取消更新。"
LangString TEXT_RUN ${LANG_SIMPCHINESE} "运行BOSS"
LangString TEXT_SHOWREADME ${LANG_SIMPCHINESE} "查看说明"
LangString TEXT_MAIN ${LANG_SIMPCHINESE} "所有BOSS文件（除userlist和BOSS.ini）"
LangString TEXT_USERFILES ${LANG_SIMPCHINESE} "BOSS的userlist和BOSS.ini文件。"

;--------------------------------
;Variables

	Var OB_Path
	Var NE_Path
	Var SK_Path
	Var FO_Path
	Var NV_Path
	Var Empty ;An empty string.
	Var InstallPath ;Path to existing BOSS install.

;--------------------------------
;Initialisations

	Function .onInit

		!insertmacro MUI_LANGDLL_DISPLAY

		StrCpy $Empty ""

		; Look for games, setting their paths if found.
		ReadRegStr $OB_Path HKLM "Software\Bethesda Softworks\Oblivion" "Installed Path"
		${If} $OB_Path == $Empty ;Try 64 bit path.
			ReadRegStr $OB_Path HKLM "Software\Wow6432Node\Bethesda Softworks\Oblivion" "Installed Path"
		${EndIf}
		ReadRegStr $NE_Path HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nehrim - At Fate's Edge_is1" "InstallLocation" ;No 64 bit path.
		ReadRegStr $SK_Path HKLM "Software\Bethesda Softworks\Skyrim" "Installed Path"
		${If} $SK_Path == $Empty ;Try 64 bit path.
			ReadRegStr $SK_Path HKLM "Software\Wow6432Node\Bethesda Softworks\Skyrim" "Installed Path"
		${EndIf}
		ReadRegStr $FO_Path HKLM "Software\Bethesda Softworks\Fallout3" "Installed Path"
		${If} $FO_Path == $Empty ;Try 64 bit path.
			ReadRegStr $FO_Path HKLM "Software\Wow6432Node\Bethesda Softworks\Fallout3" "Installed Path"
		${EndIf}
		ReadRegStr $NV_Path HKLM "Software\Bethesda Softworks\FalloutNV" "Installed Path"
		${If} $NV_Path == $Empty ;Try 64 bit path.
			ReadRegStr $NV_Path HKLM "Software\Wow6432Node\Bethesda Softworks\FalloutNV" "Installed Path"
		${EndIf}
		StrCpy $INSTDIR "C:\BOSS"

	FunctionEnd

	Function onGUIInit
		; Have to do this now as language isn't actually set until
		; First check to see if BOSS is already installed via installer, and launch the existing uninstaller if so.
		IfFileExists "$COMMONFILES\BOSS\uninstall.exe" 0 +8
			MessageBox MB_OKCANCEL|MB_ICONQUESTION "$(Text_MessageBox)" IDOK oldCont IDCANCEL oldCancel
			oldCancel:
				Quit
			oldCont:
				ExecWait '$COMMONFILES\BOSS\uninstall.exe _?=$COMMONFILES\BOSS' ;Run the uninstaller in its folder and wait until it's done.
				Delete "$COMMONFILES\BOSS\uninstall.exe"
				RMDir "$COMMONFILES\BOSS"

		;That was the old uninstaller location, now see if the current version is already installed.
		ReadRegStr $InstallPath HKLM "Software\BOSS" "Installed Path"
		${If} $InstallPath == $Empty ;Try 64 bit path.
			ReadRegStr $InstallPath HKLM "Software\Wow6432Node\BOSS" "Installed Path"
		${EndIf}
		${If} $InstallPath != $Empty
			StrCpy $INSTDIR $InstallPath  ;Set the default install path to the previous install's path.
			IfFileExists "$InstallPath\Uninstall.exe" 0 +8
				MessageBox MB_OKCANCEL|MB_ICONQUESTION "$(Text_MessageBox)" IDOK cont IDCANCEL cancel
				cancel:
					Quit
				cont:
					ExecWait '$InstallPath\Uninstall.exe _?=$InstallPath' ;Run the uninstaller in its folder and wait until it's done.
					Delete "$InstallPath\Uninstall.exe"
					RMDir "$InstallPath"
		${EndIf}
	FunctionEnd

	Function un.onInit

		!insertmacro MUI_LANGDLL_DISPLAY

	FunctionEnd

;--------------------------------
;Installer Sections
	Section "New Files"
		;Rename BOSS.ini if it exists.
		IfFileExists "BOSS.ini" 0 +3
			Delete "BOSS.ini.old"
			Rename "BOSS.ini" "BOSS.ini.old"

		;Install new BOSS ini.
		SetOutPath "$INSTDIR"
		File "data\BOSS.ini"

		;Write language ini setting to BOSS.ini. The space is there because otherwise it would be printed as =russian or whatever. Purely to look good.
		StrCmp $LANGUAGE ${LANG_RUSSIAN} 0 +2
		WriteINIStr $INSTDIR\BOSS.ini "General Settings" "sLanguage" " russian"
		StrCmp $LANGUAGE ${LANG_GERMAN} 0 +2
		WriteINIStr $INSTDIR\BOSS.ini "General Settings" "sLanguage" " german"
		StrCmp $LANGUAGE ${LANG_SPANISH} 0 +2
		WriteINIStr $INSTDIR\BOSS.ini "General Settings" "sLanguage" " spanish"
		StrCmp $LANGUAGE ${LANG_SIMPCHINESE} 0 +2
		WriteINIStr $INSTDIR\BOSS.ini "General Settings" "sLanguage" " chinese"

		;Install main executables.
		SetOutPath "$INSTDIR"
		File "bin\Release-32\BOSS.exe"
		File "bin\Release-32\BOSS GUI.exe"

		;Now install readme files.
		SetOutPath "$INSTDIR\Docs"
		File "data\Docs\BOSS Masterlist Syntax.html"
		File "data\Docs\BOSS ReadMe.html"
		File "data\Docs\BOSS Userlist Syntax.html"
		File "data\Docs\BOSS Version History.html"
		File "data\Docs\Licenses.txt"

		;Now install readme images.
		SetOutPath "$INSTDIR\Docs\images"
		File "data\Docs\images\GUI-Main.png"
		File "data\Docs\images\GUI-Select-Game.png"
		File "data\Docs\images\GUI-Settings.png"
		File "data\Docs\images\GUI-User-Rules-Manager.png"
		File "data\Docs\images\HTML-Log.png"
		File "data\Docs\images\Userlist.png"
		File "data\Docs\images\Ini.png"
		File "data\Docs\images\CLI.png"

        ;Install resource files.
        SetOutPath "$INSTDIR\resources"
		File "data\resources\style.css"
		File "data\resources\script.js"
		File "data\resources\octokit.js"
		File "data\resources\promise-1.0.0.min.js"


		;Now install language files.
		SetOutPath "$INSTDIR\resources\l10n\ru\LC_MESSAGES"
		File "data\resources\l10n\ru\LC_MESSAGES\messages.mo"
		File "data\resources\l10n\ru\LC_MESSAGES\wxstd.mo"
		SetOutPath "$INSTDIR\resources\l10n\es\LC_MESSAGES"
		File "data\resources\l10n\es\LC_MESSAGES\wxstd.mo"
		File "data\resources\l10n\es\LC_MESSAGES\messages.mo"
		SetOutPath "$INSTDIR\resources\l10n\de\LC_MESSAGES"
		File "data\resources\l10n\de\LC_MESSAGES\wxstd.mo"
		SetOutPath "$INSTDIR\resources\l10n\zh\LC_MESSAGES"
		File "data\resources\l10n\zh\LC_MESSAGES\messages.mo"
		File "data\resources\l10n\zh\LC_MESSAGES\wxstd.mo"

        ; The repositories can take a while to fetch for the first time, so by
        ; bundling in that data, we reduce the first-time run time.
        ; This assumes that the boss repository is beside all the masterlist
        ; repositories.

        ; Oblivion
        SetOutPath "$INSTDIR\Oblivion\.git"
        File "..\oblivion\.git\config"
        File "..\oblivion\.git\HEAD"
        File "..\oblivion\.git\index"
        File "..\oblivion\.git\packed-refs"
        SetOutPath "$INSTDIR\Oblivion\.git\refs\heads"
        File "..\oblivion\.git\refs\heads\master"
        SetOutPath "$INSTDIR\Oblivion\.git\refs\remotes\origin"
        File "..\oblivion\.git\refs\remotes\origin\HEAD"
        SetOutPath "$INSTDIR\Oblivion\.git\objects"
		File /r "..\oblivion\.git\objects\*"

        ; Skyrim
        SetOutPath "$INSTDIR\Skyrim\.git"
        File "..\skyrim\.git\config"
        File "..\skyrim\.git\HEAD"
        File "..\skyrim\.git\index"
        File "..\skyrim\.git\packed-refs"
        SetOutPath "$INSTDIR\Skyrim\.git\refs\heads"
        File "..\skyrim\.git\refs\heads\master"
        SetOutPath "$INSTDIR\Skyrim\.git\refs\remotes\origin"
        File "..\skyrim\.git\refs\remotes\origin\HEAD"
        SetOutPath "$INSTDIR\Skyrim\.git\objects"
		File /r "..\skyrim\.git\objects\*"

        ; Nehrim
        SetOutPath "$INSTDIR\Nehrim\.git"
        File "..\nehrim\.git\config"
        File "..\nehrim\.git\HEAD"
        File "..\nehrim\.git\index"
        File "..\nehrim\.git\packed-refs"
        SetOutPath "$INSTDIR\Nehrim\.git\refs\heads"
        File "..\nehrim\.git\refs\heads\master"
        SetOutPath "$INSTDIR\Nehrim\.git\refs\remotes\origin"
        File "..\nehrim\.git\refs\remotes\origin\HEAD"
        SetOutPath "$INSTDIR\Nehrim\.git\objects"
		File /r "..\nehrim\.git\objects\*"

        ; Fallout 3
        SetOutPath "$INSTDIR\Fallout 3\.git"
        File "..\fallout3\.git\config"
        File "..\fallout3\.git\HEAD"
        File "..\fallout3\.git\index"
        File "..\fallout3\.git\packed-refs"
        SetOutPath "$INSTDIR\Fallout 3\.git\refs\heads"
        File "..\fallout3\.git\refs\heads\master"
        SetOutPath "$INSTDIR\Fallout 3\.git\refs\remotes\origin"
        File "..\fallout3\.git\refs\remotes\origin\HEAD"
        SetOutPath "$INSTDIR\Fallout 3\.git\objects"
		File /r "..\fallout3\.git\objects\*"

        ; Fallout New Vegas
        SetOutPath "$INSTDIR\Fallout New Vegas\.git"
        File "..\falloutnv\.git\config"
        File "..\falloutnv\.git\HEAD"
        File "..\falloutnv\.git\index"
        File "..\falloutnv\.git\packed-refs"
        SetOutPath "$INSTDIR\Fallout New Vegas\.git\refs\heads"
        File "..\falloutnv\.git\refs\heads\master"
        SetOutPath "$INSTDIR\Fallout New Vegas\.git\refs\remotes\origin"
        File "..\falloutnv\.git\refs\remotes\origin\HEAD"
        SetOutPath "$INSTDIR\Fallout New Vegas\.git\objects"
		File /r "..\falloutnv\.git\objects\*"

		;Add Start Menu shortcuts. Set out path back to $INSTDIR otherwise the shortcuts start in the wrong place.
		;Set Shell Var Context to all so that shortcuts are installed for all users, not just admin.
		SetOutPath "$INSTDIR"
		SetShellVarContext all
		CreateDirectory "$SMPROGRAMS\BOSS"
		CreateShortCut "$SMPROGRAMS\BOSS\BOSS.lnk" "$INSTDIR\BOSS.exe"
		CreateShortCut "$SMPROGRAMS\BOSS\BOSS GUI.lnk" "$INSTDIR\BOSS GUI.exe"
		CreateShortCut "$SMPROGRAMS\BOSS\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
		CreateDirectory "$SMPROGRAMS\BOSS\Docs"
		CreateShortCut "$SMPROGRAMS\BOSS\Docs\Main ReadMe.lnk" "$INSTDIR\Docs\BOSS Readme.html"
		CreateShortCut "$SMPROGRAMS\BOSS\Docs\Userlist Syntax.lnk" "$INSTDIR\Docs\BOSS Userlist Syntax.html"
		CreateShortCut "$SMPROGRAMS\BOSS\Docs\Version History.lnk" "$INSTDIR\Docs\BOSS Version History.html"
		CreateShortCut "$SMPROGRAMS\BOSS\Docs\Masterlist Syntax.lnk" "$INSTDIR\Docs\BOSS Masterlist Syntax.html"
		CreateShortCut "$SMPROGRAMS\BOSS\Docs\Copyright Licenses.lnk" "$INSTDIR\Docs\Licenses.txt"


		;Store installation folder in registry key.
		WriteRegStr HKLM "Software\BOSS" "Installed Path" "$INSTDIR"
		;Write registry keys for Windows' uninstaller.
		WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BOSS" "DisplayName" "BOSS"
		WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BOSS" "UninstallString" '"$INSTDIR\Uninstall.exe"'
		WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BOSS" "URLInfoAbout" 'http://better-oblivion-sorting-software.googlecode.com/'
		WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BOSS" "HelpLink" 'http://better-oblivion-sorting-software.googlecode.com/'
		WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BOSS" "Publisher" 'BOSS Development Team'
		WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BOSS" "DisplayVersion" '2.1.1'
		WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BOSS" "NoModify" 1
		WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BOSS" "NoRepair" 1

		;Create uninstaller
		WriteUninstaller "$INSTDIR\Uninstall.exe"

	SectionEnd

;--------------------------------
;Uninstaller Section


	Section "un.BOSS" Main

		;Remove main executables.
		Delete "$INSTDIR\BOSS.exe"
		Delete "$INSTDIR\BOSS GUI.exe"

		;Remove readme files.
		Delete "$INSTDIR\Docs\BOSS Masterlist Syntax.html"
		Delete "$INSTDIR\Docs\BOSS ReadMe.html"
		Delete "$INSTDIR\Docs\BOSS Userlist Syntax.html"
		Delete "$INSTDIR\Docs\BOSS Version History.html"
		Delete "$INSTDIR\Docs\Licenses.txt"

		;Remove readme images.
		Delete "$INSTDIR\Docs\images\GUI-Main.png"
		Delete "$INSTDIR\Docs\images\GUI-Select-Game.png"
		Delete "$INSTDIR\Docs\images\GUI-Settings.png"
		Delete "$INSTDIR\Docs\images\GUI-User-Rules-Manager.png"
		Delete "$INSTDIR\Docs\images\HTML-Log.png"
		Delete "$INSTDIR\Docs\images\Userlist.png"
		Delete "$INSTDIR\Docs\images\Ini.png"
		Delete "$INSTDIR\Docs\images\CLI.png"

		;Remove language files.
		Delete "$INSTDIR\resources\l10n\ru\LC_MESSAGES\messages.mo"
		Delete "$INSTDIR\resources\l10n\ru\LC_MESSAGES\wxstd.mo"
		Delete "$INSTDIR\resources\l10n\es\LC_MESSAGES\messages.mo"
		Delete "$INSTDIR\resources\l10n\es\LC_MESSAGES\wxstd.mo"
		Delete "$INSTDIR\resources\l10n\de\LC_MESSAGES\wxstd.mo"
		Delete "$INSTDIR\resources\l10n\zh\LC_MESSAGES\messages.mo"
		Delete "$INSTDIR\resources\l10n\zh\LC_MESSAGES\wxstd.mo"

        ;Remove other resources.
		Delete "$INSTDIR\resources\style.css"
		Delete "$INSTDIR\resources\script.js"
		Delete "$INSTDIR\resources\octokit.js"
		Delete "$INSTDIR\resources\promise-1.0.0.min.js"

		;Now we have to remove the files BOSS generates when it runs.
		Delete "$INSTDIR\BOSSDebugLog.txt"
		;Trying to delete a file that doesn't exist doesn't cause an error, so delete all games' files.
		Delete "$INSTDIR\Oblivion\BOSSlog.txt"
		Delete "$INSTDIR\Oblivion\BOSSlog.html"
		Delete "$INSTDIR\Oblivion\masterlist.txt"
		Delete "$INSTDIR\Oblivion\modlist.txt"
		Delete "$INSTDIR\Oblivion\modlist.old"
		Delete "$INSTDIR\Nehrim\BOSSlog.txt"
		Delete "$INSTDIR\Nehrim\BOSSlog.html"
		Delete "$INSTDIR\Nehrim\masterlist.txt"
		Delete "$INSTDIR\Nehrim\modlist.txt"
		Delete "$INSTDIR\Nehrim\modlist.old"
		Delete "$INSTDIR\Skyrim\BOSSlog.txt"
		Delete "$INSTDIR\Skyrim\BOSSlog.html"
		Delete "$INSTDIR\Skyrim\masterlist.txt"
		Delete "$INSTDIR\Skyrim\modlist.txt"
		Delete "$INSTDIR\Skyrim\modlist.old"
		Delete "$INSTDIR\Fallout 3\BOSSlog.txt"
		Delete "$INSTDIR\Fallout 3\BOSSlog.html"
		Delete "$INSTDIR\Fallout 3\masterlist.txt"
		Delete "$INSTDIR\Fallout 3\modlist.txt"
		Delete "$INSTDIR\Fallout 3\modlist.old"
		Delete "$INSTDIR\Fallout New Vegas\BOSSlog.txt"
		Delete "$INSTDIR\Fallout New Vegas\BOSSlog.html"
		Delete "$INSTDIR\Fallout New Vegas\masterlist.txt"
		Delete "$INSTDIR\Fallout New Vegas\modlist.txt"
		Delete "$INSTDIR\Fallout New Vegas\modlist.old"

        ;Delete repositories.
        RMDir /r "$INSTDIR\Oblivion\.git"
        RMDir /r "$INSTDIR\Nehrim\.git"
        RMDir /r "$INSTDIR\Skyrim\.git"
        RMDir /r "$INSTDIR\Fallout 3\.git"
        RMDir /r "$INSTDIR\Fallout New Vegas\.git"

		;Remove subfolders.
		RMDir "$INSTDIR\API"
		RMDir "$INSTDIR\Docs\images"
		RMDir "$INSTDIR\Docs"
		RMDir "$INSTDIR\Oblivion"
		RMDir "$INSTDIR\Nehrim"
		RMDir "$INSTDIR\Skyrim"
		RMDir "$INSTDIR\Fallout 3"
		RMDir "$INSTDIR\Fallout New Vegas"
		RMDir "$INSTDIR\resources\l10n\ru\LC_MESSAGES"
		RMDir "$INSTDIR\resources\l10n\ru"
		RMDir "$INSTDIR\resources\l10n\es\LC_MESSAGES"
		RMDir "$INSTDIR\resources\l10n\es"
		RMDir "$INSTDIR\resources\l10n\de\LC_MESSAGES"
		RMDir "$INSTDIR\resources\l10n\de"
		RMDir "$INSTDIR\resources\l10n\zh\LC_MESSAGES"
		RMDir "$INSTDIR\resources\l10n\zh"
		RMDir "$INSTDIR\resources\l10n"
		RMDir "$INSTDIR\resources"

		;Remove uninstaller.
		Delete "$INSTDIR\Uninstall.exe"

		;Remove install directory.
		RMDir "$INSTDIR"

		;Delete registry key.
		DeleteRegKey HKLM "Software\BOSS"

		;Delete stupid Windows created registry keys:
		DeleteRegKey HKCU "Software\BOSS"
		DeleteRegKey HKLM "Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\BOSS"
		DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BOSS"
		DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache\BOSS"
		DeleteRegValue HKCR "Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$INSTDIR"
		DeleteRegValue HKCR "Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$INSTDIR\BOSS.exe"
		DeleteRegValue HKCR "Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$INSTDIR\BOSS GUI.exe"
		DeleteRegValue HKCR "Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$INSTDIR\Uninstall.exe"
		DeleteRegValue HKCU "Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$INSTDIR"
		DeleteRegValue HKCU "Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$INSTDIR\BOSS.exe"
		DeleteRegValue HKCU "Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$INSTDIR\BOSS GUI.exe"
		DeleteRegValue HKCU "Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$INSTDIR\Uninstall.exe"
		DeleteRegValue HKCU "Software\Microsoft\Windows\ShellNoRoam\MuiCache" "$INSTDIR"
		DeleteRegValue HKCU "Software\Microsoft\Windows\ShellNoRoam\MuiCache" "$INSTDIR\BOSS.exe"
		DeleteRegValue HKCU "Software\Microsoft\Windows\ShellNoRoam\MuiCache" "$INSTDIR\BOSS GUI.exe"
		DeleteRegValue HKCU "Software\Microsoft\Windows\ShellNoRoam\MuiCache" "$INSTDIR\Uninstall.exe"

		;Delete Start Menu folder.
		SetShellVarContext all
		RMDir /r "$SMPROGRAMS\BOSS"

	SectionEnd

	Section /o "un.User Files" UserFiles
		;The following user files are only removed if set to.
		Delete "$INSTDIR\BOSS.ini"
		Delete "$INSTDIR\BOSS.ini.old"
		Delete "$INSTDIR\Oblivion\userlist.txt"
		Delete "$INSTDIR\Nehrim\userlist.txt"
		Delete "$INSTDIR\Skyrim\userlist.txt"
		Delete "$INSTDIR\Fallout 3\userlist.txt"
		Delete "$INSTDIR\Fallout New Vegas\userlist.txt"
		;Also try removing the folders storing them, in case they are otherwise empty.
		RMDir "$INSTDIR\Oblivion"
		RMDir "$INSTDIR\Nehrim"
		RMDir "$INSTDIR\Skyrim"
		RMDir "$INSTDIR\Fallout 3"
		RMDir "$INSTDIR\Fallout New Vegas"
		;Try removing install directory.
		RMDir "$INSTDIR"
	SectionEnd

;--------------------------------
;Languages - Description Strings

	!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN
	  !insertmacro MUI_DESCRIPTION_TEXT ${Main} "$(Text_Main)"
	  !insertmacro MUI_DESCRIPTION_TEXT ${UserFiles} "$(Text_UserFiles)"
	!insertmacro MUI_UNFUNCTION_DESCRIPTION_END

;--------------------------------