rg                              = {}
rg.Asetus                       = Asetus
Asetus                          = {}
Asetus.Valuutta                 = {}
Asetus.Pelaaja                  = {}
Asetus.Kaupunki                 = {}
Asetus.KaupunkiOikeudet         = {}
Asetus.MaxPlayers               = GetConvarInt('sv_maxclients', 1024)
Asetus.IdentifierType           = "steam" or "license"
Asetus.DefaultSpawn             = {x=-1035.71,y=-2731.87,z=12.86,a=0.0}
Asetus.Valuutta.Muodot          = {['cash'] = 0, ['bank'] = 490, ['crypto'] = 0}
Asetus.Valuutta.DontAllowMinus  = {'cash', 'crypto', 'bank'}
Asetus.Pelaaja.Reppupaino       = 40000
Asetus.Pelaaja.Repputila        = 18
Asetus.Pelaaja.Veriarvo         = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"}
Asetus.Kaupunki.Suljettu        = false
Asetus.Kaupunki.SuljettuSyy     = "Kaupungissa on myrskyvaroitus.."
Asetus.Kaupunki.uptime          = 0
Asetus.Kaupunki.whitelist       = false
Asetus.Kaupunki.discord         = "Discord.io/RevohkaRP"
Asetus.Identiteetti             = true
Asetus.Prioriteetti             = false
Asetus.Aikakatkaisu             = 600
Asetus.Jonotusaika              = 90
Asetus.Armo                     = false
Asetus.ArmoKerrat               = 5
Asetus.GraceTime                = 480
Asetus.Jonotusaika              = 30000
Asetus.Tilanne                  = false

Asetus.Priority = {
    --["STEAM_0:1:0000####"] = 1,
    --["steam:110000######"] = 25,
    --["ip:127.0.0.0"] = 85
}

Asetus.Language = {
    joining         = "Käsitellään tietoja..",
    connecting      = "Tarkistetaan pari juttua..",
    idrr            = "Emme tunnistaneet sinua, tarkista viisumisi (Steam)",
    err             = "Emme tunnistaneet sinua, tarkista viisumisi (Steam)",
    pos             = "Olet sijalla %d/%d jonossa.",
    connectingerr   = "Emme tunnistaneet sinua, tarkista viisumisi (Steam)",
    timedout        = "Emme tunnistaneet sinua, tarkista viisumisi (Steam)",
    wlonly          = "Sinulla ei ole voimmassa olevaa viisumia..",
    steam           = "Emme tunnistaneet sinua, tarkista viisumisi (Steam)"
}