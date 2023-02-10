/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>

#define PLUGIN "Check UserCommand"
#define VERSION "1.4"
#define AUTHOR "PANDA"

new g_fwid, g_max_clients, g_guns_eventids_bitsum;
new bool:g_block[33]=false;

new const g_guns_events[][] = {
	"events/awp.sc",
	"events/g3sg1.sc",
	"events/ak47.sc",
	"events/scout.sc",
	"events/m249.sc",
	"events/m4a1.sc",
	"events/sg552.sc",
	"events/aug.sc",
	"events/sg550.sc",
	"events/m3.sc",
	"events/xm1014.sc",
	"events/usp.sc",
	"events/mac10.sc",
	"events/ump45.sc",
	"events/fiveseven.sc",
	"events/p90.sc",
	"events/deagle.sc",
	"events/p228.sc",
	"events/glock18.sc",
	"events/mp5n.sc",
	"events/tmp.sc",
	"events/elite_left.sc",
	"events/elite_right.sc",
	"events/galil.sc",
	"events/famas.sc"
}

public plugin_init(){
	register_plugin(PLUGIN, VERSION, AUTHOR)
	unregister_forward(FM_PrecacheEvent, g_fwid, 1)
	register_forward(FM_PlaybackEvent, "fwPlaybackEvent")
	g_max_clients = global_get(glb_maxClients)
}
public plugin_precache(){
	g_fwid = register_forward(FM_PrecacheEvent, "fwPrecacheEvent", 1);
}
public fwPrecacheEvent(type, const name[]){
	for (new i = 0; i < sizeof g_guns_events; ++i){
		if (equal(g_guns_events[i], name)) {
			g_guns_eventids_bitsum |= (1<<get_orig_retval())
			return FMRES_HANDLED;
		}
	}
	return FMRES_IGNORED;
}
public client_putinserver(id){
	if(!is_user_hltv(id)){
		sprawdz(id);
	}
}
public sprawdz(id){
	new wartosc[2];
	get_user_info(id, "cl_lw", wartosc, 1);
	if(str_to_num(wartosc)==0){
		client_print(0, print_chat, "** Niepoprawne ustawienie cl_lw ** Gracz: %n", id);
		log_to_file("addons/amxmodx/logs/inne/check_user_command.log", "** Niepoprawne ustawienie cl_lw ** Gracz: %n", id);
		console_print(id, "-----------------------------------------");
		console_print(id, "Komenda cl_lw kto oblicza lot pociskow 1-serwer 0-gracz");
		console_print(id, "Wpisz cl_lw 1 i zatwierdz");
		console_print(id, "-----------------------------------------");
		server_cmd("kick #%d ^"Wymagane cl_lw 1^"",get_user_userid(id))
	}
	else {
		get_user_info(id, "cl_lc", wartosc, 1);
		if(str_to_num(wartosc)==0){
			client_print(0, print_chat, "** Niepoprawne ustawienie cl_lc ** Gracz: %n", id);
			log_to_file("addons/amxmodx/logs/inne/check_user_command.log", "** Niepoprawne ustawienie cl_lc ** Gracz: %n", id);
			console_print(id, "-----------------------------------------");
			console_print(id, "Komenda cl_lc kompresja lagow? 1-tak 0-nie");
			console_print(id, "Wpisz cl_lc 1 i zatwierdz");
			console_print(id, "-----------------------------------------");
			server_cmd("kick #%d ^"Wymagane cl_lc 1^"",get_user_userid(id))
		}
		else {
			get_user_info(id, "cl_minmodels", wartosc, 1);
			if(str_to_num(wartosc)==1){
				client_print(0, print_chat, "** Niepoprawne ustawienie cl_minmodels ** Gracz: %n", id);
				log_to_file("addons/amxmodx/logs/inne/check_user_command.log", "** Niepoprawne ustawienie cl_minmodels ** Gracz: %n", id);
				console_print(id, "-----------------------------------------");
				console_print(id, "Komenda cl_minmodels gracz widzi uproszczone modele? 1-tak 0-nie");
				console_print(id, "Wpisz cl_minmodels 0 i zatwierdz");
				console_print(id, "-----------------------------------------");
				server_cmd("kick #%d ^"Wymagane cl_minmodels 0^"",get_user_userid(id))
			}
		}
	}
		
}
public client_disconnected(id){
	if(task_exists(id)){
		remove_task(id);
		g_block[id]=false;
	}
}
public odblokuj(id){
	g_block[id]=false;
}
public fwPlaybackEvent(flags, invoker, eventid){
	if(!(g_guns_eventids_bitsum & (1<<eventid)) || !(1 <= invoker <= g_max_clients)) return FMRES_IGNORED;
		
	if(!g_block[invoker]){
		g_block[invoker]=true;
		sprawdz(invoker);
		set_task(10.0, "odblokuj", invoker);
	}
	return FMRES_HANDLED;
}