brch = "IARD"
ann = 2023
comp = "ACTIVA"
ett = "Bilan"
chem_e = "ACTIVA/Non vie/2023/Annuel/Re_ ACTIVA _ Rappel - Collecte de données annuelles de 2023/Bilan_IARD_2023.xlsx"
setwd("C:/Users/Ismail SARE/OneDrive - ASSOCIATION DES SOCIETES D'ASSURANCES/Chiffres/Donnees")

# Création d'un nouvel état consolidé
if (acion == "creer") {
  # Créaation d'un état en IARD
  if (brch == "IARD") {
    
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
      ## Actif
      Bilan_base[c(5:6, 9:12, 14:17, 19:20, 23:24, 27:43, 45), c(2:4)] <- 
        Bilan_comp[c(6:7, 10:13, 15:18, 20:21, 24:25, 28:44, 46), c(3:5)]
      ## Formules
      Bilan_base[7, 2] <- sum(as.numeric(Bilan_base[5:6, 2]))
      Bilan_base[7, 3] <- sum(as.numeric(Bilan_base[5:6, 3]))
      Bilan_base[7, 4] <- sum(as.numeric(Bilan_base[5:6, 4]))
      
      Bilan_base[21, 2] <- sum(as.numeric(Bilan_base[c(9:12, 14:17), 2])) - 
        sum(as.numeric(Bilan_base[19:20, 2]))
      Bilan_base[21, 3] <- sum(as.numeric(Bilan_base[c(9:12, 14:17), 3]))
      Bilan_base[21, 4] <- sum(as.numeric(Bilan_base[c(9:12, 14:17), 4])) - 
        sum(as.numeric(Bilan_base[19:20, 4]))
      
      Bilan_base[25, 2] <-  sum(as.numeric(Bilan_base[23:24, 2]))
      Bilan_base[25, 3] <-  sum(as.numeric(Bilan_base[23:24, 3]))
      Bilan_base[25, 4] <-  sum(as.numeric(Bilan_base[23:24, 4]))
      
      Bilan_base[44, 2] <-  sum(as.numeric(Bilan_base[27:43, 2]))
      Bilan_base[44, 3] <-  sum(as.numeric(Bilan_base[27:43, 3]))
      Bilan_base[44, 4] <-  sum(as.numeric(Bilan_base[27:43, 4]))
      Bilan_base[45, 4] <- as.numeric(Bilan_base[45, 4])
      
      ## Passif
      Bilan_base[c(56:62, 64:71, 73:74, 75, 77, 79, 81:82, 85:87, 90:102, 104), c(3:4)] <- 
        Bilan_comp[c(57:63, 65:72, 74:75, 76, 78, 80, 82:83, 86:88, 91:103, 105), c(4:5)]
      ## Formles
      Bilan_base[61, 3] <- as.numeric(Bilan_base[59, 4]) - as.numeric(Bilan_base[60, 3])
      
      Bilan_base[76, 4] <- sum(as.numeric(Bilan_base[c(56, 59, 62, 64:71, 73:75), 4]))
      
      Bilan_base[83, 4] <- sum(as.numeric(Bilan_base[c(77, 79, 81:82), 4]))
      
      Bilan_base[88, 4] <- sum(as.numeric(Bilan_base[c(85:86), 3])) - sum(as.numeric(Bilan_base[87, 3]))
      
      Bilan_base[103, 4] <- sum(as.numeric(Bilan_base[c(90:102), 4]))
      
      Bilan_base[46, 4] <- ifelse(
        sum(as.numeric(Bilan_base[c(7, 21, 25, 44), 4])) < sum(as.numeric(Bilan_base[c(76, 83, 88, 103), 4])),
        sum(as.numeric(Bilan_base[c(76, 83, 88, 103), 4])) - sum(as.numeric(Bilan_base[c(7, 21, 25, 44), 4])),
        0
      )
      
      Bilan_base[105, 4] <- ifelse(
        sum(as.numeric(Bilan_base[c(7, 21, 25, 44), 4])) > sum(as.numeric(Bilan_base[c(76, 83, 88, 103), 4])),
        sum(as.numeric(Bilan_base[c(7, 21, 25, 44), 4])) - sum(as.numeric(Bilan_base[c(76, 83, 88, 103), 4])),
        0
      )
      
      Bilan_base[47, 4] <- sum(as.numeric(Bilan_base[c(7, 21, 25, 44:46), 4]))
      Bilan_base[106, 4] <- sum(as.numeric(Bilan_base[c(76, 83, 88, 103:105), 4]))
      
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
    
    else {print(cat("Veuillez choisir un etat répertorié dans la liste :\n 'Bilan', 'CEG', 'C1', 'C4', 'C5', 'C11'"))}
  }
  
  # Création d'un état en VIE
  else if ( brch == "VIE") {
    if (ett == "Bilan") {}
    
    else if (ett == "CEG") {}
    
    else if (ett == "C1") {}
    
    else if (ett == "C5") {}
    
    else if (ett == "C11") {}
    
    else {print(cat("Veuillez choisir un etat répertorié dans la liste :\n 'Bilan', 'CEG', 'C1', 'C4', 'C5', 'C11'"))}
  }
  
  #Message d'erreur
  else {print(cat("Veuillez choisir une branche répertoriée dans la liste :\n 'IARD', 'VIE'"))}
  
}

# Ajout d'une compagnie supplémentaire pour un état donné
else if (action == "ajouter") {
  # Ajout d'un état en IARD
  if (brch == "IARD") {
    # Ajout du bilan
    if (ett == "Bilan") {
      # Chargement du fichier de base pour la compilation ----
      Bilan_base <- read_rds("5 - Scripts/Fanaf_Bilan_N.Vie_2023.RDS")
      
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
      ## Actif
      Bilan_base[c(5:6, 9:12, 14:17, 19:20, 23:24, 27:43, 45), 2] <- 
        as.numeric(Bilan_base[c(5:6, 9:12, 14:17, 19:20, 23:24, 27:43, 45), 2]) + 
        as.numeric(Bilan_comp[c(6:7, 10:13, 15:18, 20:21, 24:25, 28:44, 46), 3])
      
      Bilan_base[c(5:6, 9:12, 14:17, 23:24, 27:43, 45), 3] <- 
        as.numeric(Bilan_base[c(5:6, 9:12, 14:17, 23:24, 27:43, 45), 3]) + 
        as.numeric(Bilan_comp[c(6:7, 10:13, 15:18, 24:25, 28:44, 46), 4])
      
      Bilan_base[c(5:6, 9:12, 14:17, 19:20, 23:24, 27:43, 45), 4] <- 
        as.numeric(Bilan_base[c(5:6, 9:12, 14:17, 19:20, 23:24, 27:43, 45), 4]) + 
        as.numeric(Bilan_comp[c(6:7, 10:13, 15:18, 20:21, 24:25, 28:44, 46), 5])
      
      
      ## Formules
      Bilan_base[7, 2] <- sum(as.numeric(Bilan_base[5:6, 2]))
      Bilan_base[7, 3] <- sum(as.numeric(Bilan_base[5:6, 3]))
      Bilan_base[7, 4] <- sum(as.numeric(Bilan_base[5:6, 4]))
      
      Bilan_base[21, 2] <- sum(as.numeric(Bilan_base[c(9:12, 14:17), 2])) - 
        sum(as.numeric(Bilan_base[19:20, 2]))
      Bilan_base[21, 3] <- sum(as.numeric(Bilan_base[c(9:12, 14:17), 3]))
      Bilan_base[21, 4] <- sum(as.numeric(Bilan_base[c(9:12, 14:17), 4])) - 
        sum(as.numeric(Bilan_base[19:20, 4]))
      
      Bilan_base[25, 2] <-  sum(as.numeric(Bilan_base[23:24, 2]))
      Bilan_base[25, 3] <-  sum(as.numeric(Bilan_base[23:24, 3]))
      Bilan_base[25, 4] <-  sum(as.numeric(Bilan_base[23:24, 4]))
      
      Bilan_base[44, 2] <-  sum(as.numeric(Bilan_base[27:43, 2]))
      Bilan_base[44, 3] <-  sum(as.numeric(Bilan_base[27:43, 3]))
      Bilan_base[44, 4] <-  sum(as.numeric(Bilan_base[27:43, 4]))
      Bilan_base[45, 4] <- as.numeric(Bilan_base[45, 4])
      
      ## Passif
      Bilan_base[c(56:62, 64:71, 73:74, 75, 77, 79, 81:82, 85:87, 90:102, 104), c(3:4)] <- 
        Bilan_comp[c(57:63, 65:72, 74:75, 76, 78, 80, 82:83, 86:88, 91:103, 105), c(4:5)]
      
      Bilan_base[c(56:62, 64:71, 73:74, 75, 77, 79, 81:82, 85:87, 90:102, 104), 3] <- 
        as.numeric(Bilan_base[c(56:62, 64:71, 73:74, 75, 77, 79, 81:82, 85:87, 90:102, 104), 3]) +
        as.numeric(Bilan_comp[c(57:63, 65:72, 74:75, 76, 78, 80, 82:83, 86:88, 91:103, 105), 4])
      
      Bilan_base[c(56, 59, 62, 64:71, 73:74, 75, 77, 79, 81:82, 90:102, 104), 4] <- 
        as.numeric(Bilan_base[c(56, 59, 62, 64:71, 73:74, 75, 77, 79, 81:82, 90:102, 104), 4]) +
        as.numeric(Bilan_comp[c(57, 60, 63, 65:72, 74:75, 76, 78, 80, 82:83, 91:103, 105), 5])
      
      
      
      ## Formles
      Bilan_base[61, 3] <- as.numeric(Bilan_base[59, 4]) - as.numeric(Bilan_base[60, 3])
      
      Bilan_base[76, 4] <- sum(as.numeric(Bilan_base[c(56, 59, 62, 64:71, 73:75), 4]))
      
      Bilan_base[83, 4] <- sum(as.numeric(Bilan_base[c(77, 79, 81:82), 4]))
      
      Bilan_base[88, 4] <- sum(as.numeric(Bilan_base[c(85:86), 3])) - sum(as.numeric(Bilan_base[87, 3]))
      
      Bilan_base[103, 4] <- sum(as.numeric(Bilan_base[c(90:102), 4]))
      
      Bilan_base[46, 4] <- ifelse(
        sum(as.numeric(Bilan_base[c(7, 21, 25, 44), 4])) < sum(as.numeric(Bilan_base[c(76, 83, 88, 103), 4])),
        sum(as.numeric(Bilan_base[c(76, 83, 88, 103), 4])) - sum(as.numeric(Bilan_base[c(7, 21, 25, 44), 4])),
        0
      )
      
      Bilan_base[105, 4] <- ifelse(
        sum(as.numeric(Bilan_base[c(7, 21, 25, 44), 4])) > sum(as.numeric(Bilan_base[c(76, 83, 88, 103), 4])),
        sum(as.numeric(Bilan_base[c(7, 21, 25, 44), 4])) - sum(as.numeric(Bilan_base[c(76, 83, 88, 103), 4])),
        0
      )
      
      Bilan_base[47, 4] <- sum(as.numeric(Bilan_base[c(7, 21, 25, 44:46), 4]))
      Bilan_base[106, 4] <- sum(as.numeric(Bilan_base[c(76, 83, 88, 103:105), 4]))
      
      # Sauvegarde ----
      saveRDS(Bilan_base, paste0("5 - Scripts/", "Fanaf_Bilan_N.Vie_", ann, ".RDS"))
    }
    
    # Ajout du CEG
    else if (ett == "CEG") {}
    
    # Ajout du C1
    else if (ett == "C1") {}
    
    # Ajout du C5
    else if (ett == "C5") {}
    
    # Ajout du C11
    else if (ett == "C11") {}
    
  }
  
  # Ajout d'un état en VIE
  else if ( brch == "VIE") {
    # Ajout du bilan
    if (ett == "Bilan") {
      
    }
    
    # Ajout du CEG
    else if (ett == "CEG") {
      
    }
    
    # Ajout du C1
    else if (ett == "C1") {}
    
    # Ajout du C5
    else if (ett == "C5") {}
    
    # Ajout du C11
    else if (ett == "C11") {}
    
    # Message d'erreur
    else {print(cat("Veuillez choisir un etat répertorié dans la liste :\n 'Bilan', 'CEG', 'C1', 'C4', 'C5', 'C11'"))}
  }
}

# Message d'erreur
else{print(cat("Veuillez choisir une action répertorié dans la liste :\n 'creer', 'ajouter'"))}
