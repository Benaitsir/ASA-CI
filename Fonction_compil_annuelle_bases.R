comp_ann_bases <- function(branche) {
  # Cette fonction sert à créer automatiquement les fichiers de base qui serviront 
  # à la compilation des données annuelles des compagnies d'assurances. 
  
  # Le seul argument 'branche' permet de choisir la branche d'assurnace du fichier 
  # à créer
  
    # Initialisation ----
  setwd("C:/Users/Ismail SARE/OneDrive - ASSOCIATION DES SOCIETES D'ASSURANCES/Chiffres/Donnees")
  
  # Packages ----
  require(tidyverse) # Traitement de données
  require(openxlsx) # chargement docs excel
  
  if (branche == "IARD") {
    # Feuilles des états similaires ----
    ## Liste des compagnies
    liste.comp <- 
      c("2ACI", "ACTIVA", "ALLIANZ", "AMSA", "ATLANTA", "ATLANTIQUE", "AXA", "COMAR", 
        "CORIS", "GNA", "LA LOYALE", "LEADWAY", "MATCA",  "NSIA", "SAAR", "SANLAM", 
        "SCHIBA", "SERENITY S.A", "SIDAM S.A", "SMABTP", "SONAM", "SUNU", "WAFA", "TOTAL")
    
    ## Colonnes des valeurs
    colonnes <- 
      c("SOCIETE", "ACC.CORP._MAL.", "AUTO_RC", "AUTO_DOMM", "AUTO_TOT", 
        "INCENDIE_AUTRES_DOMM_AUX_BIENS", "RC_GEN", "TR_AER", "TR_MAR", 
        "TR_AUT", "TR_TOT", "AUTRES_RD_DOMM", "ENSEMBLE", "ACCEPTATION", "TOTAL")
    ## Formules
    # AUTO_TOT = AUTO_RC + AUTO_DOMM
    # TR_TOT = TR_AER + TR_MAR + TR_AUT 
    # ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM
    # TOTAL = ENSEMBLE + ACCEPTATION
    
    ## Mise en forme 
    base <- as.data.frame(matrix(data = 0, nrow = length(liste.comp), ncol = length(colonnes)))
    colnames(base) <- colonnes
    base[, "SOCIETE"] <- liste.comp
    
    # Feuille de réasssurance ----
    col.reass <- 
      c("SOCIETE", "PRIMES_CEDEES", "PROV_PRIM_OUV.", "PROV_PRIM_CLO.", "PRIM_ACQ_REASS", 
        "PART_REASS_PREST", "PROV_CHRG_OUV", "PROV_CHRG_CLO", "COMMISSIONS", "PART_REASS_CHRG", 
        "SOLDE_REASS")
    ## Formule
    # PRIM_ACQ_REASS = PRIMES_CEDEES - (PROV_PRIM_CLO. - PROV_PRIM_OUV.) 
    # PART_REASS_CHRG = PART_REASS_PREST - (PROV_CHRG_OUV - PROV_CHRG_CLO) + COMMISSIONS
    # SOLDE_REASS = PART_REASS_CHRG - PRIM_ACQ_REASS
    
    ## Mise en forme
    base.reass <- as.data.frame(matrix(data = 0, nrow = length(liste.comp), ncol = length(col.reass)))
    colnames(base.reass) <- col.reass
    base.reass[, "SOCIETE"] <- liste.comp
    
    # Feuille des engagements règlementés ----
    col.reg <- 
      c("SOCIETE", "PREC", "PSAP", "PMATH", "AUT_PROV", "AUT_ENG_REG", "TOT_ENG", "VAL_ETAT",
        "IMM", "AUT_VAL", "BANQUE", "CRE_CED", "PRM_REC", "TOT_PLAC", "MARG_COUV", 
        "TAUX_COUV")
    ## Formule
    # TOT_ENG = PREC + PSAP + PMATH + AUT_PROV + AUT_ENG_REG 
    # TOT_PLAC = VAL_ETAT + IMM + AUT_VAL + BANQUE + CRE_CED + PRM_REC
    # MARG_COUV = TOT_PLAC - TOT_ENG
    # TAUX_COUV = TOT_PLAC / TOT_ENG
    
    ## Mise en forme
    base.reg <- as.data.frame(matrix(data = 0, nrow = length(liste.comp), ncol = length(col.reg)))
    colnames(base.reg) <- col.reg
    base.reg[, "SOCIETE"] <- liste.comp
    
    # Sauvegarde des documents ----
    saveRDS(base, "5 - Scripts/compil_ann_base_IARD.RDS")
    saveRDS(base.reass, "5 - Scripts/compil_ann_reass_IARD.RDS")
    saveRDS(base.reg, "5 - Scripts/compil_ann_reg_IARD.RDS")
  }
  
  else if (branhe == "VIE") {
    print("Fonction en cours de développement veuillez patienter =) ")
  }
  
  else {print("Les seules valeurs acceptables sont : 'IARD' ou 'VIE' ")}
  
}
