extends Node # ScriptGlobale

var numero_corrente_di_chiavi : int
var numero_corrente_di_scudi : int

var ultimo_livello_sbloccato : int = 1

# -- file salvataggio --

func salva_dati(config : ConfigFile, path : String) -> void:
	config.save(path)


func prendi_config_file(config_file_path : String) -> ConfigFile:
	var config : ConfigFile = ConfigFile.new()
	
	# Load data from a file.
	var err = config.load(config_file_path)
	
	if err != OK:
		return null
	
	return config


func _ready() -> void:
	# Crea la cartella se non esiste
	if not DirAccess.dir_exists_absolute("user://CuboSaves"):
		DirAccess.make_dir_absolute("user://CuboSaves")


