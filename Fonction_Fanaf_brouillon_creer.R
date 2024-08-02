brch = "IARD"
ann = 2023
comp = "ACTIVA"
ett = "C1"
chem_e = "ACTIVA/Non vie/2023/Annuel/Re_ ACTIVA _ Rappel - Collecte de données annuelles de 2023/Bilan_IARD_2023.xlsx"




 

if (brch == "IARD") {
  
  # Chargement 
  if (ett == "Bilan") {
    # Chargement du fichier de base pour la compilation ----
    ## appelle et execution de la fonction de création de données
    source("5 - Scripts/Fonction_Fanaf_bases.R")
    comp_Fanaf_bases(branche = brch, annee = ann, etat = ett)
    ## Creation de l'etat de compilation
    Bilan_base <- read_rds(paste0("5 - Scripts/Fanaf_",ett,"_N.Vie.RDS"))
    
    # Chargement du dossier ----
    Bilan_comp <- openxlsx::read.xlsx(chem_e, sheet = 1)
    ## Remplacement des 'NA' par 0
    for (i in 1:nrow(Bilan_comp)) {
      for (j in 1:ncol(Bilan_comp)) {
        if (is.na(Bilan_comp[i, j]) == TRUE) {Bilan_comp[i, j] <- 0}
      }
    }
    rm(i, j)
    
    # Compilation ----
    ## Debit
    Bilan_base[c(), c()] <- 
      Bilan_comp[c(), c()]
    ## Credit
    Bilan_base[c(), c()] <- 
      Bilan_comp[c(), c()]
    
    # Sauvegarde ----
    saveRDS(Bilan_base, paste0("5 - Scripts/", "Fanaf_Bilan_N.Vie_", ann, ".RDS"))
  }
  
  else if (ett == "CEG") {}
  
  else if (ett == "C1") {
    # Chargement du fichier de base pour la compilation ----
    ## appelle et execution de la fonction de création de données
    source("5 - Scripts/Fonction_Fanaf_bases.R")
    comp_Fanaf_bases(branche = brch, annee = ann, etat = ett)
    ## Creation de l'etat de compilation
    C1_base <- read_rds(paste0("5 - Scripts/Fanaf_",ett,"_N.Vie.RDS"))
    
    # Chargement du dossier ----
    C1_comp <- openxlsx::read.xlsx(chem_e, sheet = 1)
    ## Remplacement des 'NA' par 0
    for (i in 1:nrow(C1_comp)) {
      for (j in 1:ncol(C1_comp)) {
        if (is.na(C1_comp[i, j]) == TRUE) {C1_comp[i, j] <- 0}
      }
    }
    rm(i, j)
    
    # Compilation ----
    ## Debit
    C1_base[c(4:8, 11:12, 14:15, 17:18, 20:21, 23:25, 27:28), c(2:12)] <- 
      C1_comp[c(6:10, 13:14, 16:17, 19:20, 22:23, 25:27, 29:30), c(2:12)]
    ## Credit
    C1_base[c(35:37, 40:41, 43:44, 46:47, 49:51, 53:55), c(2:12)] <- 
      C1_comp[c(40:42, 45:46, 48:49, 51:52, 54:56, 58:60), c(2:12)]
    
    # Sauvegarde ----
    saveRDS(C1_base, paste0("5 - Scripts/", "Fanaf_C1_N.Vie_", ann, ".RDS"))
  }
  
  else if (ett == "C5") {}
  
  else if (ett == "C11") {}
  
  # Compilation ----
  
}
  ## base des états similaires
  base <- read_rds("5 - Scripts/compil_ann_base_IARD.RDS") 
  ## base états de réassurance
  base.reass <- read_rds("5 - Scripts/compil_ann_reass_IARD.RDS") 
  ## base état des engagements règlementés
  base.reg <- read_rds("5 - Scripts/compil_ann_reg_IARD.RDS")
  
  file.info()
  assign("d", 25)
  