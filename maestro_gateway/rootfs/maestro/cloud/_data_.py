# coding: utf-8
'''
Correspondence tables
Rank 0 corresponds to the position of the information in the MAESTRO frame
Rank 1 corresponds to the title published on the broker
Rank 2 (optional) allows you to replace the frame code with corresponding text information
'''
RecuperoInfo=[
	[1,"Kachel status",[
						[0, "Uit"],
						[1, "Controle warm/koud"],
						[2, "Reinigen koud"],
						[3, "Pellets laden koud"],
						[4, "Start 1 koud"],
						[5, "Start 2 koud"],
						[6, "Reinigen warm"],
						[7, "Pellets laden warm"],
						[8, "Start 1 warm"],
						[9, "Start 2 warm"],
						[10, "Stabiliseren"],
						[11, "Vermogen 1"],
						[12, "Vermogen 2"],
						[13, "Vermogen 3"],
						[14, "Vermogen 4"],
						[15, "Vermogen 5"],
						[30, "Diagnose"],
						[31, "Aan"],
						[40, "Doven"],
						[41, "Afkoelen 1"],
						[42, "Reinigen laag"],
						[43, "Reinigen hoog"],
						[44, "Ontgrendeling aanvoerschroef"],
						[45, "Auto ECO"],
						[46, "Standby"],
						[48, "Diagnose"],
						[49, "Laadvijzel"],
						[50, "Foutmelding A01 - Ontsteking mislukt"],
						[51, "Foutmelding A02 - Geen ontbranding"],
						[52, "Foutmelding A03 - Oververhitting reservoir"],
						[53, "Foutmelding A04 - Rookgastemperatuur te hoog"],
						[54, "Foutmelding A05 - Kanaalobstructie - Wind"],
						[55, "Foutmelding A06 - Bad printing"],
						[56, "Foutmelding A09 - Rooksonde"],
						[57, "Foutmelding A11 - Storing in de reductiemotor"],
						[58, "Foutmelding A13 - Moederbordtemperatuur te hoog"],
						[59, "Foutmelding A14 - Storing actief"],
						[60, "Foutmelding A18 - Watertemperatuur te hoog"],
						[61, "Foutmelding A19 - Storing watertemperatuursensor"],
						[62, "Foutmelding A20 - Fout hulpsonde"],
						[63, "Foutmelding A21 - Alarm drukschakelaar"],
						[64, "Foutmelding A22 - Fout omgevingssonde"],
						[65, "Foutmelding A23 - Sluitingsfout vuurpot"],
						[66, "Foutmelding A12 - Storing motorreducer controller"],
						[67, "Foutmelding A17 - Vastlopende vijzel"],
						[69, "Wachten op beveiligingsalarmen"],
						]],
	[2,"Status omgevingsventilator",[
										[0, "Inactief"],
										[1, "Stand 1"],
										[2, "Stand 2"],
										[3, "Stand 3"],
										[4, "Stand 4"],
										[5, "Stand 5"],
										[6, "Automatique"],
										]],
	[3,"Rookkanaal ventilator status 1",[
										[0, "Inactief"],
										[1, "Stand 1"],
										[2, "Stand 2"],
										[3, "Stand 3"],
										[4, "Stand 4"],
										[5, "Stand 5"],
										[6, "Automatique"],
										]],
	[4,"Rookkanaal ventilator status 2",[
										[0, "Inactief"],
										[1, "Stand 1"],
										[2, "Stand 2"],
										[3, "Stand 3"],
										[4, "Stand 4"],
										[5, "Stand 5"],
										[6, "Automatique"],
										]],
	[5,"Rook temperatuur"],
	[6,"Omgevingstemperatuur"],
	[7,"Puffer temperatuur"], # !=255 == Hydro
	[8,"Ketel temperatuur"],
	[9,"NTC3 temperatuur"], # !=255 == Hydro
	[10,"Bougie status",[
					[0, "Ok"],
					[1, "Versleten"],
					]],
	[11,"ACTIVE - Set"],
	[12,"RPM - Rook ventilator"],
	[13,"RPM - Vijzel - SET"],
	[14,"RPM - Vijzel - LIVE"],
	[17,"Branderpot",[
					[0, "OK"],
					[101, "Openen vuurpot"],
					[100, "Sluiten vuurpot"],
					]], # !==Matic
	[18,"Stand",[
					[0, "Handmatig"],
					[1, "Dynamisch"],
					[2, "Nacht"],
					[3, "Comfort"],
					[4, "Power 110%"],
					[10, "Aangepast"],
					]],
	[20,"Actieve modus",[
					[0, "Uit"],
					[1, "Aan"],
					]],  #0: Désactivé, 1: Activé
	[21,"ACTIVE - Live"],
	[22,"Regelmodus",[
							[0, "Handmatig"],
							[1, "Dynamisch"],
							]],
	[23,"ECO-modus",[
					[0, "Uit"],
					[1, "Aan"],
					]],
	[24,"Stil",[
					[0, "Uit"],
					[1, "Aan"],
					]],
	[25,"Chronotermostaat mode",[
					[0, "Uit"],
					[1, "Aan"],
					]],
	[26,"Temperatuur ingesteld"],
	[27,"Temperatuur boiler"],
	[28,"Temperatuur moederbord"],
	[29,"Vermogen Active",[
							[11, "Vermogen 1"],
							[12, "Vermogen 2"],
							[13, "Vermogen 3"],
							[14, "Vermogen 4"],
							[15, "Vermogen 5"],
							]],
	[32,"Kachel uur (0-23)"],
	[33,"Kachel minuut (0-29)"],
	[34,"Kachel dag (1-31)"],
	[35,"Kachel maand (1-12)"],
	[36,"Kachel jaar"],
	[37,"Totaal bedrijfsuren (s)"],
	[38,"Totaal bedrijfsuren op Vermogen 1 (s)"],
	[39,"Totaal bedrijfsuren op Vermogen 2 (s)"],
	[40,"Totaal bedrijfsuren op Vermogen 3 (s)"],
	[41,"Totaal bedrijfsuren op Vermogen 4 (s)"],
	[42,"Totaal bedrijfsuren op Vermogen 5 (s)"],
	[43,"Uren tot onderhoud"],
	[44,"Minuten voor doven"],
	[45,"Aantal ontstekingen"],
	[47,"Pellet sonde",[
						[0, "Sonde niet actief"],
						[10, "Niveau voldoende"],
						[11, "Bijna leeg"],
						]],
	[48,"Geluidseffect",[
					[0, "Uit"],
					[1, "Aan"],
					]],
	[49,"Staat geluidseffecten",[
					[0, "Uit"],
					[1, "Aan"],
					]],
	[50,"Sleep",[
					[0, "Uit"],
					[1, "Aan"],
					]],
	[51,"Mode",[
				[0, "Winter"],
				[1, "Zomer"],
				]],
	[52,"Wifi sonde temperatuur 1"],
	[53,"Wifi sonde temperatuur 2"],
	[54,"Wifi sonde temperatuur 3"],
	[55,"Onbekend"],
	[56,"Set Puffer"],
	[57,"Set Boiler"],
	[58,"Set Health"], # !==Hydro
	[59,"Temperature retour"],
	[60,"Antivries",[
					[0, "Uit"],
					[1, "Aan"],
					]],
	]
	