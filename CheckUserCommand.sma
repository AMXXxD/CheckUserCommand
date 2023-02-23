#include <amxmodx>
#include <amxmisc>

#define PLUGIN "Check UserCommand"
#define VERSION "2.0"
#define AUTHOR "PANDA"

public plugin_init() register_plugin(PLUGIN, VERSION, AUTHOR);
public client_putinserver(id) set_task(0.1, "start", id);
public client_disconnected(id) if(task_exists(id)) remove_task(id);
public check(id) if(is_user_connected(id)) query_client_cvar(id, "cl_minmodels", "result");
public start(id) check(id), client_infochanged(id);

public client_infochanged(id){
	if(is_user_hltv(id) || !is_user_connected(id)) return PLUGIN_CONTINUE;
	new lc[2];
	get_user_info(id, "cl_lc", lc, 1);
	if(strcmp(lc, "0")==0){
		//client_print(0, print_chat, "** Niepoprawne ustawienie cl_lc ** Gracz: %n", id);
		log_to_file("addons/amxmodx/logs/inne/check_user_command.log", "** Niepoprawne ustawienie cl_lc ** Gracz: %n", id);
		console_print(id, "-----------------------------------------");
		console_print(id, "Komenda cl_lc kompresja lagow? 1-tak 0-nie");
		console_print(id, "Wpisz cl_lc 1 i zatwierdz");
		console_print(id, "-----------------------------------------");
		server_cmd("kick #%d ^"Wymagane cl_lc 1^"",get_user_userid(id))
		return PLUGIN_CONTINUE;
	}
	new lw[2];
	get_user_info(id, "cl_lw", lw, 1);
	if(strcmp(lw, "0")==0){
		//client_print(0, print_chat, "** Niepoprawne ustawienie cl_lw ** Gracz: %n", id);
		log_to_file("addons/amxmodx/logs/inne/check_user_command.log", "** Niepoprawne ustawienie cl_lw ** Gracz: %n", id);
		console_print(id, "-----------------------------------------");
		console_print(id, "Komenda cl_lw kto oblicza lot pociskow 1-serwer 0-gracz");
		console_print(id, "Wpisz cl_lw 1 i zatwierdz");
		console_print(id, "-----------------------------------------");
		server_cmd("kick #%d ^"Wymagane cl_lw 1^"",get_user_userid(id))
		return PLUGIN_CONTINUE;
	}
	return PLUGIN_CONTINUE;
}

public result(id, const cvar[], const value[]){
	if(is_user_hltv(id)) return PLUGIN_CONTINUE;
	if(strcmp(value, "1")==0){
		//client_print(0, print_chat, "** Niepoprawne ustawienie cl_minmodels ** Gracz: %n", id);
		log_to_file("addons/amxmodx/logs/inne/check_user_command.log", "** Niepoprawne ustawienie cl_minmodels ** Gracz: %n", id);
		console_print(id, "-----------------------------------------");
		console_print(id, "Komenda cl_minmodels gracz widzi uproszczone modele? 1-tak 0-nie");
		console_print(id, "Wpisz cl_minmodels 0 i zatwierdz");
		console_print(id, "-----------------------------------------");
		server_cmd("kick #%d ^"Wymagane cl_minmodels 0^"",get_user_userid(id))
	}
	else set_task(30.0, "check", id);
	return PLUGIN_CONTINUE;
}
