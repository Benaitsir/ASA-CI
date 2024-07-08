comp_ann_donnees <- function(action, branche, ann, comp, chemin_C1, chemin_C4) {
  # Initialisation ----
  setwd("C:/Users/Ismail SARE/OneDrive - ASSOCIATION DES SOCIETES D'ASSURANCES/Chiffres/Donnees")
  
  # Packages ----
  require(tidyverse) # Traitement de données
  require(openxlsx) # chargement docs excel
  
  if (action == "supprimer") {
    if (branche == "IARD") {
      unlink(paste("5 - Scripts", paste0("Compil_ann_", ann, "_IARD", ".xlsx"), sep = "/"))
    }
    else if (branche == "VIE") {
      unlink(paste("5 - Scripts", paste0("Compil_ann_", ann, "_VIE", ".xlsx"), sep = "/"))
    }
    else if (branche == "TOUT") {
      unlink(paste("5 - Scripts", paste0("Compil_ann_", ann, "_IARD", ".xlsx"), sep = "/"))
      unlink(paste("5 - Scripts", paste0("Compil_ann_", ann, "_VIE", ".xlsx"), sep = "/"))
    }
  }
  
  else if (action == "creer") {
    if (branche == "IARD") {
      # Chargement du fichier de base pour la compilation ----
      ## appelle de la fonction de création de données
      source("5 - Scripts/Fonction_compil_annuelle_bases.R") 
      ## Exécution de la fonction
      comp_ann_bases("IARD") 
      ## base des états similaires
      base <- read_rds("5 - Scripts/compil_ann_base_IARD.RDS") 
      ## base états de réassurance
      base.reass <- read_rds("5 - Scripts/compil_ann_reass_IARD.RDS") 
      ## base état des engagements règlementés
      base.reg <- read_rds("5 - Scripts/compil_ann_reg_IARD.RDS") 
      
      # Chargement des dossiers ----
      
      ## Dossier compagnie
      C1 <- read.xlsx(chemin_C1, sheet = 1)
      C4 <- read.xlsx(chemin_C4, sheet = 1)
      ### On transforme les 'NA' en 0
        # C1
      for (i in 1:nrow(C1)) {
        for (j in 1:ncol(C1)) {if (is.na(C1[i, j] == TRUE)) {C1[i, j] <- 0}}
      }
        # C4
      for (i in 1:nrow(C4)) {
        for (j in 1:ncol(C4)) {if (is.na(C4[i, j] == TRUE)) {C4[i, j] <- 0}}
      }
      
      liste.comp <- 
        c("2ACI", "ACTIVA", "ALLIANZ", "AMSA", "ATLANTA", "ATLANTIQUE", "AXA", "COMAR", 
          "CORIS", "GNA", "LA LOYALE", "LEADWAY", "MATCA",  "NSIA", "SAAR", "SANLAM", 
          "SCHIBA", "SERENITY S.A", "SIDAM S.A", "SMABTP", "SONAM", "SUNU", "WAFA")
      
      
      # Compilation des données ----
      
      ## Correspondance des feuilles ----
      
      # I1 <- CHIFFRES D'AFFAIRES
      # I2A <- PROV. PRIMES A LA CLOTURE
      # I2B <- PROV. PRIMES A L'OUVERTURE
      # I4 <- PRODUITS FINANCIERS NETS
      # I5 <- PRESTATIONS PAYEES
      # I6A <- PROV. TECH. A LA CLOTURE
      # I6B <- PROV. TECH. A L'OUVERTURE
      # I8 <- COMMISSIONS
      # I9 <- FRAIS GENERAUX
      # I12 <- PRIMES ACQUISES AUX REASSUREURS
      # I13 <- PART DES REASSUREURS DANS LES CHARGES
      # I17 <- REASSURANCES
      # I18 <- ENGAGEMENTS REGLEMENTES ET LEUR COUVERTURE
      
      ## Formules C1
      # AUTO_TOT = AUTO_RC + AUTO_DOMM
      # TR_TOT = TR_AER + TR_MAR + TR_AUT
      # ENSEMBLE = ACC.CORP.&MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM
      # TOTAL = ENSEMBLE + ACCEPTATION
      
      ## Compilation des données sans combinaison ---- 
      
      ### I1 <- CHIFFRES D'AFFAIRES ----
      # On crée la feuille de chiffres d'affaires
      I1 <- base 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I1[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[43, 2:11]) 
      # On applique les formules de calcul
      I1 <- I1 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I1)) {I1[nrow(I1), i] <- sum(I1[2:nrow(I1) - 1, i])}
      
      saveRDS(I1, file = "5 - Scripts/I1.RDS")
      
      ### I4 <- PRODUITS FINANCIERS NETS ----
      # On crée la feuille de produits financiers nets
      I4 <- base 
      # On récupère les info. #du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I4[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[54, 2:11]) 
      # On applique les formules de calcul
      I4 <- I4 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I4)) {I4[nrow(I4), i] <- sum(I4[2:nrow(I4) - 1, i])}
      
      saveRDS(I4, file = "5 - Scripts/I4.RDS")
      
      ### I5 <- PRESTATIONS PAYEES ----
      # On crée la feuille de prestatiosn payées
      I5 <- base 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I5[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[11, 2:11]) 
      # On applique les formules de calcul
      I5 <- I5 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I5)) {I5[nrow(I5), i] <- sum(I5[2:nrow(I5) - 1, i])}
      
      saveRDS(I5, file = "5 - Scripts/I5.RDS")
      
      ### I8 <- COMMISSIONS ----
      # On crée la feuille de commissions
      I8 <- base 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I8[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[25, 2:11]) 
      # On applique les formules de calcul
      I8 <- I8 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I8)) {I8[nrow(I8), i] <- sum(I8[2:nrow(I8) - 1, i])}
      
      saveRDS(I8, file = "5 - Scripts/I8.RDS")
      
      ### I9 <- FRAIS GENERAUX ----
      # On crée la feuille de frais généraux
      I9 <- base 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I9[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[26, 2:11]) 
      # On applique les formules de calcul
      I9 <- I9 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I9)) {I9[nrow(I9), i] <- sum(I9[2:nrow(I9) - 1, i])}
      
      saveRDS(I9, file = "5 - Scripts/I9.RDS")
      
      ### I12 <- PRIMES ACQUISES AUX REASSUREURS ----
      # On crée la feuille de primes acquises aux réassureurs
      I12 <- base 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I12[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[31, 2:11]) 
      # On applique les formules de calcul
      I12 <- I12 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I12)) {I12[nrow(I12), i] <- sum(I12[2:nrow(I12) - 1, i])}
      
      saveRDS(I12, file = "5 - Scripts/I12.RDS")
      
      ### I13 <- PART DES REASSUREURS DANS LES CHARGES ----
      # On crée la feuille de part des réassureurs dans les charges
      I13 <- base 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I13[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[61, 2:11]) 
      # On applique les formules de calcul
      I13 <- I13 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I13)) {I13[nrow(I13), i] <- sum(I13[2:nrow(I13) - 1, i])}
      
      saveRDS(I13, file = "5 - Scripts/I13.RDS")
      
      ## Compilation des données avec combinaison ----
      
      ### I2A <- PROV. PRIMES A LA CLOTURE ----
      # On crée la feuille de part des réassureurs dans les charges
      I2A <- base 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I2A[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- 
        as.numeric(C1[46, 2:11]) + as.numeric(C1[49, 2:11]) + as.numeric(C1[52, 2:11])
      # On applique les formules de calcul
      I2A <- I2A %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I2A)) {I2A[nrow(I2A), i] <- sum(I2A[2:nrow(I2A) - 1, i])}
      
      saveRDS(I2A, file = "5 - Scripts/I2A.RDS")
      
      ### I2B <- PROV. PRIMES A L'OUVERTURE ----
      # On crée la feuille de part des réassureurs dans les charges
      I2B <- base 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I2B[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- 
        as.numeric(C1[45, 2:11]) + as.numeric(C1[48, 2:11]) + as.numeric(C1[51, 2:11])
      # On applique les formules de calcul
      I2B <- I2B %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I2B)) {I2B[nrow(I2B), i] <- sum(I2B[2:nrow(I2B) - 1, i])}
      
      saveRDS(I2B, file = "5 - Scripts/I2B.RDS")
      
      ### I6A <- PROV. TECH. A LA CLOTURE ----
      # On crée la feuille de part des réassureurs dans les charges
      I6A <- base 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I6A[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- 
        as.numeric(C1[14, 2:11]) + as.numeric(C1[17, 2:11]) - as.numeric(C1[20, 2:11]) + 
        as.numeric(C1[23, 2:11])
      # On applique les formules de calcul
      I6A <- I6A %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I6A)) {I6A[nrow(I6A), i] <- sum(I6A[2:nrow(I6A) - 1, i])}
      
      saveRDS(I6A, file = "5 - Scripts/I6A.RDS")
      
      ### I6B <- PROV. TECH. A L'OUVERTURE ----
      # On crée la feuille de part des réassureurs dans les charges
      I6B <- base 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I6B[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- 
        as.numeric(C1[14, 2:11]) + as.numeric(C1[17, 2:11]) - as.numeric(C1[20, 2:11]) + 
        as.numeric(C1[23, 2:11])
      # On applique les formules de calcul
      I6B <- I6B %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I6B)) {I6B[nrow(I6B), i] <- sum(I6B[2:nrow(I6B) - 1, i])}
      
      saveRDS(I6B, file = "5 - Scripts/I6B.RDS")
      
      ## Compilation des données de l'état réassurance ----
      
      ### Formules Réass.
      # PRIM_ACQ_REASS = PRIMES_CEDEES - (PROV_PRIM_CLO. - PROV_PRIM_OUV.) 
      # PART_REASS_CHRG = PART_REASS_PREST - (PROV_CHRG_OUV - PROV_CHRG_CLO) + COMMISSIONS
      # SOLDE_REASS = PART_REASS_CHRG - PRIM_ACQ_REASS
      
      ### I17 <- REASSURANCES ----
      # On crée la feuille de part des réassureurs dans les charges
      I17 <- base.reass 
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I17[which(liste.comp == comp), c(2:4, 6:9)] <- 
        as.numeric(C1[c(27, 29, 30, 56, 58, 59, 60), 12]) 
      # On applique les formules de calcul
      I17 <- I17 %>% 
        mutate(PRIM_ACQ_REASS = PRIMES_CEDEES - (PROV_PRIM_CLO. - PROV_PRIM_OUV.), 
               PART_REASS_CHRG = PART_REASS_PREST - (PROV_CHRG_OUV - PROV_CHRG_CLO) + COMMISSIONS, 
               SOLDE_REASS = PART_REASS_CHRG - PRIM_ACQ_REASS) 
      for (i in 2:ncol(I17)) {I17[nrow(I17), i] <- sum(I17[2:nrow(I17) - 1, i])}
      
      saveRDS(I17, file = "5 - Scripts/I17.RDS")
      
      ## Compilation des données sur les engaemnets règlementés et leur couverture ----
      
      ### Formule
      # TOT_ENG = PREC + PSAP + PMATH + AUT_PROV + AUT_ENG_REG 
      # TOT_PLAC = VAL_ETAT + IMM + AUT_VAL + BANQUE + CRE_CED + PRM_REC
      # MARG_COUV = TOT_PLAC - TOT_ENG
      # TAUX_COUV = TOT_PLAC / TOT_ENG
      
      ### I18 <- ENGAGEMENTS REGLEMENTES ET LEUR COUVERTURE ----
      # On crée la feuille des engagements règlementés
      I18 <- base.reg 
      # On récupère les info. du C4 de la compagnie pour les mettre dans notre dossier de compilation
      I18[which(liste.comp == comp), c(2:6, 8,9)] <- as.numeric(C4[c(4:8, 11,19), 6]) 
      I18[which(liste.comp == comp), 10] <- 
        as.numeric(C4[34, 6]) - as.numeric(C4[32, 6]) - sum(as.numeric(C4[27:29, 6])) -
        as.numeric(C4[23, 6]) - as.numeric(C4[19, 6]) - as.numeric(C4[11, 6])
      I18[which(liste.comp == comp), c(11,12)] <- as.numeric(C4[c(23, 32), 6]) 
      I18[which(liste.comp == comp), c(13)] <- sum(as.numeric(C4[27:29, 6])) 
      # On applique les formules de calcul
      I18 <- I18 %>% 
        mutate(TOT_ENG = PREC + PSAP + PMATH + AUT_PROV + AUT_ENG_REG, 
               TOT_PLAC = VAL_ETAT + IMM + AUT_VAL + BANQUE + CRE_CED + PRM_REC, 
               MARG_COUV = TOT_PLAC - TOT_ENG, 
               TAUX_COUV = TOT_PLAC / TOT_ENG) 
      for (i in 2:ncol(I18)) {I18[nrow(I18), i] <- sum(I18[2:nrow(I18) - 1, i])}
      
      saveRDS(I18, file = "5 - Scripts/I18.RDS")
      
      # Création du dossier de compilation sous format Excel ---- 
      
      ## Rassemblement des états ----
      liste.etats <- list(I1, I2A, I2B, I4, I5, I6A, I6B, I8, I9, I12, I13, I17, I18)
      feuils <- c("I1", "I2A", "I2B", "I4", "I5", "I6A", "I6B", "I8", "I9", "I12", "I13", "I17", "I18")
      nom <- paste0("Compil_ann_", ann, "_", branche, ".xlsx")
      doss <- paste("5 - Scripts", nom, sep = "/")
      
      ## Fichier Excel ----
      write.xlsx(liste.etats, doss, sheetName = feuils, overwrite = TRUE)
      
    }
    else if (branche == "VIE") {
      print("Fonctionnalité en cours de développement veuillez patienter =) !!! ")
    }
  }
  
  else if (action == "ajouter") {
    if (branche == "IARD") {
      # Chargement des fichiers pour la compilation ----
      
      ## Fichier compagnie ----
      C1 <- read.xlsx(chemin_C1, sheet = 1)
      C4 <- read.xlsx(chemin_C4, sheet = 1)
      ### On transforme les 'NA' en 0
      # C1
      for (i in 1:nrow(C1)) {
        for (j in 1:ncol(C1)) {if (is.na(C1[i, j] == TRUE)) {C1[i, j] <- 0}}
      }
      # C4
      for (i in 1:nrow(C4)) {
        for (j in 1:ncol(C4)) {if (is.na(C4[i, j] == TRUE)) {C4[i, j] <- 0}}
      }
      
      ## Fichier compilation ----
      I1 <- read_rds("5 - Scripts/I1.RDS")
      I2A <- read_rds("5 - Scripts/I2A.RDS")
      I2B <- read_rds("5 - Scripts/I2B.RDS")
      I4 <- read_rds("5 - Scripts/I4.RDS")
      I5 <- read_rds("5 - Scripts/I5.RDS")
      I6A <- read_rds("5 - Scripts/I6A.RDS")
      I6B <- read_rds("5 - Scripts/I6B.RDS")
      I8 <- read_rds("5 - Scripts/I8.RDS")
      I9 <- read_rds("5 - Scripts/I9.RDS")
      I12 <- read_rds("5 - Scripts/I12.RDS")
      I13 <- read_rds("5 - Scripts/I13.RDS")
      I17 <- read_rds("5 - Scripts/I17.RDS")
      I18 <- read_rds("5 - Scripts/I18.RDS")
      liste.comp <- 
        c("2ACI", "ACTIVA", "ALLIANZ", "AMSA", "ATLANTA", "ATLANTIQUE", "AXA", "COMAR", 
          "CORIS", "GNA", "LA LOYALE", "LEADWAY", "MATCA",  "NSIA", "SAAR", "SANLAM", 
          "SCHIBA", "SERENITY S.A", "SIDAM S.A", "SMABTP", "SONAM", "SUNU", "WAFA")
      
      # Compilation des données ----
      
      ## Correspondance des feuilles ----
      
      # I1 <- CHIFFRES D'AFFAIRES
      # I2A <- PROV. PRIMES A LA CLOTURE
      # I2B <- PROV. PRIMES A L'OUVERTURE
      # I4 <- PRODUITS FINANCIERS NETS
      # I5 <- PRESTATIONS PAYEES
      # I6A <- PROV. TECH. A LA CLOTURE
      # I6B <- PROV. TECH. A L'OUVERTURE
      # I8 <- COMMISSIONS
      # I9 <- FRAIS GENERAUX
      # I12 <- PRIMES ACQUISES AUX REASSUREURS
      # I13 <- PART DES REASSUREURS DANS LES CHARGES
      # I17 <- REASSURANCES
      # I18 <- ENGAGEMENTS REGLEMENTES ET LEUR COUVERTURE
      
      ## Formules C1
      # AUTO_TOT = AUTO_RC + AUTO_DOMM
      # TR_TOT = TR_AER + TR_MAR + TR_AUT
      # ENSEMBLE = ACC.CORP.&MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM
      # TOTAL = ENSEMBLE + ACCEPTATION
      
      ## Compilation des données sans combinaison ----
      
      ### I1 <- CHIFFRES D'AFFAIRES ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I1[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[43, 2:11]) 
      # On applique les formules de calcul
      I1 <- I1 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I1)) {I1[nrow(I1), i] <- sum(I1[2:nrow(I1) - 1, i])}
      
      saveRDS(I1, file = "5 - Scripts/I1.RDS")
      
      ### I4 <- PRODUITS FINANCIERS NETS ----
      # On récupère les info. #du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I4[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[54, 2:11]) 
      # On applique les formules de calcul
      I4 <- I4 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I4)) {I4[nrow(I4), i] <- sum(I4[2:nrow(I4) - 1, i])}
      
      saveRDS(I4, file = "5 - Scripts/I4.RDS")
      
      ### I5 <- PRESTATIONS PAYEES ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I5[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[11, 2:11]) 
      # On applique les formules de calcul
      I5 <- I5 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I5)) {I5[nrow(I5), i] <- sum(I5[2:nrow(I5) - 1, i])}
      
      saveRDS(I5, file = "5 - Scripts/I5.RDS")
      
      ### I8 <- COMMISSIONS ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I8[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[25, 2:11]) 
      # On applique les formules de calcul
      I8 <- I8 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I8)) {I8[nrow(I8), i] <- sum(I8[2:nrow(I8) - 1, i])}
      
      saveRDS(I8, file = "5 - Scripts/I8.RDS")
      
      ### I9 <- FRAIS GENERAUX ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I9[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[26, 2:11]) 
      # On applique les formules de calcul
      I9 <- I9 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I9)) {I9[nrow(I9), i] <- sum(I9[2:nrow(I9) - 1, i])}
      
      saveRDS(I9, file = "5 - Scripts/I9.RDS")
      
      ### I12 <- PRIMES ACQUISES AUX REASSUREURS ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I12[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[31, 2:11]) 
      # On applique les formules de calcul
      I12 <- I12 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I12)) {I12[nrow(I12), i] <- sum(I12[2:nrow(I12) - 1, i])}
      
      saveRDS(I12, file = "5 - Scripts/I12.RDS")
      
      ### I13 <- PART DES REASSUREURS DANS LES CHARGES ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I13[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- as.numeric(C1[61, 2:11]) 
      # On applique les formules de calcul
      I13 <- I13 %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION)
      for (i in 2:ncol(I13)) {I13[nrow(I13), i] <- sum(I13[2:nrow(I13) - 1, i])}
      
      saveRDS(I13, file = "5 - Scripts/I13.RDS")
      
      ## Compilation des données avec combinaison ----
      
      ### I2A <- PROV. PRIMES A LA CLOTURE ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I2A[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- 
        as.numeric(C1[46, 2:11]) + as.numeric(C1[49, 2:11]) + as.numeric(C1[52, 2:11])
      # On applique les formules de calcul
      I2A <- I2A %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I2A)) {I2A[nrow(I2A), i] <- sum(I2A[2:nrow(I2A) - 1, i])}
      
      saveRDS(I2A, file = "5 - Scripts/I2A.RDS")
      
      ### I2B <- PROV. PRIMES A L'OUVERTURE ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I2B[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- 
        as.numeric(C1[45, 2:11]) + as.numeric(C1[48, 2:11]) + as.numeric(C1[51, 2:11])
      # On applique les formules de calcul
      I2B <- I2B %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I2B)) {I2B[nrow(I2B), i] <- sum(I2B[2:nrow(I2B) - 1, i])}
      
      saveRDS(I2B, file = "5 - Scripts/I2B.RDS")
      
      ### I6A <- PROV. TECH. A LA CLOTURE ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I6A[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- 
        as.numeric(C1[14, 2:11]) + as.numeric(C1[17, 2:11]) - as.numeric(C1[20, 2:11]) + 
        as.numeric(C1[23, 2:11])
      # On applique les formules de calcul
      I6A <- I6A %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I6A)) {I6A[nrow(I6A), i] <- sum(I6A[2:nrow(I6A) - 1, i])}
      
      saveRDS(I6A, file = "5 - Scripts/I6A.RDS")
      
      ### I6B <- PROV. TECH. A L'OUVERTURE ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I6B[which(liste.comp == comp), c(2:4, 6:10, 12, 14)] <- 
        as.numeric(C1[14, 2:11]) + as.numeric(C1[17, 2:11]) - as.numeric(C1[20, 2:11]) + 
        as.numeric(C1[23, 2:11])
      # On applique les formules de calcul
      I6B <- I6B %>% 
        mutate(AUTO_TOT = AUTO_RC + AUTO_DOMM,
               TR_TOT = TR_AER + TR_MAR + TR_AUT,
               ENSEMBLE = ACC.CORP._MAL. + AUTO_TOT + INCENDIE_AUTRES_DOMM_AUX_BIENS + RC_GEN + TR_TOT + AUTRES_RD_DOMM,
               TOTAL = ENSEMBLE + ACCEPTATION) 
      for (i in 2:ncol(I6B)) {I6B[nrow(I6B), i] <- sum(I6B[2:nrow(I6B) - 1, i])}
      
      saveRDS(I6B, file = "5 - Scripts/I6B.RDS")
      
      ## Compilation des données de l'état réassurance ----
      
      ### Formules Réass.
      # PRIM_ACQ_REASS = PRIMES_CEDEES - (PROV_PRIM_CLO. - PROV_PRIM_OUV.) 
      # PART_REASS_CHRG = PART_REASS_PREST - (PROV_CHRG_OUV - PROV_CHRG_CLO) + COMMISSIONS
      # SOLDE_REASS = PART_REASS_CHRG - PRIM_ACQ_REASS
      
      ### I17 <- REASSURANCES ----
      # On récupère les info. du C1 de la compagnie pour les mettre dans notre dossier de compilation
      I17[which(liste.comp == comp), c(2:4, 6:9)] <- 
        as.numeric(C1[c(27, 29, 30, 56, 58, 59, 60), 12]) 
      # On applique les formules de calcul
      I17 <- I17 %>% 
        mutate(PRIM_ACQ_REASS = PRIMES_CEDEES - (PROV_PRIM_CLO. - PROV_PRIM_OUV.), 
               PART_REASS_CHRG = PART_REASS_PREST - (PROV_CHRG_OUV - PROV_CHRG_CLO) + COMMISSIONS, 
               SOLDE_REASS = PART_REASS_CHRG - PRIM_ACQ_REASS) 
      for (i in 2:ncol(I17)) {I17[nrow(I17), i] <- sum(I17[2:nrow(I17) - 1, i])}
      
      saveRDS(I17, file = "5 - Scripts/I17.RDS")
      
      ## Compilation des données sur les engaemnets règlementés et leur couverture ----
      
      ### Formule
      # TOT_ENG = PREC + PSAP + PMATH + AUT_PROV + AUT_ENG_REG 
      # TOT_PLAC = VAL_ETAT + IMM + AUT_VAL + BANQUE + CRE_CED + PRM_REC
      # MARG_COUV = TOT_PLAC - TOT_ENG
      # TAUX_COUV = TOT_PLAC / TOT_ENG
      
      ### I18 <- ENGAGEMENTS REGLEMENTES ET LEUR COUVERTURE ----
      # On récupère les info. du C4 de la compagnie pour les mettre dans notre dossier de compilation
      I18[which(liste.comp == comp), c(2:6, 8,9)] <- as.numeric(C4[c(4:8, 11,19), 6]) 
      I18[which(liste.comp == comp), 10] <- 
        as.numeric(C4[34, 6]) - as.numeric(C4[32, 6]) - sum(as.numeric(C4[27:29, 6])) -
        as.numeric(C4[23, 6]) - as.numeric(C4[19, 6]) - as.numeric(C4[11, 6])
      I18[which(liste.comp == comp), c(11,12)] <- as.numeric(C4[c(23, 32), 6]) 
      I18[which(liste.comp == comp), c(13)] <- sum(as.numeric(C4[27:29, 6])) 
      # On applique les formules de calcul
      I18 <- I18 %>% 
        mutate(TOT_ENG = PREC + PSAP + PMATH + AUT_PROV + AUT_ENG_REG, 
               TOT_PLAC = VAL_ETAT + IMM + AUT_VAL + BANQUE + CRE_CED + PRM_REC, 
               MARG_COUV = TOT_PLAC - TOT_ENG, 
               TAUX_COUV = TOT_PLAC / TOT_ENG)
      for (i in 2:ncol(I18)) {I18[nrow(I18), i] <- sum(I18[2:nrow(I18) - 1, i])}
      
      saveRDS(I18, file = "5 - Scripts/I18.RDS")
      
      # Création du dossier de compilation sous forlat excel ---- 
      
      ## Rassemblement des états ----
      liste.etats <- list(I1, I2A, I2B, I4, I5, I6A, I6B, I8, I9, I12, I13, I17, I18)
      feuils <- c("I1", "I2A", "I2B", "I4", "I5", "I6A", "I6B", "I8", "I9", "I12", "I13", "I17", "I18")
      nom <- paste0("Compil_ann_", ann, "_", branche, ".xlsx")
      doss <- paste("5 - Scripts", nom, sep = "/")
      
      ## Enregistrement du fichier Excel ----
      write.xlsx(liste.etats, doss, sheetName = feuils, overwrite = TRUE)
    }
    else if (branche == "VIE") {
      print("Fonctionnalité en cours de développement veuillez patienter =) !!!")
    }
  }
}
