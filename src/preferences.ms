-- Pointcache Tool
-- v0.1b
-- 01/11/2014
-- onectin@onectin.fr
-- --------------------------
-- preferences.ms


-- Kill  any other window from PCT
try(DestroyDialog ::_PCT_MainUi) catch()
try(DestroyDialog ::_PCT_Preset) catch()
try(DestroyDialog ::_PCT_Preferences) catch()
try(DestroyDialog ::_PCT_Preferences._PCT_PreferencesPCmod) catch()
try(DestroyDialog ::_PCT_MainUi._PCT_Preset) catch()
try(DestroyDialog ::_PCT_MainUi._PCT_About) catch()
try(DestroyDialog ::_PCT_MainUi._PCT_Browse) catch()


-- TOOLTIPS

_optModTT = 
"USE EXISTING: Will keep the existing modifier. It can be useful if you want to specify the position of the modifier in the stack.

ADD NEW: Will add a new pointcache modifier at the stack's top and will remove any other pointcache modifier remaining."

_optTypeTT =
"WORLD-SPACE MODIFIER: Will use the world's coordonates.

OBJECT-SPACE MODIFIER: Will use the object's coordonates (pivot position)."

_optTurboTT =
"DISABLE ALL: Will desactivate (or keep disabled) every turbosmooth modifier on each asset's meshes.

ENABLE ALL: Will activate (or keep enabled) every turbosmooth modifier on each asset's meshes.

KEEP UNCHANGED: The script won't modify turbosmooth modifiers.

SET TO x: Will set the subdivision level to a user-defined value."

_optIsoTT =
"DISABLE ALL: Will uncheck \"Isoline Display\" on every turbosmooth modifiers.

ENABLE ALL: Will check \"Isoline Display\" on every turbosmooth modifiers.

KEEP UNCHANGED: Won't change anything"

_optFilTT =
"ONE FILE: Generates one big file for the given sequence.

ONE FILE PER FRAME: Generates one file per frame, which is lighter. (Recommanded)"

_scriptDir = getDir #userScripts
_macroDir = getDir #userMacros

_PCT_dir = _scriptDir + "\\pointCacheTool"

_tmpPrstDir = _PCT_dir + "\\presets\\"
_tmpDbDir = _PCT_dir + "\\database\\"
_iconsDir = _PCT_dir + "\\img"

_mainScript = _PCT_dir + "\\pointcacheTool.ms"
global _iniPref = _PCT_dir + "\\preferences.ini"


_maxRootDir = getDir #scene
_maxRootDir = _maxRootDir + "\\"

_checkPrefFile = getFiles _iniPref

_winLastPos = "[0,0]"

_firstLaunch = false

function FNupdateIconSrc _bool =
(
	if _bool == 1 then -- Dark
	(
		global _icons2File = _iconsDir + "\\PCT_darkIcons2.bmp"
		global _iconsFile = _iconsDir + "\\PCT_darkIcons.bmp"
	)
	else -- Bright
	(
		global _icons2File = _iconsDir + "\\PCT_brightIcons2.bmp"
		global _iconsFile = _iconsDir + "\\PCT_brightIcons.bmp"
	)
)

_winPos = [0,0]

if _checkPrefFile.count == 0 then
(
	_firstLaunch = true
	_checkPrefPath = ((dotnetclass "System.IO.Directory").exists _PCT_dir)
	_checkPrstPath = ((dotnetclass "System.IO.Directory").exists _tmpPrstDir)
	_checkDbPath = ((dotnetclass "System.IO.Directory").exists _tmpDbDir)
	
	if _checkPrefPath == false do makeDir _PCT_dir
	if _checkPrstPath == false do makeDir _tmpPrstDir
	if _checkPrstPath == false do makeDir _tmpDbDir

	--global _defdefaultCacheType = 	
	global _defautoClose = 			false
	global _defframeRange = 		1
	global _defcustomRangeFrom = 	0
	global _defcustomRangeTo = 		100
	global _defappearance = 		2
	global _deficons = 				1
	global _defwinPos = 			true
	global _defwinLastPos =			[50,50]
	global _defcategories = 		#("DEFAULT")
	global _defPCO_same = 			false
	global _defPCO_EXP_typ = 		2
	global _defPCO_EXP_mod = 		2
	global _defPCO_EXP_tur = 		1
	global _defPCO_EXP_val = 		0
	global _defPCO_EXP_iso = 		1
	global _defPCO_EXP_fil = 		2
	global _defPCO_IMP_typ = 		2
	global _defPCO_IMP_mod = 		1
	global _defPCO_IMP_tur = 		3
	global _defPCO_IMP_val = 		0
	global _defPCO_IMP_iso = 		3
	global _defPCO_IMP_fil = 		2

	global _btnWidth = 328

	_oldMacroFile = _PCT_dir + "\\pointcacheTool.mcr"
	_newMacroFile = _macroDir + "\\pointcacheTool.mcr"
	deleteFile _newMacroFile
	copyFile _oldMacroFile _newMacroFile
	deleteFile _oldMacroFile
)
else
(
	global _defdbDir = 				getIniSetting _iniPref "Paths" "database_path"
	global _defcacheDir = 			getIniSetting _iniPref "Paths" "cache_path"

	global _defdefaultCacheType = 	execute(getIniSetting _iniPref "UI_Options" "default_pointcache_type")
	global _defautoClose = 			execute(getIniSetting _iniPref "UI_Options" "autoclose")
	global _defframeRange = 		execute(getIniSetting _iniPref "UI_Options" "framerange_type")
	global _defcustomRangeFrom = 	execute(getIniSetting _iniPref "UI_Options" "custom_range_from")
	global _defcustomRangeTo = 		execute(getIniSetting _iniPref "UI_Options" "custom_range_to")
	global _defappearance = 		execute(getIniSetting _iniPref "UI_Options" "appearance")
	global _deficons = 				execute(getIniSetting _iniPref "UI_Options" "icons_type")

	global _defwinPos = 			execute(getIniSetting _iniPref "Window_position" "save")
	global _defwinLastPos = 		execute(getIniSetting _iniPref "Window_position" "position")

	global _defcategories = 		execute(getIniSetting _iniPref "Categories" "categories")

	global _defseqPrefix = 			getIniSetting _iniPref "SEQ_SHOT" "sequence_prefix"
	global _defseqDigits = 			execute(getIniSetting _iniPref "SEQ_SHOT" "sequence_digits")
	global _defshotPrefix = 		getIniSetting _iniPref "SEQ_SHOT" "shot_prefix"
	global _defshotDigits = 		execute(getIniSetting _iniPref "SEQ_SHOT" "shot_digits")

	global _defPCO_same = 			execute(getIniSetting 	_iniPref "PointCache_Options" "same_for_export_and_import")
	global _defPCO_EXP_typ = 		execute(getIniSetting 	_iniPref "PointCache_Options" "export_pointcache_type")
	global _defPCO_EXP_mod = 		execute(getIniSetting 	_iniPref "PointCache_Options" "export_pointcache_modifier")
	global _defPCO_EXP_tur = 		execute(getIniSetting 	_iniPref "PointCache_Options" "export_pointcache_turbosmooth")
	global _defPCO_EXP_val = 		execute(getIniSetting 	_iniPref "PointCache_Options" "export_pointcache_turbosmooth_overwrite_value")
	global _defPCO_EXP_iso = 		execute(getIniSetting 	_iniPref "PointCache_Options" "export_pointcache_isolineDisplay")
	global _defPCO_EXP_fil = 		execute(getIniSetting 	_iniPref "PointCache_Options" "export_pointcache_fileCount")
	global _defPCO_IMP_typ = 		execute(getIniSetting 	_iniPref "PointCache_Options" "import_pointcache_type")
	global _defPCO_IMP_mod = 		execute(getIniSetting 	_iniPref "PointCache_Options" "import_pointcache_modifier")
	global _defPCO_IMP_tur = 		execute(getIniSetting 	_iniPref "PointCache_Options" "import_pointcache_turbosmooth")
	global _defPCO_IMP_val = 		execute(getIniSetting 	_iniPref "PointCache_Options" "import_pointcache_turbosmooth_overwrite_value")
	global _defPCO_IMP_iso = 		execute(getIniSetting 	_iniPref "PointCache_Options" "import_pointcache_isolineDisplay")
	global _defPCO_IMP_fil = 		execute(getIniSetting 	_iniPref "PointCache_Options" "import_pointcache_fileCount")

	global _btnWidth = 160
)


rollout _PCT_Preferences "Preferences" width:344 height:604
(
	groupBox 		grpDbPath 			"Database path:" 		pos:[8,8] 		width:328 	height:48
	editText 		edtDbPath 			"" 						pos:[16,24] 	width:240 	height:24
	button 			btnDbBrowse 		"Browse..." 			pos:[264,24] 	width:64 	height:24 tooltip:"Browse..."
	
	groupBox 		grpCachePath 		"Cache path:" 			pos:[8,64] 		width:328 	height:48
	editText 		edtCachePath 		"" 						pos:[16,80] 	width:240 	height:24
	button 			btnCacheBrowse 		"Browse..." 			pos:[264,80] 	width:64 	height:24 tooltip:"Browse..."
	
	groupBox 		grpUiPrefs 			"UI preferences:" 		pos:[8,120] 	width:328 	height:182
	label 			lblDefaultType 		"Pointcache modifier:" 	pos:[16,137] 	width:100	height:16
	button 			btnCacheOptions		"Options" 				pos:[132,133] 	width:196 	height:24 tooltip:"Pointcache Options..."
	label 			lblAutoClose 		"Autoclose:" 			pos:[16,160] 	width:88 	height:16
	checkbox 		chkAutoClose 		"" 						pos:[132,160] 	width:16 	height:16
	label 			lblFrameRange 		"Framerange:" 			pos:[16,184] 	width:88 	height:16
	radioButtons 	rdoFrameRange 		"" 						pos:[132,184] 	width:112 	height:16 labels:#("Time slider         ", "Custom") columns:2
	spinner 		spnFromFrame 		"" 						pos:[132,208] 	width:64 	height:16 range:[0,10000,1] type:#integer
	label 			lblToFrame 			"to:" 					pos:[204,208] 	width:16 	height:16
	spinner 		spnToFrame 			"" 						pos:[232,208] 	width:64 	height:16 range:[0,10000,1] type:#integer
	label 			lblButtons 			"Appearance:" 			pos:[16,232] 	width:88 	height:16
	radioButtons 	rdoButtons 			"" 						pos:[132,232] 	width:112 	height:16 labels:#("Icons                 ", "Text") columns:2
	radioButtons 	rdoIcons 			"" 						pos:[132,256] 	width:112 	height:16 labels:#("Dark icons         ", "Bright icons") columns:2
	label 			lblMemorize 		"Save window position:"	pos:[16,280] 	width:108 	height:16
	checkbox 		chkMemorize 		"" 						pos:[132,280] 	width:16 	height:16

	groupBox 		grpAssetsTypes		"Categories:" 			pos:[8,310] 	width:328 	height:128
	editText 		edtAssetsTypes 		"" 						pos:[16,326] 	width:240 	height:24
	button 			btnAddPreset 		"Add" 					pos:[264,326] 	width:64 	height:24 tooltip:"Add a new category..."
	listBox 		lbxAssetTypes 		"" 						pos:[20,358] 	width:235 	height:5
	button 			btnDeletePreset 	"Delete" 				pos:[264,358] 	width:64 	height:24 tooltip:"Delete selected asset category"
		
	groupBox 		grpParsing			"Filename parsing:" 	pos:[8,444] 	width:328 	height:120
		
	groupBox 		grpParsSeq 			"Sequence" 				pos:[16,464]	width:144 	height:64
	label 			lblParsSeqPref 		"Prefix:" 				pos:[24,480]	width:32 	height:16
	editText 		edtParsSeqPref 		"" 						pos:[72,480]	width:80 	height:16
	label 			lblParsSeqDig 		"Digits:" 				pos:[24,504]	width:32 	height:16
	spinner 		spnParsSeqDig 		"" 						pos:[76,504]	width:76 	height:16 range:[0,10,1] type:#integer
	
	groupBox 		grpParsShot 		"Shot" 					pos:[184,464] 	width:144 	height:64
	label 			lblParsShotPref 	"Prefix:" 				pos:[192,480] 	width:32 	height:16
	editText 		edtParsShotPref 	"" 						pos:[240,480] 	width:80 	height:16
	label 			lblParsShotDig 		"Digits:" 				pos:[192,504] 	width:32 	height:16
	spinner		 	spnParsShotDig 		"" 						pos:[244,504] 	width:76 	height:16 range:[0,10,1] type:#integer
	
	label 			lblParsEx 			"Example:" 				pos:[16,536] 	width:62 	height:16
	editText 		edtParsEx 			"" 						pos:[70,532] 	width:260 	height:24 enabled:false bold:true

	button 			btnCancel 			"CANCEL" 				pos:[8,572] 	width:160 	height:24 tooltip:"Cancel..."
	button 			btnSave 			"SAVE" 					pos:[176,572] 	width:_btnWidth 	height:24 tooltip:"Save..."


	rollout _PCT_PreferencesPCmod "Pointcache Options" width:336 height:406
	(
		groupBox 		opt_grpExport 	"EXPORT" 				pos:[8,8] 		width:144 	height:366
		radioButtons	opt_rdoExMod	"Modifier:" 			pos:[16,80] 	width:112 	height:46 	tooltip:_optModTT columns:1 	labels:#("Use exisiting", "Add new")
		radioButtons	opt_rdoExTyp	"Type:" 				pos:[16,24] 	width:112 	height:46 	tooltip:_optTypeTT columns:1 	labels:#("World-space modifier", "Object-space modifier")
		radioButtons	opt_rdoExTur	"Turbosmooth:" 			pos:[16,136] 	width:112 	height:78 	tooltip:_optTurboTT columns:1 	labels:#("Disable all", "Enable all", "Keep unchanged", "Set to:")
		radioButtons	opt_rdoExIso	"Isoline display:" 		pos:[16,224] 	width:112 	height:62 	tooltip:_optIsoTT columns:1 	labels:#("Disable all", "Enable all", "Keep unchanged")
		radioButtons	opt_rdoExFil	"File:" 				pos:[16,294] 	width:112 	height:46 	tooltip:_optFilTT columns:1 	labels:#("One file", "One file per frame")
		button 			opt_btnExDef	"Default" 				pos:[16,352] 	width:128 	height:16
		spinner 		opt_spnExTur 	"" 						pos:[70,198]	width:45 	height:16 	enabled:false range:[0,10,1] type:#integer
		
		groupBox 		opt_grpImport 	"IMPORT" 				pos:[184,8] 	width:144 	height:366
		radioButtons 	opt_rdoImMod 	"Modifier:" 			pos:[192,80] 	width:112 	height:46	tooltip:_optModTT columns:1 	labels:#("Use exisiting", "Add new")
		radioButtons 	opt_rdoImTyp 	"Type:" 				pos:[192,24] 	width:112 	height:46	tooltip:_optTypeTT columns:1 	labels:#("World-space modifier", "Object-space modifier")
		radioButtons 	opt_rdoImTur 	"Turbosmooth:" 			pos:[192,136] 	width:112 	height:78	tooltip:_optTurboTT columns:1 	labels:#("Disable all", "Enable all", "Keep unchanged", "Set to:")
		radioButtons 	opt_rdoImIso 	"Isoline display:" 		pos:[192,224] 	width:112 	height:62	tooltip:_optIsoTT columns:1 	labels:#("Disable all", "Enable all", "Keep unchanged")
		spinner 		opt_spnImTur 	"" 						pos:[246,198]	width:45 	height:16 	enabled:false range:[0,10,1] type:#integer
		radioButtons	opt_rdoImFil	"File:" 				pos:[192,294] 	width:112 	height:46 	tooltip:_optFilTT columns:1 	labels:#("One file", "One file per frame")
		button 			opt_btnImDef 	"Default" 				pos:[192,352] 	width:128 	height:16

		button 			opt_btnToLeft 	">" 					pos:[160,16]	width:16 	height:56 	tooltip:"Copy the Import settings from the Export settings."
		button 			opt_btnToRight 	"<" 					pos:[160,80] 	width:16 	height:56 	tooltip:"Copy the Export settings from the Import settings."
		checkbutton 	opt_btnSame 	"=" 					pos:[160,144] 	width:14 	height:56 	tooltip:"Same settings in both sides."

		button 			opt_btnCancel 	"Cancel" 				pos:[8,378] 	width:152 	height:24   tooltip:"Cancel (don't save)"
		button 			opt_btnSave 	"Save" 					pos:[176,378] 	width:152 	height:24   tooltip:"Save"

		function FNpointCacheOptionsSaveIn =
		(
			_defPCO_EXP_typ = opt_rdoExTyp.state
			_defPCO_EXP_mod = opt_rdoExMod.state
			_defPCO_EXP_tur = opt_rdoExTur.state
			_defPCO_EXP_val = opt_spnExTur.value
			_defPCO_EXP_iso = opt_rdoExIso.state
			_defPCO_EXP_fil = opt_rdoExFil.state

			_defPCO_IMP_typ = opt_rdoImTyp.state
			_defPCO_IMP_mod = opt_rdoImMod.state
			_defPCO_IMP_tur = opt_rdoImTur.state
			_defPCO_IMP_val = opt_spnImTur.value
			_defPCO_IMP_iso = opt_rdoImIso.state
			_defPCO_IMP_fil = opt_rdoImFil.state

			_defPCO_same 	= opt_btnSame.checked

			setIniSetting _iniPref "PointCache_Options" "export_pointcache_type" (_defPCO_EXP_typ as string)
			setIniSetting _iniPref "PointCache_Options" "export_pointcache_modifier" (_defPCO_EXP_mod as string)
			setIniSetting _iniPref "PointCache_Options" "export_pointcache_turbosmooth" (_defPCO_EXP_tur as string)
			setIniSetting _iniPref "PointCache_Options" "export_pointcache_turbosmooth_overwrite_value" (_defPCO_EXP_val as string)
			setIniSetting _iniPref "PointCache_Options" "export_pointcache_isolineDisplay" (_defPCO_EXP_iso as string)
			setIniSetting _iniPref "PointCache_Options" "export_pointcache_fileCount" (_defPCO_EXP_fil as string)

			setIniSetting _iniPref "PointCache_Options" "import_pointcache_type" (_defPCO_IMP_typ as string)
			setIniSetting _iniPref "PointCache_Options" "import_pointcache_modifier" (_defPCO_IMP_mod as string)
			setIniSetting _iniPref "PointCache_Options" "import_pointcache_turbosmooth" (_defPCO_IMP_tur as string)
			setIniSetting _iniPref "PointCache_Options" "import_pointcache_turbosmooth_overwrite_value" (_defPCO_IMP_val as string)
			setIniSetting _iniPref "PointCache_Options" "import_pointcache_isolineDisplay" (_defPCO_IMP_iso as string)
			setIniSetting _iniPref "PointCache_Options" "import_pointcache_fileCount" (_defPCO_IMP_fil as string)

			setIniSetting _iniPref "PointCache_Options" "same_for_export_and_import" (_defPCO_same as string)
		)

		function FNisoSpnUpdate =
		(
			if opt_rdoExTur.state == 4 then (opt_spnExTur.enabled = true)
			else (opt_spnExTur.enabled = false)

			if opt_rdoImTur.state == 4 then (opt_spnImTur.enabled = true)
			else (opt_spnImTur.enabled = false)
		)
		
		on opt_btnSave pressed do
		(
			FNpointCacheOptionsSaveIn()
			destroyDialog _PCT_PreferencesPCmod
		)

		on opt_btnCancel pressed do destroyDialog _PCT_PreferencesPCmod

		on _PCT_PreferencesPCmod open do
		(
			
			if _defPCO_EXP_typ != OK do(opt_rdoExTyp.state = _defPCO_EXP_typ)
			if _defPCO_EXP_mod != OK do(opt_rdoExMod.state = _defPCO_EXP_mod)
			if _defPCO_EXP_tur != OK do(opt_rdoExTur.state = _defPCO_EXP_tur)
			if _defPCO_EXP_val != OK do(opt_spnExTur.value = _defPCO_EXP_val)
			if _defPCO_EXP_iso != OK do(opt_rdoExIso.state = _defPCO_EXP_iso)
			if _defPCO_EXP_fil != OK do(opt_rdoExFil.state = _defPCO_EXP_fil)

			if _defPCO_IMP_typ != OK do(opt_rdoImTyp.state = _defPCO_IMP_typ)
			if _defPCO_IMP_mod != OK do(opt_rdoImMod.state = _defPCO_IMP_mod)
			if _defPCO_IMP_tur != OK do(opt_rdoImTur.state = _defPCO_IMP_tur)
			if _defPCO_IMP_val != OK do(opt_spnImTur.value = _defPCO_IMP_val)
			if _defPCO_IMP_iso != OK do(opt_rdoImIso.state = _defPCO_IMP_iso)
			if _defPCO_IMP_fil != OK do(opt_rdoImFil.state = _defPCO_IMP_fil)

			if _defPCO_same != OK do(opt_btnSame.checked = _defPCO_same)

			if opt_rdoExTur.state == 4 do opt_spnExTur.enabled = true
			if opt_rdoImTur.state == 4 do opt_spnImTur.enabled = true
		)

		on opt_btnImDef pressed do
		(
			opt_rdoImMod.state = 1
			opt_rdoImTyp.state = 2
			opt_rdoImTur.state = 3
			opt_rdoImIso.state = 3
			opt_spnImTur.value = 0
			opt_rdoImFil.state = 2

			opt_btnSame.checked = false
		)

		on opt_btnExDef pressed do
		(
			opt_rdoExMod.state = 2
			opt_rdoExTyp.state = 2
			opt_rdoExTur.state = 1
			opt_rdoExIso.state = 1
			opt_spnExTur.value = 0
			opt_rdoExFil.state = 2

			opt_btnSame.checked = false
		)

		on opt_rdoImFil changed _state do
		(
			if opt_btnSame.state == true do
			(opt_rdoExFil.state = _state)
		)

		on opt_rdoExFil changed _state do
		(
			if opt_btnSame.state == true do
			(opt_rdoImFil.state = _state)
		)

		on opt_rdoImMod changed _state do
		(
			if opt_btnSame.state == true do
			(opt_rdoExMod.state = _state)
		)

		on opt_rdoImTyp changed _state do
		(
			if opt_btnSame.state == true do
			(opt_rdoExTyp.state = _state)
		)

		on opt_rdoImTur changed _state do
		(
			if opt_btnSame.state == true do
			(opt_rdoExTur.state = _state)
			FNisoSpnUpdate()
		)

		on opt_rdoImIso changed _state do
		(
			if opt_btnSame.state == true do
			(opt_rdoExIso.state = _state)
		)

		on opt_spnImTur changed _value do
		(
			if opt_btnSame.state == true do
			(opt_spnExTur.value = _value)
		)

		on opt_rdoExMod changed _state do
		(
			if opt_btnSame.state == true do
			(opt_rdoImMod.state = _state)
		)

		on opt_rdoExTyp changed _state do
		(
			if opt_btnSame.state == true do
			(opt_rdoImTyp.state = _state)
		)

		on opt_rdoExTur changed _state do
		(
			if opt_btnSame.state == true do
			(opt_rdoImTur.state = _state)
			FNisoSpnUpdate()
		)

		on opt_rdoExIso changed _state do
		(
			if opt_btnSame.state == true do
			(opt_rdoImIso.state = _state)
		)

		on opt_spnExTur changed _value do
		(
			if opt_btnSame.state == true do
			(opt_spnImTur.value = _value)
		)

		on opt_btnToRight pressed do
		(
			opt_rdoExMod.state = opt_rdoImMod.state
			opt_rdoExTyp.state = opt_rdoImTyp.state
			opt_rdoExTur.state = opt_rdoImTur.state
			opt_rdoExIso.state = opt_rdoImIso.state
			opt_spnExTur.value = opt_spnImTur.value
			opt_rdoExFil.state = opt_rdoImFil.state
			FNisoSpnUpdate()
		)

		on opt_btnToLeft pressed do
		(
			opt_rdoImMod.state = opt_rdoExMod.state
			opt_rdoImTyp.state = opt_rdoExTyp.state
			opt_rdoImTur.state = opt_rdoExTur.state
			opt_rdoImIso.state = opt_rdoExIso.state
			opt_spnImTur.value = opt_spnExTur.value
			opt_rdoImFil.state = opt_rdoExFil.state
			FNisoSpnUpdate()
		)

		on opt_btnSame changed state do
		(
			if state == true then _bool = false else _bool = true
			opt_btnToRight.enabled = _bool
			opt_btnToLeft.enabled = _bool

			opt_rdoImMod.state = opt_rdoExMod.state
			opt_rdoImTyp.state = opt_rdoExTyp.state
			opt_rdoImTur.state = opt_rdoExTur.state
			opt_rdoImIso.state = opt_rdoExIso.state
			opt_rdoImFil.state = opt_rdoExFil.state
			opt_spnImTur.value = opt_spnExTur.value
			FNisoSpnUpdate()
		)
	)
	
	function FNpointCacheOptionsSave =
		(
			_defPCO_EXP_typ = _PCT_PreferencesPCmod.opt_rdoExTyp.state
			_defPCO_EXP_mod = _PCT_PreferencesPCmod.opt_rdoExMod.state
			_defPCO_EXP_tur = _PCT_PreferencesPCmod.opt_rdoExTur.state
			_defPCO_EXP_val = _PCT_PreferencesPCmod.opt_spnExTur.value
			_defPCO_EXP_iso = _PCT_PreferencesPCmod.opt_rdoExIso.state
			_defPCO_EXP_fil = _PCT_PreferencesPCmod.opt_rdoExFil.state

			_defPCO_IMP_typ = _PCT_PreferencesPCmod.opt_rdoImTyp.state
			_defPCO_IMP_mod = _PCT_PreferencesPCmod.opt_rdoImMod.state
			_defPCO_IMP_tur = _PCT_PreferencesPCmod.opt_rdoImTur.state
			_defPCO_IMP_val = _PCT_PreferencesPCmod.opt_spnImTur.value
			_defPCO_IMP_iso = _PCT_PreferencesPCmod.opt_rdoImIso.state
			_defPCO_IMP_fil = _PCT_PreferencesPCmod.opt_rdoImFil.state

			_defPCO_same 	= _PCT_PreferencesPCmod.opt_btnSame.checked

			setIniSetting _iniPref "PointCache_Options" "export_pointcache_type" (_defPCO_EXP_typ as string)
			setIniSetting _iniPref "PointCache_Options" "export_pointcache_modifier" (_defPCO_EXP_mod as string)
			setIniSetting _iniPref "PointCache_Options" "export_pointcache_turbosmooth" (_defPCO_EXP_tur as string)
			setIniSetting _iniPref "PointCache_Options" "export_pointcache_turbosmooth_overwrite_value" (_defPCO_EXP_val as string)
			setIniSetting _iniPref "PointCache_Options" "export_pointcache_isolineDisplay" (_defPCO_EXP_iso as string)
			setIniSetting _iniPref "PointCache_Options" "export_pointcache_fileCount" (_defPCO_EXP_fil as string)

			setIniSetting _iniPref "PointCache_Options" "import_pointcache_type" (_defPCO_IMP_typ as string)
			setIniSetting _iniPref "PointCache_Options" "import_pointcache_modifier" (_defPCO_IMP_mod as string)
			setIniSetting _iniPref "PointCache_Options" "import_pointcache_turbosmooth" (_defPCO_IMP_tur as string)
			setIniSetting _iniPref "PointCache_Options" "import_pointcache_turbosmooth_overwrite_value" (_defPCO_IMP_val as string)
			setIniSetting _iniPref "PointCache_Options" "import_pointcache_isolineDisplay" (_defPCO_IMP_iso as string)
			setIniSetting _iniPref "PointCache_Options" "import_pointcache_fileCount" (_defPCO_IMP_fil as string)

			setIniSetting _iniPref "PointCache_Options" "same_for_export_and_import" (_defPCO_same as string)
		)
	

	function FNsave =
	(
		-- GET the informations that have to be saved
		_dbPath = edtDbPath.text 					-- Database path
		_cachePath = edtCachePath.text 				-- Cache path
		_autoClose = chkAutoClose.checked 			-- Autoclose
		_frameRange = rdoFrameRange.state 			-- Frame range
		_customRangeFrom = spnFromFrame.value 		-- Custom range: From
		_customRangeTo = spnToFrame.value 			-- Custom range: to
		_appearance = rdoButtons.state 				-- Icons or text
		_icons = rdoIcons.state 					-- Icons style
		_winPos = chkMemorize.checked 				-- Memorize window position
		_winLastPos									-- Window last position
		_categories = lbxAssetTypes.items 			-- Categores
		_seqPrefix = edtParsSeqPref.text 			-- Sequence Prefix
		_seqDigits = spnParsSeqDig.value 			-- Sequence Digits
		_shotPrefix = edtParsShotPref.text 			-- Shot Prefix
		_shotDigits = spnParsShotDig.value 			-- Shot Digits

		setIniSetting _iniPref "Paths" "database_path" (_dbPath as string)
		setIniSetting _iniPref "Paths" "cache_path" (_cachePath as string)
		
		setIniSetting _iniPref "UI_Options" "autoclose" (_autoClose as string)
		setIniSetting _iniPref "UI_Options" "framerange_type" (_frameRange as string)
		setIniSetting _iniPref "UI_Options" "custom_range_from" (_customRangeFrom as string)
		setIniSetting _iniPref "UI_Options" "custom_range_to" (_customRangeTo as string)
		setIniSetting _iniPref "UI_Options" "appearance" (_appearance as string)
		setIniSetting _iniPref "UI_Options" "icons_type" (_icons as string)
		
		setIniSetting _iniPref "Window_position" "save" (_winPos as string)
		setIniSetting _iniPref "Window_position" "position" (_winLastPos as string)

		setIniSetting _iniPref "Categories" "categories" (_categories as string)
		
		setIniSetting _iniPref "SEQ_SHOT" "sequence_prefix" (_seqPrefix as string)
		setIniSetting _iniPref "SEQ_SHOT" "sequence_digits" (_seqDigits as string)
		setIniSetting _iniPref "SEQ_SHOT" "shot_prefix" (_shotPrefix as string)
		setIniSetting _iniPref "SEQ_SHOT" "shot_digits" (_shotDigits as string)

	)

	function FNmajExample =
	(
		_001 = "A_"
		_002 = edtParsSeqPref.text
		_003 = ""
		for i = 1 to spnParsSeqDig.value do _003 = _003 + "#"
		_004 = "_"
		_005 = edtParsShotPref.text
		_006 = ""
		for i = 1 to spnParsShotDig.value do _006 = _006 + "#"
		_007 = "_revision02.max"
		_example = _001 + _002 + _003 + _004 + _005 + _006 + _007
		edtParsEx.text = _example
	)

	function FNmajUI =
	(
		if rdoFrameRange.state == 1 then -- "From time slider" is selected
		(
			spnFromFrame.enabled = false
			lblToFrame.enabled = false
			spnToFrame.enabled = false
		)
		else -- "Custom" is selected
		(
			spnFromFrame.enabled = true
			lblToFrame.enabled = true
			spnToFrame.enabled = true
		)

		if rdoButtons.state == 1 then -- Icons
		(
			rdoIcons.enabled = true
		)
		else -- Text
		(
			rdoIcons.enabled = false
		)
	)

	function FNmajIcon =
	(
		FNupdateIconSrc rdoIcons.state
		if rdoButtons.state == 1 do -- Icons
		(
			btnCacheBrowse.images = 		#(_iconsFile,_iconsFile,32,1,17,1,1)
			btnDbBrowse.images = 			#(_iconsFile,_iconsFile,32,1,17,1,1)
			btnAddPreset.images = 			#(_iconsFile,_iconsFile,32,5,21,1,1)
			btnDeletePreset.images =		#(_iconsFile,_iconsFile,32,11,27,1,1)
			btnCancel.images = 				#(_iconsFile,_iconsFile,32,4,20,1,1)
			btnSave.images = 				#(_iconsFile,_iconsFile,32,6,22,1,1)
			btnCacheOptions.images = 		#(_icons2File,_icons2File,42,6,20,6,20)
		)
		if rdoButtons.state == 2 do -- Text
		(
			btnCacheBrowse.images = 	undefined
			btnDbBrowse.images = 		undefined
			btnAddPreset.images = 		undefined
			btnDeletePreset.images = 	undefined
			btnCancel.images = 			undefined
			btnSave.images = 			undefined
			btnCacheOptions.images = 	undefined
		)
	)

	on _PCT_Preferences open do
	(
		if _firstLaunch == true then
		(
			btnCancel.enabled = false
			btnCancel.visible = false
			btnSave.pos = [8,572]
			edtDbPath.text = _tmpDbDir
			chkAutoClose.checked = _defautoClose
			rdoFrameRange.state = _defframeRange
			spnFromFrame.value = _defcustomRangeFrom
			spnToFrame.value = _defcustomRangeTo
			rdoButtons.state = _defappearance
			rdoIcons.state = _deficons
			chkMemorize.checked = _defwinPos
			_winLastPos = _defwinLastPos
			lbxAssetTypes.items = _defcategories
			FNmajIcon()
		)
		else
		(
			edtDbPath.text = _defdbDir
			edtCachePath.text = _defcacheDir
			chkAutoClose.checked = _defautoClose
			rdoFrameRange.state = _defframeRange
			spnFromFrame.value = _defcustomRangeFrom
			spnToFrame.value = _defcustomRangeTo
			rdoButtons.state = _defappearance
			rdoIcons.state = _deficons
			chkMemorize.checked = _defwinPos
			_winLastPos = _defwinLastPos
			lbxAssetTypes.items = _defcategories
			edtParsSeqPref.text = _defseqPrefix
			spnParsSeqDig.value = _defseqDigits
			edtParsShotPref.text = _defshotPrefix
			spnParsShotDig.value = _defshotDigits
			FNmajExample()

			FNmajIcon()

		)
		FNmajUI()
	)

	on btnCacheOptions pressed do
	(
		try(DestroyDialog ::_PCT_PreferencesPCmod) catch()

		FNupdateIconSrc rdoIcons.state
		--print _iconsFile
		createDialog _PCT_PreferencesPCmod
		if rdoButtons.state == 1 then -- Icons
		(
			_PCT_PreferencesPCmod.opt_btnCancel.images = 	#(_iconsFile,_iconsFile,32,4,20,1,1)
			_PCT_PreferencesPCmod.opt_btnSave.images = 		#(_iconsFile,_iconsFile,32,6,22,1,1)
		)
		else -- Text
		(
			_PCT_PreferencesPCmod.opt_btnCancel.images = 	undefined
			_PCT_PreferencesPCmod.opt_btnSave.images = 		undefined
		)
	)

	on rdoIcons changed state do FNmajIcon()

	on btnAddPreset pressed do
	(
		if edtAssetsTypes.text != undefined and edtAssetsTypes.text != "" and edtAssetsTypes.text != " " do 
		(
			_alreadyThere = false
			for _item in lbxAssetTypes.items do
			(
				if _item == edtAssetsTypes.text do
				(
					print "This name already exists"
					_alreadyThere = true
				)
			)
			if _alreadyThere == false do
			(
				lbxAssetTypes.items = append lbxAssetTypes.items edtAssetsTypes.text 
			)
		)
	)

	on btnDeletePreset pressed do
	(
		if lbxAssetTypes.items.count > 0 and lbxAssetTypes.selection > 0 do
		(
    		lbxAssetTypes.items = deleteItem lbxAssetTypes.items lbxAssetTypes.selection
    	)
	)

	on rdoFrameRange changed value do
	(
		FNmajUI()
	)

	on rdoButtons changed value do
	(
		FNmajUI()
		FNmajIcon()
	)

	on edtParsSeqPref changed value do
	(
		FNmajExample()
	)

	on spnParsSeqDig changed value do
	(
		FNmajExample()
	)

	on edtParsShotPref changed value do
	(
		FNmajExample()
	)

	on spnParsShotDig changed value do
	(
		FNmajExample()
	)

	on btnDbBrowse pressed do
	(
		_temp = getSavepath initialDir:_maxRootDir
		if _temp != undefined do edtDbPath.text = _temp + "\\"
	)

	on btnCacheBrowse pressed do
	(
		_temp = getSavepath initialDir:_maxRootDir
		if _temp != undefined do edtCachePath.text = _temp + "\\"
	)

	on btnCancel pressed do
	(
		destroyDialog _PCT_Preferences
		fileIn _mainScript
	)

	on btnSave pressed do
	(
		_checkDefCachePath = ((dotnetclass "System.IO.Directory").exists edtCachePath.text)
		_checkDefDbPath = ((dotnetclass "System.IO.Directory").exists edtDbPath.text)
		_checkCategroies = lbxAssetTypes.items

		_valid = true

		_message = "The following issues have been encountered:\n\n"
		if _checkDefCachePath == false do
		(
			_message = _message + "- Default Pointcache folder is invalid.\n"
			_valid = false
		)
		if _checkDefDbPath == false do
		(
			_message = _message + "- Default Database folder is invalid.\n"
			_valid = false
		)

		if _checkCategroies.count == 0 do
		(
			_message = _message + "- At least one category must be created.\n"
			_valid = false
		)

		if edtParsSeqPref.text == "" or edtParsSeqPref.text == undefined do
		(
			_message = _message + "- You have to specify a sequence prefix.\n"
			_valid = false
		)

		if edtParsShotPref.text == "" or edtParsShotPref.text == undefined do
		(
			_message = _message + "- You have to specify a shot prefix.\n"
			_valid = false
		)

		if spnParsSeqDig.value == 0 do
		(
			_message = _message + "- At least one digit for the sequence is necessary.\n"
			_valid = false
		)

		if spnParsShotDig.value == 0 do
		(
			_message = _message + "- At least one digit for the shot is necessary.\n"
			_valid = false
		)

		if _valid == false do messageBox _message title:"Pointcache Tool" beep:false

		if _valid == true do
		(
			FNsave()
			FNpointCacheOptionsSave()
			destroyDialog _PCT_Preferences
			fileIn _mainScript
		)
		
	)
)

createDialog _PCT_Preferences