tool
extends HBoxContainer

enum LANGUAGES {
	aa, aa_DJ, aa_ER, aa_ET, af, af_ZA, agr_PE, ak_GH, am_ET, an_ES, anp_IN, ar, ar_AE, ar_BH, ar_DZ,
	ar_EG, ar_IQ, ar_JO, ar_KW, ar_LB, ar_LY, ar_MA, ar_OM, ar_QA, ar_SA, ar_SD, ar_SY, ar_TN, ar_YE, as_IN,
	ast_ES, ayc_PE, ay_PE, az_AZ, be, be_BY, bem_ZM, ber_MA, bg, bg_BG, bhb_IN, bho_IN, bo, bo_CN, bo_IN,
	br_FR, brx_IN, bs_BA, byn_ER, ca, ca_AD, ca_ES, ca_FR, ca_IT, ce_RU, chr_US, cmn_TW, crh_UA, csb_PL,
	cs, cs_CZ, cv_RU, cy_GB, da, da_DK, de, de_AT, de_BE, de_CH, de_DE, de_IT, de_LU, doi_IN, dv_MV, dz_BT,
	el, el_CY, el_GR, en, en_AG, en_AU, en_BW, en_CA, en_DK, en_GB, en_HK, en_IE, en_IL, en_IN, en_NG, en_MT,
	en_NZ, en_PH, en_SG, en_US, en_ZA, en_ZM, en_ZW, eo, es, es_AR, es_BO, es_CL, es_CO, es_CR, en_CU, es_DO,
	es_EC, es_ES, es_GT, es_HN, es_MX, es_NI, es_PA, es_PE, es_PR, es_PY, es_SV, es_US, es_UY, es_VE, et,
	et_EE, eu, eu_ES, fa, fa_IR, ff_SN, fi, fi_FI, fil_PH, fo_FO, fr, fr_BE, fr_CA, fr_CH, fr_FR, fr_LU,
	fur_IT, fy_DE, fy_NL, ga, ga_IE, gd_GB, gez_ER, gez_ET, gl_ES, gu_IN, gv_GB, hak_TW, ha_NG, he, he_IL, hi,
	hi_IN, hne_IN, hr, hr_HR, hsb_DE, ht_HT, hu, hu_HU, hus_MX, hy_AM, ia_FR, id, id_ID, ig_NG, ik_CA, IS, is_IS,
	it, it_CH, it_IT, it_CA, ja, ja_JP, kab_DZ, ka_GE, kk_KZ, kl_GL, km_KH, kn_IN, kok_IN, ko, ko_KR, ks_IN, ku,
	ku_TR, kw_GB, ky_KG, lb_LU, lg_UG, li_BE, li_NL, lij_IT, ln_CD, lo_LA, lt, lt_LT, lv_LV, lzh_TW, mag_IN, mai_IN,
	mg_MG, mh_MH, mhr_RU, mi_NZ, miq_NI, mk, mk_MK, ml_IN, mni_IN, mn_MN, mr_IN, ms_MY, mt, mt_MT, my_MM, myv_RU,
	nah_MX, nan_TW, nb_NO, nds_DE, nds_NL, ne_NP, nhn_MX, niu_NU, niu_NZ, nl, nl_AW, nl_BE, nl_NL, nn, nn_NO, nr_ZA,
	nso_ZA, oc_FR, om, om_ET, om_KE, or_IN, os_RU, pa_IN, pap, pap_AN, pap_AW, pap_CW, pa_PK, pl, pl_PL, pr,
	ps_AF, pt, pt_BR, pt_PT, quy_PE, quz_PE, raj_IN, ro, ro_RO, ru, ru_RU, ru_UA, rw_RW, sa_IN, sat_IN, sc_IT,
	sco, sd_IN, se_NO, sgs_LT, shs_CA, sid_ET, si_LK, sk, sk_SK, sl, so, so_DJ, so_ET,so_KE, so_SO, son_ML, sq,
	sq_AL, sq_KV, sq_MK, sr, sr_BA, sr_CS, sr_ME, sr_RS, ss_ZA, st_ZA, sv, sv_FI, sv_SE, sw_KE, sw_TZ, szl_PL, ta,
	ta_IN, ta_LK, tcy_IN, tg_TJ, the_NP, th, th_TH, th_TH_TH, ti, ti_ER, ti_ET, tig_ER, tk_TM, tl_PH, tn_ZA, tr,
	tr_CY, tr_TR, ts_ZA, tt_RU, ug_CN, uk, uk_UA, unm_US, ur, ur_IN, ur_PK, uz, uz_UZ, ve_ZA, vi, vi_VN, wa_BE,
	wae_CH, wal_ET, wo_SN, xh_ZA, yi_US, yo_NG, yue_HK, zh_SG, zh_TW, zu_ZArech 
}

# languages array 
var languages : Array = [
	"aa", "aa_DJ", "aa_ER", "aa_ET", "af", "af_ZA", "agr_PE", "ak_GH", "am_ET", "an_ES", "anp_IN", "ar", "ar_AE", "ar_BH", "ar_DZ",
	"ar_EG", "ar_IQ", "ar_JO", "ar_KW", "ar_LB", "ar_LY", "ar_MA", "ar_OM", "ar_QA", "ar_SA", "ar_SD", "ar_SY", "ar_TN", "ar_YE", "as_IN",
	"ast_ES", "ayc_PE", "ay_PE", "az_AZ", "be", "be_BY", "bem_ZM", "ber_MA", "bg", "bg_BG", "bhb_IN", "bho_IN", "bo", "bo_CN", "bo_IN",
	"br_FR", "brx_IN", "bs_BA", "byn_ER", "ca", "ca_AD", "ca_ES", "ca_FR", "ca_IT", "ce_RU", "chr_US", "cmn_TW", "crh_UA", "csb_PL",
	"cs", "cs_CZ", "cv_RU", "cy_GB", "da", "da_DK", "de", "de_AT", "de_BE", "de_CH", "de_DE", "de_IT", "de_LU", "doi_IN", "dv_MV", "dz_BT",
	"el", "el_CY", "el_GR", "en", "en_AG", "en_AU", "en_BW", "en_CA", "en_DK", "en_GB", "en_HK", "en_IE", "en_IL", "en_IN", "en_NG", "en_MT",
	"en_NZ", "en_PH", "en_SG", "en_US", "en_ZA", "en_ZM", "en_ZW", "eo", "es", "es_AR", "es_BO", "es_CL", "es_CO", "es_CR", "en_CU", "es_DO",
	"es_EC", "es_ES", "es_GT", "es_HN", "es_MX", "es_NI", "es_PA", "es_PE", "es_PR", "es_PY", "es_SV", "es_US", "es_UY", "es_VE", "et",
	"et_EE", "eu", "eu_ES", "fa", "fa_IR", "ff_SN", "fi", "fi_FI", "fil_PH", "fo_FO", "fr", "fr_BE", "fr_CA", "fr_CH", "fr_FR", "fr_LU",
	"fur_IT", "fy_DE", "fy_NL", "ga", "ga_IE", "gd_GB", "gez_ER", "gez_ET", "gl_ES", "gu_IN", "gv_GB", "hak_TW", "ha_NG", "he", "he_IL", "hi",
	"hi_IN", "hne_IN", "hr", "hr_HR", "hsb_DE", "ht_HT", "hu", "hu_HU", "hus_MX", "hy_AM", "ia_FR", "id", "id_ID",  "ig_NG", "ik_CA", "is", "is_IS",
	"it", "it_CH", "it_IT", "it_CA", "ja", "ja_JP", "kab_DZ", "ka_GE", "kk_KZ", "kl_GL", "km_KH", "kn_IN", "kok_IN", "ko", "ko_KR", "ks_IN", "ku",
	"ku_TR", "kw_GB", "ky_KG", "lb_LU", "lg_UG", "li_BE", "li_NL", "lij_IT", "ln_CD", "lo_LA", "lt", "lt_LT", "lv_LV", "lzh_TW", "mag_IN", "mai_IN",
	"mg_MG", "mh_MH", "mhr_RU", "mi_NZ", "miq_NI", "mk", "mk_MK", "ml_IN", "mni_IN", "mn_MN", "mr_IN", "ms_MY", "mt", "mt_MT", "my_MM", "myv_RU",
	"nah_MX", "nan_TW", "nb_NO", "nds_DE", "nds_NL", "ne_NP", "nhn_MX", "niu_NU", "niu_NZ", "nl", "nl_AW", "nl_BE", "nl_NL", "nn", "nn_NO", "nr_ZA",
	"nso_ZA", "oc_FR", "om", "om_ET", "om_KE", "or_IN", "os_RU", "pa_IN", "pap", "pap_AN", "pap_AW", "pap_CW", "pa_PK", "pl", "pl_PL", "pr",
	"ps_AF", "pt", "pt_BR", "pt_PT", "quy_PE", "quz_PE", "raj_IN", "ro", "ro_RO", "ru", "ru_RU", "ru_UA", "rw_RW", "sa_IN", "sat_IN", "sc_IT",
	"sco", "sd_IN", "se_NO", "sgs_LT", "shs_CA", "sid_ET", "si_LK", "sk", "sk_SK", "sl", "so", "so_DJ", "so_ET","so_KE", "so_SO", "son_ML", "sq",
	"sq_AL", "sq_KV", "sq_MK", "sr", "sr_BA", "sr_CS", "sr_ME", "sr_RS", "ss_ZA", "st_ZA", "sv", "sv_FI", "sv_SE", "sw_KE", "sw_TZ", "szl_PL", "ta",
	"ta_IN", "ta_LK", "tcy_IN", "tg_TJ", "the_NP", "th", "th_TH", "th_TH_TH", "ti", "ti_ER", "ti_ET", "tig_ER", "tk_TM", "tl_PH", "tn_ZA", "tr",
	"tr_CY", "tr_TR", "ts_ZA", "tt_RU", "ug_CN", "uk", "uk_UA", "unm_US", "ur", "ur_IN", "ur_PK", "uz", "uz_UZ", "ve_ZA", "vi", "vi_VN", "wa_BE",
	"wae_CH", "wal_ET", "wo_SN", "xh_ZA", "yi_US", "yo_NG", "yue_HK", "zh_SG", "zh_TW", "zu_ZA" 
]

onready var Reset    : Button       = self.get_node("Reset")
onready var Language : OptionButton = self.get_node("Languages")

export (LANGUAGES) var default_language = LANGUAGES.en
export (LANGUAGES) var current_lanugage = default_language

var include_dialeks : bool = false # currently not working shoud be true to function

func _ready() -> void:
	
	# creats a instance of the File class
	var f : File = File.new()
	# checks if the config file exists
	if f.file_exists("res://addons/DialogEditor/config.json"):
		# opens the config file in read mode
		f.open("res://addons/DialogEditor/config.json", f.READ)
		# gets the include dialekts from config file
		include_dialeks = JSON.parse(f.get_as_text()).result["IncludeDialekts"]
		# closes the File
		f.close()
		
		# just for WIP
		include_dialeks = true
	
	# checks if Reset is valid
	if Reset:
		# connects the pressed signal to reset
		Reset.connect("pressed", self, "reset")
	# checks if Language is valid
	if Language:
		# connects the item selected signal to set value with 
		# the selected item (integer) as new value
		Language.connect("item_selected", self, "set_value")
		# goes through the language array to populate
		# the Languages items 
		for language in languages.size():
			# checks if language shoud include dialekts
			if include_dialeks == true:
				# creates (addes) a new item with the name
				# of the language
				Language.add_item(languages[language], language)
			# gets probebly change
			else:
				# checks if string doesent contain _
				if not "_" in languages[language]:
					# creates (addes) a new item with the name
					# of the language
					Language.add_item(languages[language], language)

# resets the language to default
func reset() -> void:
	# calles set value with default language as new value
	set_value(default_language)

# sets the language and updates the GUI to reflect new value
func set_value(new_value : int) -> void:
	# sets the current language to the new language
	current_lanugage = new_value
	# sets the option buttons (Language) selected value
	Language.select(new_value)
	
	# checks if the default language is not the new value
	if default_language != new_value:
		# shows the Reset button
		Reset.show()
	else:
		# hides the Reset Button
		Reset.hide()
	
	# prints the selected language
	print(languages[new_value])

# Return selected Language as a String
func get_value() -> String:
	return languages[Language.selected]
