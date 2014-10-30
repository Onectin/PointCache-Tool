-- Pointcache Tool
-- v0.1b
-- 01/11/2014
-- onectin@onectin.fr
-- --------------------------
-- pointcacheTool.ms


-- Kill  any other window from PCT
try(DestroyDialog ::_PCT_MainUi) catch()
try(DestroyDialog ::_PCT_Preset) catch()
try(DestroyDialog ::_PCT_Preferences) catch()
try(DestroyDialog ::_PCT_Preferences._PCT_PreferencesPCmod) catch()
try(DestroyDialog ::_PCT_MainUi._PCT_Browse) catch()
try(DestroyDialog ::_PCT_MainUi._PCT_Preset) catch()
try(DestroyDialog ::_PCT_MainUi._PCT_Preferences) catch()

_scriptDir = getDir #userScripts

_PCT_dir = _scriptDir + "\\pointCacheTool"

_presetDir = _PCT_dir + "\\presets\\"
_iconsDir = _PCT_dir + "\\img"

global _iniPref = _PCT_dir + "\\preferences.ini"
_prefScript = _PCT_dir + "\\preferences.ms"
_aboutImg = _iconsDir + "\\about.jpg"

 _checkPrefFile = getFiles _iniPref

global _defdbDir = ""
global _defcacheDir = ""
--global _defdefaultCacheType = ""
global _defautoClose = ""
global _defframeRange = ""
global _defcustomRangeFrom = ""
global _defcustomRangeTo = ""
global _defappearance = ""
global _deficons = ""
global _defwinPos = ""
global _defwinLastPos = ""
global _defcategories = ""
global _defseqPrefix = ""
global _defseqDigits = ""
global _defshotPrefix = ""
global _defshotDigits = ""

global defToogleAssetSel = ""
global defToogleAsset = ""
global defAutoDet = ""
global defExportToogle = ""
global defImportToogle = ""

global _initName = ""
global _seq = ""
global _shot = ""

global _exportQueue = #()

function FNmsgBox _message =
(
	messageBox _message beep:false title:"Pointcache Tool"
)


if _checkPrefFile.count == 0 then
(
	_prefScript = _PCT_dir + "\\preferences.ms"
	print _PCT_dir
	_message = "Can't find preference file:\n" + _prefScript + "\n\n Let's configure it !"
	FNmsgBox _message
	fileIn _prefScript
)
else
(
	global _defdbDir = 				getIniSetting _iniPref "Paths" "database_path"
	global _defcacheDir = 			getIniSetting _iniPref "Paths" "cache_path"

	--global _defdefaultCacheType = 	execute(getIniSetting _iniPref "UI_Options" "default_pointcache_type")
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

	global defToogleAssetSel = 		execute(getIniSetting _iniPref "Auto_UI" "default_state_toogleAssetSelection_button")
	global defToogleAsset = 		execute(getIniSetting _iniPref "Auto_UI" "default_state_toogleAsset_button")
	global defAutoDet = 			execute(getIniSetting _iniPref "Auto_UI" "default_state_autoDetection_button")
	global defExportToogle = 		execute(getIniSetting _iniPref "Auto_UI" "default_state_checkExport")
	global defImportToogle = 		execute(getIniSetting _iniPref "Auto_UI" "default_state_checkImport")

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

	
	if _deficons == 1 then -- Dark
	(
		_iconsFile = _iconsDir + "\\PCT_darkIcons.bmp"
		_icons2File = _iconsDir + "\\PCT_darkIcons2.bmp"
		_iconBTNexport = _iconsDir + "\\PCT_btnExport.bmp"
		_iconBTNimport = _iconsDir + "\\PCT_btnIMport.bmp"
	)
	else -- Bright
	(
		_iconsFile = _iconsDir + "\\PCT_brightIcons.bmp"
		_icons2File = _iconsDir + "\\PCT_brightIcons2.bmp"
		_iconBTNexport = _iconsDir + "\\PCT_btnExport.bmp"
		_iconBTNimport = _iconsDir + "\\PCT_btnIMport.bmp"
	)

	if _defframeRange == 1 then -- Time slider
	(
		_startFrame = animationRange.start
		_endFrame = animationRange.end
	)
	else -- Custom range
	(
		_startFrame = _defcustomRangeFrom
		_endFrame = _defcustomRangeTo
	)

	function FNseqShot =
	(
		_currentFileName = maxFileName
		_seqStr = findString _currentFileName _defseqPrefix
		_shotStr = findString _currentFileName _defshotPrefix

		_seqStrLght = _defseqPrefix.count
		_shotStrLght = _defshotPrefix.count
		
		if _seqStr != undefined and _shotStr != undefined do
		(
			_seq = substring _currentFileName (_seqStr + _seqStrLght) _defseqDigits
			_shot = substring _currentFileName (_shotStr + _shotStrLght) _defshotDigits
		)
	)

	function FNtoString _array =
	(
		_out = "#("
		for _item in _array do
		(
			_out = _out + "\"" + (_item as string) + "\", "
		)
		_outCount = _out.count
		_outCount = _outCount - 2
		_out =  substring _out 1 _outCount
	
		_out = _out + ")"
	
		return _out
	)

	function FNcreateDbFile _dbPath _seqNb _shotNb _dbFileName =
	(
		_seqNbStr = _seqNb as string
		_shotNbStr = _shotNb as string
		_dirName = _defseqPrefix + _seqNbStr + "_" + _defshotPrefix + _shotNbStr + "\\"
		_DBdir = _dbPath + "\\" + _dirName
	
		_fileName = _dbFileName + ".oct"
		_DBfile = _DBdir + _fileName
	
		_checkSHOTPath = ((dotnetclass "System.IO.Directory").exists _DBdir)
		if _checkSHOTPath == false do makeDir _DBdir

		if  (doesFileExist _DBfile) == true do	deleteFile _DBfile
	
		_createFile = createFile _DBfile
		flush _createFile
		close _createFile
	
		_tempOpenFile = openFile _DBfile mode:"r+"
	
		flush _tempOpenFile
		close _tempOpenFile
	)

	function FNsetPC _name _path _start _end _objects =
	(
		_checkPath = ((dotnetclass "System.IO.Directory").exists _path)
		if _checkPath == false do makeDir _path

		for obj in _objects do
		(
			if _defPCO_EXP_typ == 1 do 
			(
				_modClass = Point_CacheSpacewarpModifier
				_modifier = undefined
				_modifier = Point_CacheSpacewarpModifier()
			)
			if _defPCO_EXP_typ == 2 do 
			(
				_modClass = Point_Cache
				_modifier = undefined
				_modifier = Point_Cache()
			)

			_objExec = execute ("$" + obj)
			if _objExec != undefined then
			(
				_objName = _objExec.name
				_objPath = _path + _objName
				_checkPCPath = ((dotnetclass "System.IO.Directory").exists _objPath)
				if _checkPCPath == false do makeDir _objPath
				_pcPath = _objPath + "\\" + _objName + ".xml"
				print _pcPath
				print _objExec
				if _defPCO_EXP_mod == 1 do -- Use existing
				(
					print "Use Existing"
					_modFound = false
					for _theModifier in _objExec.modifiers where classOf _theModifier == Point_CacheSpacewarpModifier do
					(
						_modFound = true
						_objExec.Point_Cache_Binding.fileName = _pcPath
						_objExec.Point_Cache_Binding.fileCount = 1
						_objExec.Point_Cache_Binding.recordStart = _start
						_objExec.Point_Cache_Binding.recordEnd = _end
						_objExec.Point_Cache_Binding.relativeOffset = off
					)

					for _theModifier in _objExec.modifiers where classOf _theModifier == Point_Cache do
					(
						_modFound = true
						_objExec.Point_Cache.fileName = _pcPath
						_objExec.Point_Cache.fileCount = 1
						_objExec.Point_Cache.recordStart = _start
						_objExec.Point_Cache.recordEnd = _end
						_objExec.Point_Cache.relativeOffset = off
					)

					if _modFound == false do print (">>> WARNING: No pointcache modifier found on " + _objName + ". This object won't be cached.")
				)

				if _defPCO_EXP_mod == 2 do -- Add new
				(
					-- Delete Old one
					for _theModifier in _objExec.modifiers where classOf _theModifier == _modClass do
					(
						deleteModifier _objExec _theModifier
					)

					addmodifier _objExec _modifier

					recordFile = _defPCO_EXP_fil as integer
					recordFile = recordFile - 1

					if _defPCO_EXP_typ == 1 do 
					( 
						_objExec.Point_Cache_Binding.fileName = _pcPath
						_objExec.Point_Cache_Binding.fileCount = recordFile
						_objExec.Point_Cache_Binding.recordStart = _start
						_objExec.Point_Cache_Binding.recordEnd = _end
						_objExec.Point_Cache_Binding.relativeOffset = off
					)
					if _defPCO_EXP_typ == 2 do 
					(
						_objExec.Point_Cache.fileName = _pcPath
						_objExec.Point_Cache.fileCount = recordFile
						_objExec.Point_Cache.recordStart = _start
						_objExec.Point_Cache.recordEnd = _end
						_objExec.Point_Cache.relativeOffset = off
					)
				)

			)
			else
			(
				print (">>> WARNING: " + obj + " can't be found.")
			)
		)
	)

	function FNsetTurbosmoothEXP _objects =
	(
		for i in _objects do 
		(
			_exeI = execute ("$" + i)
			if _defPCO_EXP_tur == 1 do-- Disable All
			(
				if _exeI.modifiers[#turbosmooth] != undefined do(_exeI.modifiers[#turbosmooth].enabled = false)
				if _exeI.modifiers[#TurboSmoothPro] != undefined do(_exeI.modifiers[#TurboSmoothPro].enabled = false)
			)
			if _defPCO_EXP_tur == 2 do-- Enabled All
			(
				if _exeI.modifiers[#turbosmooth] != undefined do(_exeI.modifiers[#turbosmooth].enabled = true)
				if _exeI.modifiers[#TurboSmoothPro] != undefined do(_exeI.modifiers[#TurboSmoothPro].enabled = true)
			)
			if _defPCO_EXP_tur == 4 do-- Custom value
			(
				if _exeI.modifiers[#turbosmooth] != undefined do(_exeI.modifiers[#turbosmooth].iterations = _defPCO_EXP_val)
				if _exeI.modifiers[#TurboSmoothPro] != undefined do(_exeI.modifiers[#TurboSmoothPro].iterations = _defPCO_EXP_val)
			)
			if _defPCO_EXP_iso == 1 do-- Disable Isoline Display
			(
				if _exeI.modifiers[#turbosmooth] != undefined do(_exeI.modifiers[#turbosmooth].isolineDisplay = false)
				if _exeI.modifiers[#TurboSmoothPro] != undefined do(_exeI.modifiers[#TurboSmoothPro].isolineDisplay = 1)
			)
			if _defPCO_EXP_iso == 2 do-- Enable Isoline Display
			(
				if _exeI.modifiers[#turbosmooth] != undefined do(_exeI.modifiers[#turbosmooth].isolineDisplay = true)
				if _exeI.modifiers[#TurboSmoothPro] != undefined do(_exeI.modifiers[#TurboSmoothPro].isolineDisplay = 0)
			)
		)
	)

	function FNsetTurbosmoothIMP _objects =
	(
		for i in _objects do 
		(
			_exeI = execute ("$" + i)
			if _defPCO_IMP_tur == 1 do-- Disable All
			(
				if _exeI.modifiers[#turbosmooth] != undefined do(_exeI.modifiers[#turbosmooth].enabled = false)
				if _exeI.modifiers[#TurboSmoothPro] != undefined do(_exeI.modifiers[#TurboSmoothPro].enabled = false)
			)
			if _defPCO_IMP_tur == 2 do-- Enabled All
			(
				if _exeI.modifiers[#turbosmooth] != undefined do(_exeI.modifiers[#turbosmooth].enabled = true)
				if _exeI.modifiers[#TurboSmoothPro] != undefined do(_exeI.modifiers[#TurboSmoothPro].enabled = true)
			)
			if _defPCO_IMP_tur == 4 do-- Custom value
			(
				if _exeI.modifiers[#turbosmooth] != undefined do(_exeI.modifiers[#turbosmooth].iterations = _defPCO_IMP_val)
				if _exeI.modifiers[#TurboSmoothPro] != undefined do(_exeI.modifiers[#TurboSmoothPro].iterations = _defPCO_IMP_val)
			)
			if _defPCO_IMP_iso == 1 do-- Disable Isoline Display
			(
				if _exeI.modifiers[#turbosmooth] != undefined do(_exeI.modifiers[#turbosmooth].isolineDisplay = false)
				if _exeI.modifiers[#TurboSmoothPro] != undefined do(_exeI.modifiers[#TurboSmoothPro].isolineDisplay = 0)
			)
			if _defPCO_IMP_iso == 2 do-- Enable Isoline Display
			(
				if _exeI.modifiers[#turbosmooth] != undefined do(_exeI.modifiers[#turbosmooth].isolineDisplay = true)
				if _exeI.modifiers[#TurboSmoothPro] != undefined do(_exeI.modifiers[#TurboSmoothPro].isolineDisplay = 1)
			)
		)
	)

	function FNrecordPC _objects =
	(
		for obj in _objects do
		(
			_objExec = execute ("$" + obj)
			if _objExec != undefined then
			(
				_WSM = false
				_OSM = false
				for m in _objExec.modifiers do 
				(
					if classOf m == Point_CacheSpacewarpModifier do 
					(
						_WSM = true
						print "WSM"
					)
					if classOf m == Point_Cache do 
					(
						_OSM = true
						print "OSM"
					)
				)
				if _WSM != false do 
				(
					_objExec.Point_Cache_Binding.enabled = true
					cacheOps.recordcache _objExec.Point_Cache_Binding
					_objExec.Point_Cache_Binding.enabled = false
				)

				if _OSM != false do 
				(
					_objExec.Point_Cache.enabled = true
					cacheOps.recordcache _objExec.Point_Cache
					_objExec.Point_Cache.enabled = false
				)
			)
			else
			(
				print (">>> WARNING: " + obj + " can't be found.")
			)
		)
	)


	rollout _PCT_MainUi "Pointcache Tool"
	(
		checkbutton 	chkBtnEXPORT 				"EXPORT" 					pos:[8,8] 		width:134 	height:24 tooltip:"Toogle display export options" checked:true
		checkbutton 	chkBtnIMPORT 				"IMPORT" 					pos:[146,8] 	width:134 	height:24 tooltip:"Toogle display import options" checked:true

		groupBox 		grpAsset 					"Asset" 					pos:[8,38] 		width:272 	height:184
		radioButtons 	rdoAssetMethod				"" 							pos:[16,54] 	width:262 	height:16 labels:#("By categories", "By detection", "By name") columns:3 default:1
		
		dropDownList 	ddlCatAsset 				"" 							pos:[16,78] 	width:256 	height:21 items:_defcategories selection:1
		listBox 		lbxCatAsset 				"" 							pos:[16,102] 	width:190 	height:6

		editText 		edtNmeAsset 				"" 							pos:[12,78] 	width:260 	height:21
		listBox 		lbxNmeAsset 				"" 							pos:[16,102] 	width:190 	height:6

		button 			btnUsePreset 				"Add to queue" 				pos:[16,192] 	width:190 	height:24 tooltip:"Add selected asset to queue\n\nTip: Use rightclick to add all the assets from the list."
		checkbutton 	btnMngPreset 				"Manage" 					pos:[208,192] 	width:64 	height:24 tooltip:"Manage presets"

		listBox 		lbxDetAsset 				"" 							pos:[16,102] 	width:256 	height:6
		label 			lblDetAssetAuto 			"Auto." 					pos:[230,80] 	width:30 	height:16 tooltip:"Warning: this features"
		checkbox 		chkDetAssetAuto 			"" 							pos:[210,80] 	width:16 	height:16
		button 			btnDetAsset 				"Detect" 					pos:[16,78] 	width:190 	height:21 tooltip:"Detect"

		button 			btnAddPreset 				"Add" 						pos:[208,102] 	width:64 	height:24 tooltip:"Add a new asset..."
		button 			btnEditPreset 				"Edit" 						pos:[208,132] 	width:64 	height:24 tooltip:"Edit selected asset..."
		button 			btnDeletePreset 			"Delete" 					pos:[208,162] 	width:64 	height:24 tooltip:"Delete selected asset"
							
		groupBox 		grpExport 					"Export" 					pos:[8,224] 	width:272 	height:208
		listBox 		lbxExportList 				"" 							pos:[16,240] 	width:190 	height:6 
		button 			btnExportBrowse 			"Path..." 					pos:[208,328] 	width:64 	height:24 tooltip:"Export path..."
		label 			edtSeqEx 					"" 							pos:[210,254] 	width:68 	height:24
		label 			lblSeqEx 					"SEQUENCE:" 				pos:[210,238] 	width:64 	height:16
		label 			edtShotEx 					"" 							pos:[210,296] 	width:68 	height:24
		label 			lblShotEx 					"SHOT:" 					pos:[210,280] 	width:64 	height:16
		button 			btnRemoveQueue 				"Remove" 					pos:[16,328] 	width:190 	height:24 tooltip:"Remove from export queue\n\nTip: Use rightclick to remove all the assets from the list."

		
		groupBox 		grpRange 					"Range" 					pos:[16,352] 	width:256 	height:40
		label 			lblFromFrame 				"From frame:" 				pos:[22,368] 	width:64 	height:16
		spinner 		spnFromFrame 				"" 							pos:[94,368] 	width:64 	height:16 range:[0,10000,1] type:#integer
		label 			lblToFrame 					"to:" 						pos:[176,368] 	width:16 	height:16
		spinner 		spnToFrame 					"" 							pos:[200,368] 	width:64 	height:16 range:[0,10000,1] type:#integer
		button 			btnExport 					"EXPORT CACHE" 				pos:[16,400] 	width:256 	height:24 tooltip:"Export cache"
						
		groupBox 		grpImport 					"Import" 					pos:[8,440] 	width:272 	height:192
		label 			lblSeqIm 					"SEQUENCE:" 				pos:[16,456] 	width:104 	height:16
		label 			lblShotIm 					"SHOT:" 					pos:[152,456] 	width:104 	height:16
		dropDownList 	ddlSeqIm 					"" 							pos:[16,475] 	width:120 	height:21
		dropDownList 	ddlShotIm 					"" 							pos:[152,475] 	width:120 	height:21
		listBox 		lbxCatAssetIm 				"" 							pos:[16,500] 	width:256 	height:7
		button 			btnMerge 					"MERGE ASSET" 				pos:[16,602] 	width:120 	height:24 tooltip:"Merge selected asset(s)"
		button 			btnImport 					"IMPORT CACHE" 				pos:[152,602] 	width:120 	height:24 tooltip:"Import selected asset(s)'s cache"
		
		button 			btnPrefs 					"Preference..." 			pos:[8,638] 	width:86 	height:24 tooltip:"Preferences..."
		button 			btnAbout 					"About..." 					pos:[101,638] 	width:86 	height:24 tooltip:"About..."
		button 			btnClose 					"Close" 					pos:[194,638] 	width:86 	height:24 tooltip:"Close"
		

		checkbox 		chkAutoClose 				"" 							pos:[-1000,-1000] 	width:16 	height:16
		radioButtons 	rdoPcType 					"" 							pos:[-1000,-1000] 	width:262 	height:16 labels:#("WSM Pointcache", "OSM Pointcache") columns:2
		radioButtons 	rdoPcTypeImport				"" 							pos:[-1000,-1000] 	width:262 	height:16 labels:#("WSM Pointcache", "OSM Pointcache") columns:2
		label 			lblExportPath 				"" 							pos:[-1000,-1000] 	width:104 	height:16
		editText 		edtExportPath 				"" 							pos:[-1000,-1000] 	width:188 	height:24

		on btnClose pressed do destroyDialog _PCT_MainUi		

		function FNtoogleManageAssets _bool=
		(
			if _bool == true then _antibool = false else _antibool = true
			if _bool == true then _lenght = 190 else _lenght = 256

			btnAddPreset.visible = _bool
			btnEditPreset.visible = _bool
			btnDeletePreset.visible = _bool

			lbxCatAsset.width = _lenght
			lbxDetAsset.width = _lenght
			lbxNmeAsset.width = _lenght
		)

		function FNtoogleAssetSelectionEnabled _bool =
		(
			grpAsset.enabled = _bool
			rdoAssetMethod.enabled = _bool
			ddlCatAsset.enabled = _bool
			lbxCatAsset.enabled = _bool
			btnMngPreset.enabled = _bool
			lbxDetAsset.enabled = _bool
			edtNmeAsset.enabled = _bool
			lbxNmeAsset.enabled = _bool
			btnDetAsset.enabled = _bool
			lblDetAssetAuto.enabled = _bool
			chkDetAssetAuto.enabled = _bool
			btnAddPreset.enabled = _bool
			btnEditPreset.enabled = _bool
			btnDeletePreset.enabled = _bool
		)

		function FNgetSeqList =
		(
			_listDbDir = getDirectories (_defdbDir+"/*")
			_listDbDirParsed = #()
			for i in _listDbDir do
			(
				i = filterString i "\\"
				iCount = i.count
				_listDbDirParsed = append _listDbDirParsed i[iCount]
	
			)
	
			_listSeq = #()

			for o in _listDbDirParsed do
			(
				o = filterString o "_"
				_listSeq = append _listSeq o[1]
			)
			_listSeq = makeUniqueArray _listSeq
			return _listSeq
		)
	
		function FNgetShotList _selSeq =
		(
			_listDbDir = getDirectories (_defdbDir+"/*")
			_listDbDirParsed = #()
			for i in _listDbDir do
			(
				i = filterString i "\\"
				iCount = i.count
				_listDbDirParsed = append _listDbDirParsed i[iCount]
			)
	
			_listShot = #()
			for o in _listDbDirParsed do
			(
				o = filterString o "_"
				if o[1] == _selSeq do _listShot = append _listShot o[2]
			)
			_listShot = makeUniqueArray _listShot
			return _listShot
		)

		function FNloadSelectedFile =
		(
			_selectedSeq = ddlSeqIm.selected
			_selectedShot = ddlShotIm.selected
			_dirName = _defdbDir + "\\" + _selectedSeq + "_" + _selectedShot + "\\"
	
			_listDbFiles = getFiles (_dirName+"*.oct")
			
			infoList = #()
			for i in _listDbFiles do
			(
				i = trimright i "oct"
				i = trimright i "."
				i = filterstring i "\\"
				iCount = i.count
				infoList = append infoList i[iCount]
			)
			lbxCatAssetIm.items = infoList	
		)

		function FNimportPointCache _meshArray _assetName =
		(

			FNsetTurbosmoothIMP _meshArray

			_selectedSeq = ddlSeqIm.selected
			_selectedShot = ddlShotIm.selected
	
			_currentCachePath = _defcacheDir + _selectedSeq + "\\" + _selectedShot + "\\"
	
			-- MODIFIER: OSM --

			if _defPCO_IMP_typ == 1 do 
			(
				_modClass = Point_CacheSpacewarpModifier
				_modifier = undefined
				_modifier = Point_CacheSpacewarpModifier()
			)
			if _defPCO_IMP_typ == 2 do 
			(
				_modClass = Point_Cache
				_modifier = undefined
				_modifier = Point_Cache()
			)

			_recordFile = _defPCO_EXP_fil as integer
			_recordFile = _recordFile - 1

			for i in _meshArray do
				(
					i = "$" + i
					i = execute i
					if i != undefined do
					(
						_objName = i.name
						-- Pointcache filepath
						_currentObjCacheFile = _currentCachePath + _assetName + "\\" + _objName + "\\" + _objName + ".xml"

						if _defPCO_IMP_mod == 2 do -- ADD NEW PC MOD
						(
							addmodifier i _modifier -- (_modifier)
						)

						for _pcMod in i.modifiers where classOf _pcMod == _modClass do
						(
							_pcMod.fileName = _currentObjCacheFile
							_pcMod.fileCount = _recordFile
						)
					)
				)


			/*-----------------------------------------------------
			-----------------------------------------------------
			if _defPCO_IMP_typ == 2 then
			(
				for i in _meshArray do
				(
					i = "$" + i
					i = execute i
					if i != undefined do
					(
						
						_objName = i.name
						_currentObjCacheFile = _currentCachePath + _assetName + "\\" + _objName + "\\" + _objName + ".xml"

						for _pcMod in i.modifiers where classOf _pcMod == Point_Cache do
						(
							_pcMod.loadType = 0
							_pcMod.fileName = _currentObjCacheFile
							_pcMod.relativeOffset = off
						)
					)

				)
			)
			-- MODIFIER: WSM --
			else 
			(
				for i in _meshArray do
				(
					i = "$" + i
					i = execute i
					if i != undefined do
					(
						_objName = i.name
						_currentObjCacheFile = _currentCachePath + _assetName + "\\" + _objName + "\\" + _objName + ".xml"
						
						addmodifier i (Point_CacheSpacewarpModifier())
							
						for _pcMod in i.modifiers where classOf _pcMod == Point_CacheSpacewarpModifier do
						(
							_pcMod.loadType = 0
							_pcMod.fileName = _currentObjCacheFile
							_pcMod.relativeOffset = off
						)

					)

				)
			)
			-------------------------------------------------------	
			-----------------------------------------------------*/
		)

		function FNrefreshImportUI =
		(
			_getSeq = FNgetSeqList()
			ddlSeqIm.items = FNgetSeqList()

			_currentSeq = ddlSeqIm.selected
			ddlShotIm.items = FNgetShotList _currentSeq
			_itemsCount = ddlShotIm.items.count
			if _itemsCount != 0 do
			(
				FNloadSelectedFile()
			)
		)

		function FNassetListByCategory =
		(
			_curentCategory = ddlCatAsset.selected
			_presetsFiles = _presetDir + "\\*.ini"
			_listPresets = getFiles _presetsFiles
			_listPresetsClean = #()

			for i in _listPresets do
			(
				_filterPath = filterstring i "\\"
				_filterPathCount = _filterPath.count
				_temp = _filterPath[_filterPathCount]
				_tempCount = (_temp.count - 4)
				_temp = substring _temp 1 _tempCount

				_iCategory = getIniSetting i "PRESET" "CATEGORY"
				if _curentCategory == _iCategory do _listPresetsClean = append _listPresetsClean _temp

			)
			lbxCatAsset.items = _listPresetsClean
		)

		function FNassetListByDetection =
		(
			_presetsFiles = _presetDir + "\\*.ini"
			_listPresets = getFiles _presetsFiles
			_listPresetsClean = #()

			for i in _listPresets do
			(
				_filterPath = filterstring i "\\"
				_filterPathCount = _filterPath.count
				_temp = _filterPath[_filterPathCount]
				_tempCount = (_temp.count - 4)
				_temp = substring _temp 1 _tempCount

				_iObjStr = getIniSetting i "PRESET" "OBJECTS"
				_iObjArray = execute _iObjStr

				_chkBool = true
				
				for o in _iObjArray do
				(
					_exeO = execute ("$" + o)
					if _exeO == undefined do _chkBool = false
				)

				if _chkBool == true do _listPresetsClean = append _listPresetsClean _temp

			)
			lbxDetAsset.items = _listPresetsClean
		)

		function FNassetListByName =
		(
			_presetsFiles = _presetDir + "\\*.ini"
			_listPresets = getFiles _presetsFiles
			_listPresetsClean = #()
			_strToFind = edtNmeAsset.text


			for i in _listPresets do
			(
				_filterPath = filterstring i "\\"
				_filterPathCount = _filterPath.count
				_assetName = _filterPath[_filterPathCount]
				_tempCount = (_assetName.count - 4)
				_assetName = substring _assetName 1 _tempCount

				if _strToFind != "" and _strToFind != undefined then
				( 
					_searchBool = findString _assetName _strToFind
					if _searchBool != undefined do _listPresetsClean = append _listPresetsClean _assetName
				)
				else (_listPresetsClean = append _listPresetsClean _assetName)
			)

			lbxNmeAsset.items = _listPresetsClean
		)

		function FNgenerateCacheDir _assetName =
		(
			if _assetName != undefined do
			(
				_exportDir = _defcacheDir + _defseqPrefix + _seq + "\\" + _defshotPrefix + _shot + "\\" + _assetName + "\\"
				return _exportDir
			)
		)

		function FNgetSelAssetProperties =
		(
			if rdoAssetMethod.state == 1 do
			(
				_selAsset = lbxCatAsset.selected
			)
			if rdoAssetMethod.state == 2 do
			(
				_selAsset = lbxDetAsset.selected
			)
			if rdoAssetMethod.state == 3 do
			(
				_selAsset = lbxNmeAsset.selected
			)

			if _selAsset != undefined then
			(
				_selAssetFile = _presetDir + "\\" + _selAsset + ".ini"
	
				_001 = getIniSetting _selAssetFile "PRESET" "NAME"
				_002 = getIniSetting _selAssetFile "PRESET" "CATEGORY"
				_003 = getIniSetting _selAssetFile "PRESET" "PATH"
				_004 = getIniSetting _selAssetFile "PRESET" "OBJECTS"
	
				_presetValues = #(_001,_002,_003,_004)
				
				return _presetValues
			)
			else return false
		)

		function FNgetAssetProperties _asset =
		(
			_selAssetFile = _presetDir + "\\" + _asset + ".ini"

			_001 = getIniSetting _selAssetFile "PRESET" "NAME"
			_002 = getIniSetting _selAssetFile "PRESET" "CATEGORY"
			_003 = getIniSetting _selAssetFile "PRESET" "PATH"
			_004 = getIniSetting _selAssetFile "PRESET" "OBJECTS"

			_presetValues = #(_001,_002,_003,_004)
			
			return _presetValues
		)

		function FNgetSelAssetPropertiesImport =
		(
			_selAsset = lbxCatAssetIm.selected
			_selAssetFile = _presetDir + "\\" + _selAsset + ".ini"
			
			_001 = getIniSetting _selAssetFile "PRESET" "NAME"
			_002 = getIniSetting _selAssetFile "PRESET" "CATEGORY"
			_003 = getIniSetting _selAssetFile "PRESET" "PATH"
			_004 = getIniSetting _selAssetFile "PRESET" "OBJECTS"

			_presetValues = #(_001,_002,_003,_004)
			
			return _presetValues
		)

		function FNtoogleAssetSelectionUi =
		(
			if rdoAssetMethod.state == 1 do --categories 
			(
				ddlCatAsset.visible = true
				lbxCatAsset.visible = true

				lbxDetAsset.visible = false
				btnDetAsset.visible = false
				lblDetAssetAuto.visible = false
				chkDetAssetAuto.visible = false

				edtNmeAsset.visible = false
				lbxNmeAsset.visible = false
			)
			if rdoAssetMethod.state == 2 do
			(
				ddlCatAsset.visible = false
				lbxCatAsset.visible = false

				lbxDetAsset.visible = true
				btnDetAsset.visible = true
				lblDetAssetAuto.visible = true
				chkDetAssetAuto.visible = true

				edtNmeAsset.visible = false
				lbxNmeAsset.visible = false
			)

			if rdoAssetMethod.state == 3 do
			(
				ddlCatAsset.visible = false
				lbxCatAsset.visible = false

				lbxDetAsset.visible = false
				btnDetAsset.visible = false
				lblDetAssetAuto.visible = false
				chkDetAssetAuto.visible = false

				edtNmeAsset.visible = true
				lbxNmeAsset.visible = true
			)
		)

		function FNgreyExportUi _bool =
		(
			grpExport.enabled = _bool
			rdoPcType.enabled = _bool
			lblExportPath.enabled = _bool
			edtExportPath.enabled = _bool
			btnExportBrowse.enabled = _bool
			edtSeqEx.enabled = _bool
			lblSeqEx.enabled = _bool
			edtShotEx.enabled = _bool
			lblShotEx.enabled = _bool
			grpRange.enabled = _bool
			lblFromFrame.enabled = _bool
			spnFromFrame.enabled = _bool
			lblToFrame.enabled = _bool
			spnToFrame.enabled = _bool
			btnExport.enabled = _bool
			btnRemoveQueue.enabled = _bool
		)

		function FNchkAsset _assetName _msg =
		(
			_presetFile = _presetDir + "\\" + _assetName + ".ini"
			
			_objStr = getIniSetting _presetFile "PRESET" "OBJECTS"
			_objArray = execute _objStr

			_chkBool = true
			_missingObjs = #()
				
			for o in _objArray do
			(
				_exeO = execute ("$" + o)
				if _exeO == undefined do
				(
					_chkBool = false
					_missingObjs = append _missingObjs o
				)
			)

			_message = "\"" + _assetName + "\"\nThe following objects are missing:"

			for i = 1 to _missingObjs.count do
			(
				_message = _message + "\n- " + _missingObjs[i]
			)

			if _chkBool == false and _msg == true do FNmsgBox _message

			return _chkBool
		)

		function FNexportVisibility _bool =
		(
			grpExport.visible = _bool
			lbxExportList.visible = _bool
			btnExportBrowse.visible = _bool
			edtSeqEx.visible = _bool
			lblSeqEx.visible = _bool
			edtShotEx.visible = _bool
			lblShotEx.visible = _bool
			grpRange.visible = _bool
			lblFromFrame.visible = _bool
			spnFromFrame.visible = _bool
			lblToFrame.visible = _bool
			spnToFrame.visible = _bool
			btnExport.visible = _bool
			grpAsset.visible = _bool
			rdoAssetMethod.visible = _bool
			ddlCatAsset.visible = _bool
			lbxCatAsset.visible = _bool
			edtNmeAsset.visible = _bool
			lbxNmeAsset.visible = _bool
			btnUsePreset.visible = _bool
			btnMngPreset.visible = _bool
			lbxDetAsset.visible = _bool
			lblDetAssetAuto.visible = _bool
			chkDetAssetAuto.visible = _bool
			btnDetAsset.visible = _bool
			btnAddPreset.visible = _bool
			btnEditPreset.visible = _bool
			btnDeletePreset.visible = _bool
			if _bool == true do 
			(
				FNtoogleAssetSelectionUi()
				if btnMngPreset.checked == false do
				(
					btnAddPreset.visible = false
					btnEditPreset.visible = false
					btnDeletePreset.visible = false
				)
			)

		)

		function FNimportVisibility _bool =
		(
			grpImport.visible = _bool
			lblSeqIm.visible = _bool
			lblShotIm.visible = _bool
			ddlSeqIm.visible = _bool
			ddlShotIm.visible = _bool
			lbxCatAssetIm.visible = _bool
			btnMerge.visible = _bool
			btnImport.visible = _bool
		)

		function FNimportPosition _bool =
		(	
			if _bool == true then
			(
				grpImport.pos = 	[8,440]
				lblSeqIm.pos = 		[16,456]
				lblShotIm.pos = 	[152,456]
				ddlSeqIm.pos = 		[16,475]
				ddlShotIm.pos = 	[152,475]
				lbxCatAssetIm.pos = [16,500]
				btnMerge.pos = 		[16,602]
				btnImport.pos = 	[152,602]
			)
			else
			(
				grpImport.pos = 	[8,38]
				lblSeqIm.pos = 		[16,54]
				lblShotIm.pos = 	[152,54]
				ddlSeqIm.pos = 		[16,73]
				ddlShotIm.pos = 	[152,73]
				lbxCatAssetIm.pos = [16,98]
				btnMerge.pos = 		[16,200]
				btnImport.pos = 	[152,200]
			)
		)

		function FNupdateExportList =
		(
			lbxExportList.items = #()
			for i in _exportQueue do
			(
				lbxExportList.items = append lbxExportList.items i[1]
			)
		)

		function FNremoveFromQueue =
		(
			_toRemove = lbxExportList.selected
			_toDel = 0
			for i = 1 to _exportQueue.count do
			(
				_encaps = _exportQueue[i]
				_encapsName = _encaps[1]
				if _encapsName == _toRemove do _toDel = i
			)
			deleteItem _exportQueue _toDel
		)

		function FNremoveAllQueue =
		(
			_exportQueue = #()
		)

		function FNwinSize =
		(
			_imp = chkBtnIMPORT.state
			_exp = chkBtnEXPORT.state

			if _imp == true and _exp == true do
			(
				_PCT_MainUi.height = 670
				btnPrefs.pos = [8,638] 
				btnAbout.pos = [101,638]
				btnClose.pos = [194,638]
			)

			if _imp == false and _exp == true do
			(
				_PCT_MainUi.height = 468
				btnPrefs.pos = [8,438] 
				btnAbout.pos = [101,438]
				btnClose.pos = [194,438]
			)

			if _imp == true and _exp == false do
			(
				_PCT_MainUi.height = 266
				btnPrefs.pos = [8,236] 
				btnAbout.pos = [101,236]
				btnClose.pos = [194,236]
			)

			if _imp == false and _exp == false do
			(
				_PCT_MainUi.height = 68
				btnPrefs.pos = [8,38] 
				btnAbout.pos = [101,38]
				btnClose.pos = [194,38]
			)
		)

		rollout _PCT_Preset 	"Pointcache Tool: Preset" 	width:328 	height:288
		(
			groupBox 		grpPresetObjects 			"Objects" 					pos:[8,112] 	width:312 	height:136
			listBox 		lbxPresetObjects			"" 							pos:[16,128] 	width:296 	height:6
			button 			btnPresetAppendFromSel 		"Append from selection" 	pos:[16,216] 	width:144 	height:24
			button 			btnPresetReplaceFromSel		"Replace from selection" 	pos:[168,216] 	width:144 	height:24
		
			groupBox 		grpPresetAssetPreset		"Asset preset" 				pos:[8,8] 		width:312	height:102
			label 			lblPresetAssetType 			"Type:" 					pos:[16,58] 	width:64 	height:16
			dropDownList 	ddlPresetAssetType 			"" 							pos:[85,52] 	width:226 	height:21 items:_defcategories selection:1

			label 			lblPresetAssetName			"Name:" 					pos:[16,29] 	width:64 	height:16
			editText 		edtPresetAssetName			"" 							pos:[80,24] 	width:232 	height:24
			label 			lblPresetAssetPath 			"Path:" 					pos:[16,86] 	width:64 	height:16
			editText 		edtPresetAssetPath 			"" 							pos:[80,78] 	width:152 	height:24
			button 			btnPresetAssetBrowse 		"Browse..." 				pos:[240,78] 	width:71 	height:24 tooltip:"Browse..."
			
			button 			btnPresetSave 				"SAVE" 						pos:[168,256] 	width:152 	height:24 tooltip:"Save..."
			button 			btnPresetCancel 			"CANCEL" 					pos:[8,256] 	width:152 	height:24 tooltip:"Cancel..."
	
			on _PCT_Preset open do
			(
				try(DestroyDialog ::_PCT_Preset) catch()

				if _defappearance == 1 do -- Icons
				(
					btnPresetAssetBrowse.images = #(_iconsFile,_iconsFile,32,1,17,1,1) 
					btnPresetSave.images = #(_iconsFile,_iconsFile,32,6,22,1,1) 
					btnPresetCancel.images = #(_iconsFile,_iconsFile,32,4,20,1,1) 
				)
			)
	
			function FNsavePreset =
			(
				_presetName = edtPresetAssetName.text
				_presetType = ddlPresetAssetType.selected
				_presetPath = edtPresetAssetPath.text
				_presetObjsStr = lbxPresetObjects.items
				_presetObjs = FNtoString _presetObjsStr	
				
				-- We delete the old ini file if the name has changed
				if _initName != undefined do
				(
					if _presetName != _initName do 
					(
						_presetOldFile = _presetDir + "\\" + _initName + ".ini"
						deleteFile _presetOldFile
					)
				)

				_iniFile = _presetDir + "\\" + _presetName + ".ini"

				setIniSetting _iniFile "PRESET" "NAME" (_presetName as string)
				setIniSetting _iniFile "PRESET" "CATEGORY" (_presetType as string)
				setIniSetting _iniFile "PRESET" "PATH" (_presetPath as string)
				setIniSetting _iniFile "PRESET" "OBJECTS" (_presetObjs as string)	

				FNassetListByCategory()
				FNassetListByDetection()
				FNassetListByName()
			)

			on btnPresetAssetBrowse pressed do
			(
				_temp = getOpenFileName  types:"Max(*.max)|*.max|All|*.*|"
				if _temp != undefined do edtPresetAssetPath.text = _temp
			)
	
			on btnPresetReplaceFromSel pressed do
			(
				_objList = #()
				for i in selection do
				(
					_objName = i.name
					_objList = append _objList _objName
				)
	
				lbxPresetObjects.items = _objList
			)
	
			on btnPresetAppendFromSel pressed do
			(
				_objList = lbxPresetObjects.items
				for i in selection do
				(
					_objName = i.name
					_objList = append _objList _objName
				)
	
				_objList = makeUniqueArray _objList
				lbxPresetObjects.items = _objList
			)
	
			on btnPresetSave pressed do
			(
				if edtPresetAssetName.text == "" then
				(
					FNmsgBox "Name is empty."
				)
				else
				(
					if edtPresetAssetPath.text == "" then
					(
						FNmsgBox "File path is empty."
					)
					else
					(
						_checkValidFile = getFiles edtPresetAssetPath.text
						_checkValidFileCount = _checkValidFile.count
						if _checkValidFileCount == 0 then
						(
							FNmsgBox "File path is invalid."
						)
						else
						(
							_objArray = lbxPresetObjects.items
							if _objArray.count == 0 then
							(
								FNmsgBox "At least one object must be set."
							)
							else
							(
								FNsavePreset()
								destroyDialog _PCT_Preset
							)
						)
					)
				)
			)
	
			on btnPresetCancel pressed do destroyDialog _PCT_Preset
		)

		rollout _PCT_About 		"About Pointcache Tool" 	width:376 	height:380
		(
			bitmap 		bmp2 "Bitmap" 											pos:[8,8] 		width:360 	height:220 fileName:_aboutImg
			label 		lbl1 "Version: 0.1b (beta)" 							pos:[128,240] 	width:104 	height:16
			label 		lbl2 "Release date: 10/25/2014" 						pos:[117,260] 	width:128 	height:16
			HyperLink	lbl3 "Licence: GNU/GPL v3" 								pos:[128,280] 	width:104 	height:16 address:"http://www.gnu.org/licenses/gpl-3.0.en.html"
			HyperLink 	lbl5 "Project page: www.onectin.fr/pointcache-tool" 	pos:[69,300] 	width:224 	height:16 address:"http://www.onectin.fr/pointcache-tool"
			label 		lbl6 "Contact: onectin@onectin.fr" 						pos:[110,320] 	width:144 	height:16
			button 		btn1 "Close" 											pos:[8,350] 	width:360 	height:24 tooltip:"Close"

			on _PCT_About open do
			(
				try(DestroyDialog ::_PCT_About) catch()

				if _defappearance == 1 do -- Icons
				(
					btn1.images = #(_iconsFile,_iconsFile,32,7,23,7,1)
				)
			)

			on btn1 pressed do destroyDialog _PCT_About
		)

		rollout _PCT_Browse 	"Pointcache Tool: Browse" 	width:616 	height:88
		(
			editText 	edtBws 			"" 				pos:[0,24] 		width:536 	height:24
			button 		btnBwsBrowse 	"Browse..." 	pos:[544,24] 	width:64 	height:24 tooltip:"Browse..."
			label 		lblBws 			"Export path:" 	pos:[6,8] 		width:192 	height:16
			button 		btnBwsSave 		"Save" 			pos:[505,56] 	width:103 	height:24 tooltip:"Save"
			button 		btnBwsCancel 	"Cancel" 		pos:[392,56] 	width:103 	height:24 tooltip:"Cancel"
			label 		lblId 			"" 				pos:[-100,-100] width:10 	height:10

			on _PCT_Browse open do
			(
				try(DestroyDialog ::_PCT_Browse) catch()

				if _defappearance == 1 do -- Icons
				(
					btnBwsBrowse.images = #(_iconsFile,_iconsFile,32,1,17,1,1) 
					btnBwsSave.images = #(_iconsFile,_iconsFile,32,6,22,1,1) 
					btnBwsCancel.images = #(_iconsFile,_iconsFile,32,4,20,1,1) 
				)


			)

			on btnBwsBrowse pressed do
			(
				_openDir = getDir #scene
				_temp = getSavepath initialDir:_openDir
				if _temp != undefined do edtBws.text = _temp + "\\"
			)

			on btnBwsSave pressed do
			(
				_id = lblId.text as integer
				_endryToEdit = _exportQueue[_id] --= edtBws.text
				_endryToEdit[4] = edtBws.text
				_exportQueue[_id] = _endryToEdit
				destroyDialog _PCT_Browse
			)

			on btnBwsCancel pressed do
			(
				destroyDialog _PCT_Browse
			)
		)
			
		on _PCT_MainUi open do
		(
			rdoPcType.state = _defPCO_EXP_mod
			rdoPcTypeImport.state = _defPCO_IMP_mod
			chkAutoClose.checked = _defautoClose
			FNseqShot()
			edtSeqEx.text = _seq
			edtShotEx.text = _shot

			spnFromFrame.value =_startFrame
			spnToFrame.value = _endFrame
			FNrefreshImportUI()

			if _defappearance == 1 do -- Icons
			(
				btnAddPreset.images = #(_icons2File,_icons2File,42,11,25,39,1)
				btnEditPreset.images = #(_iconsFile,_iconsFile,32,16,32,16,1)
				btnDeletePreset.images = #(_iconsFile,_iconsFile,32,11,27,11,1)
				btnUsePreset.images = #(_icons2File,_icons2File,42,4,18,32,18)
				btnExportBrowse.images = #(_iconsFile,_iconsFile,32,1,17,1,1) 
				btnExport.images = #(_iconsFile,_iconsFile,32,2,18,2,1)
				btnMerge.images = #(_iconsFile,_iconsFile,32,14,30,14,1)
				btnImport.images = #(_iconsFile,_iconsFile,32,3,19,3,1)
				btnPrefs.images = #(_icons2File,_icons2File,42,2,16,2,1)
				btnAbout.images = #(_iconsFile,_iconsFile,32,8,24,8,1) 
				btnClose.images = #(_iconsFile,_iconsFile,32,7,23,7,1)
				btnDetAsset.images = #(_iconsFile,_iconsFile,32,13,29,13,1) 
				btnMngPreset.images = #(_icons2File,_icons2File,42,7,21,35,21)
				btnRemoveQueue.images = #(_iconsFile,_iconsFile,32,7,23,7,1)

				chkBtnIMPORT.images = #(_iconBTNimport,_iconBTNimport,2,1,2,1,2)
				chkBtnEXPORT.images = #(_iconBTNexport,_iconBTNexport,2,1,2,1,2)
			)

			if defToogleAssetSel != OK do rdoAssetMethod.state = defToogleAssetSel
			if defToogleAsset != OK do btnMngPreset.checked = defToogleAsset
			if defAutoDet != OK do chkDetAssetAuto.checked = defAutoDet
			if defExportToogle != OK do chkBtnEXPORT.checked = defExportToogle
			if defImportToogle != OK do chkBtnIMPORT.checked = defImportToogle

			if chkDetAssetAuto.checked == true do FNassetListByDetection()
			FNassetListByCategory()
			FNassetListByName()

			FNtoogleAssetSelectionUi()
			FNtoogleManageAssets(btnMngPreset.checked)
			FNgreyExportUi false

			FNimportVisibility chkBtnIMPORT.state
			FNexportVisibility chkBtnEXPORT.state

			FNimportPosition chkBtnEXPORT.state
			FNwinSize()
		)

		on edtNmeAsset changed value do
		(
			FNassetListByName()
		)

		on btnExportBrowse pressed do
		(
			createDialog _PCT_Browse
			_currentSelection = lbxExportList.selection
			_pathToEdit1 = _exportQueue[_currentSelection]
			_pathToEdit = _pathToEdit1[4]
			_PCT_Browse.edtBws.text = _pathToEdit
			_PCT_Browse.lblId.text = _currentSelection as string
		)

		on rdoAssetMethod changed state do 
		(
			FNtoogleAssetSelectionUi()
			setIniSetting _iniPref "Auto_UI" "default_state_toogleAssetSelection_button" (state as string)
		)

		on btnMngPreset changed state do
		(
			FNtoogleManageAssets(state)
			setIniSetting _iniPref "Auto_UI" "default_state_toogleAsset_button" (state as string)
		)

		on chkDetAssetAuto changed state do 
		(
			if state == true do FNassetListByDetection()
			setIniSetting _iniPref "Auto_UI" "default_state_autoDetection_button" (state as string)
		)

		on chkBtnIMPORT changed state do
		(
			setIniSetting _iniPref "Auto_UI" "default_state_checkImport" (state as string)
			
			FNimportVisibility state
			FNimportPosition (chkBtnEXPORT.state)
			FNwinSize()
		)

		on chkBtnEXPORT changed state do
		(
			setIniSetting _iniPref "Auto_UI" "default_state_checkExport" (state as string)
			
			FNexportVisibility state
			FNimportPosition (chkBtnEXPORT.state)
			FNwinSize()
		)

		on chkBtnIMPORT rightclick do
		(
			setIniSetting _iniPref "Auto_UI" "default_state_checkExport" (false as string)
			setIniSetting _iniPref "Auto_UI" "default_state_checkImport" (true as string)
			
			chkBtnIMPORT.state = true
			chkBtnEXPORT.state = false

			FNimportVisibility true
			FNexportVisibility false
			FNimportPosition (chkBtnEXPORT.state)
			FNwinSize()
		)

		on chkBtnEXPORT rightclick do
		(
			setIniSetting _iniPref "Auto_UI" "default_state_checkExport" (true as string)
			setIniSetting _iniPref "Auto_UI" "default_state_checkImport" (false as string)
			
			chkBtnIMPORT.state = false
			chkBtnEXPORT.state = true

			FNimportVisibility false
			FNexportVisibility true
			FNimportPosition (chkBtnEXPORT.state)
			FNwinSize()
		)

		on btnUsePreset pressed do 
		(
			if rdoAssetMethod.state == 1 do
			(
				_selectedAsset = lbxCatAsset.selected
			)
			if rdoAssetMethod.state == 2 do
			(
				_selectedAsset = lbxDetAsset.selected
			)
			if rdoAssetMethod.state == 3 do
			(
				_selectedAsset = lbxNmeAsset.selected
			)

			if _selectedAsset != undefined do
			(
				_missingObj = FNchkAsset _selectedAsset true
				if _missingObj == true do
				(
					_alreadyQueued = false
					for i in _exportQueue do
					(
						if i[1] == _selectedAsset do _alreadyQueued = true
					)

					if _alreadyQueued == false do
					(
						_exportPath = FNgenerateCacheDir _selectedAsset
						_newExport = #(_selectedAsset,_seq,_shot,_exportPath)
						_exportQueue = append _exportQueue _newExport
						FNupdateExportList()
					)
					FNgreyExportUi true
				)
			)
		)

		on btnUsePreset rightclick do 
		(
			if rdoAssetMethod.state == 1 do
			(
				_uiToUse = lbxCatAsset.items
			)
			if rdoAssetMethod.state == 2 do
			(
				_uiToUse = lbxDetAsset.items
			)
			if rdoAssetMethod.state == 3 do
			(
				_uiToUse = lbxNmeAsset.items
			)

			for i in _uiToUse do
			(
				_missingObj = FNchkAsset i false
				if _missingObj == true do
				(
					_alreadyQueued = false
					for u in _exportQueue do
					(
						if u[1] == i do _alreadyQueued = true
					)

					if _alreadyQueued == false do
					(
						_exportPath = FNgenerateCacheDir i
						_newExport = #(i,_seq,_shot,_exportPath)
						_exportQueue = append _exportQueue _newExport
						FNupdateExportList()
					)
					FNgreyExportUi true
				)
			)
		)

		on btnRemoveQueue pressed do
		(
			FNremoveFromQueue()
			FNupdateExportList()
		)

		on btnRemoveQueue rightclick do
		(
			FNremoveAllQueue()
			FNupdateExportList()
		)

		on btnAddPreset pressed do
		(
			createDialog _PCT_Preset
		)

		on btnDetAsset pressed do
		(
			FNassetListByDetection()
		)

		on ddlCatAsset selected state do
		(
			FNassetListByCategory()
		)

		on btnPrefs pressed do 
		(
			fileIn _prefScript
			destroyDialog _PCT_MainUi
		)

		on ddlSeqIm selected state do
		(
			_currentSeq = ddlSeqIm.selected
			_newShotList = FNgetShotList _currentSeq
			ddlShotIm.items = _newShotList
			ddlShotIm.selection = 1
		)

		on ddlShotIm selected state do
		(
			FNloadSelectedFile()
		)
		on btnEditPreset pressed do
		(
			_selectionProperties = FNgetSelAssetProperties()
			if _selectionProperties != false do
			(
				_objArray = execute _selectionProperties[4]
				_initName = _selectionProperties[1]
				createDialog _PCT_Preset
				_PCT_Preset.lbxPresetObjects.items = _objArray
				_ddlItems = _PCT_Preset.ddlPresetAssetType.items
				
				_marker = true
				for i = 1 to _ddlItems.count do
				(
					if _ddlItems[i] == _selectionProperties[2] do 
					(
						_PCT_Preset.ddlPresetAssetType.selection = i
						_marker = false
					)
				)
				if _marker == true do
				(
					_defaultCatName = _PCT_Preset.ddlPresetAssetType.items[1]
					_PCT_Preset.ddlPresetAssetType.selection = 1
					FNmsgBox("The category " + _selectionProperties[2] + " doesn't exist anymore. The first category (\""+ _defaultCatName + "\") has been set by default.")
				)

				_PCT_Preset.edtPresetAssetName.text = _selectionProperties[1]
				_PCT_Preset.edtPresetAssetPath.text = _selectionProperties[3]
			)
		)

		on btnDeletePreset pressed do
		(
			if rdoAssetMethod.state == 1 do
			(
				_selAsset = lbxCatAsset.selected
			)
			if rdoAssetMethod.state == 2 do
			(
				_selAsset = lbxDetAsset.selected
			)
			if rdoAssetMethod.state == 3 do
			(
				_selAsset = lbxNmeAsset.selected
			)
			if _selAsset != undefined do
			(
				_selAssetFile = _presetDir + _selAsset + ".ini"
				deleteFile _selAssetFile
				FNassetListByCategory()
				FNassetListByDetection()
				FNassetListByName()
			)
		)

		on btnExport pressed do
		(
			for i=1  to _exportQueue.count do
			(
				_assetArray = _exportQueue[i]
				_assetName = _assetArray[1]
				_assetPath = _assetArray[4]

				_selectionProperties = FNgetAssetProperties _assetName
				
				_assetObjArray =  execute _selectionProperties[4]
				_assetName = _selectionProperties[1]
	
				_exportSeq = edtSeqEx.text
				_exportShot = edtShotEx.text
	
				_exportStart = spnFromFrame.value
				_exportEnd = spnToFrame.value
	
				_gapFrames = _exportEnd - _exportStart
					
				if  _gapFrames >= 0 then
				(			
					FNsetPC _assetName _assetPath _exportStart _exportEnd _assetObjArray
					FNsetTurbosmoothEXP _assetObjArray
					FNrecordPC _assetObjArray
					FNcreateDbFile _defdbDir _exportSeq _exportShot _assetName
		
					FNrefreshImportUI()
				)
				else
				(
					FNmsgBox "At least one field has been left blank."
				)
			)
		)

		on btnMerge pressed do
		(
			_pathToMergeArray = FNgetSelAssetPropertiesImport()
			_pathToMerge = _pathToMergeArray[3]
			_objToMerge = _pathToMergeArray[4]
			_objToMerge = execute _objToMerge
			
			_tomergeExecute = #()
			for i in _objToMerge do
			(
				_tomergeExecute = append _tomergeExecute i
			)
			if _tomergeExecute.count != 0 do
			(
				mergemaxfile _pathToMerge _tomergeExecute
			)
		)

		on btnImport pressed do
		(
			_toMergeArray = FNgetSelAssetPropertiesImport()
			_objToMerge = _toMergeArray[4]
			_objToMerge = execute _objToMerge
			_assetName = lbxCatAssetIm.selected
			

				
			FNimportPointCache _objToMerge _assetName
		)

		on btnAbout pressed do
		(
			createDialog _PCT_About
		)

		on _PCT_MainUi moved _pos do
        (
            setIniSetting _iniPref "Window_position" "position" (_pos as string)
        )
	)
	_rolloutPosition = execute(getIniSetting _iniPref "Window_position" "position")
	--if _rolloutPosition == undefined do _rolloutPosition = [70,180]

	if _defwinPos == true and (_rolloutPosition != undefined) do
	(
		createDialog _PCT_MainUi 288 670 _rolloutPosition.x _rolloutPosition.y style:#(#style_border, #style_sysmenu ,#style_minimizebox, #style_titlebar)
	)
	if _defwinPos == false do
	(
		createDialog _PCT_MainUi 288 670 style:#(#style_border, #style_sysmenu ,#style_minimizebox, #style_titlebar)
	)
)