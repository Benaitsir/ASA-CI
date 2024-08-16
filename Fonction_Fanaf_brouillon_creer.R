action <- "creer"
brch <- "IARD"
ann <- 2023
comp <- "ACTIVA"
ett <- "C11"
chem_e <- "ACTIVA/Non vie/2023/Annuel/Re_ ACTIVA _ Rappel - Collecte de données annuelles de 2023/C11_IARD 2023.xlsx"
setwd("C:/Users/Ismail SARE/OneDrive - ASSOCIATION DES SOCIETES D'ASSURANCES/Chiffres/Donnees")

# Création d'un nouvel état consolidé
if (acion == "creer") {
  # Création d'un état en IARD
  if (brch == "IARD") {
    # Création du Bilan
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
      
      ## Passif
      Bilan_base[c(56:62, 64:71, 73:74, 75, 77, 79, 81:82, 85:87, 90:102, 104), c(3:4)] <- 
        Bilan_comp[c(57:63, 65:72, 74:75, 76, 78, 80, 82:83, 86:88, 91:103, 105), c(4:5)]
      
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
      saveRDS(Bilan_base, paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Message de fin ----
      cat(" - Action :", action, "\n",
          "- Année :", ann, "\n",
          "- Branche :", brch, "\n", 
          "- Ajout de l'état :", ett, "\n", 
          "- Compagnie :", comp, "\n", 
          "- Statut : Terminé")
    }
    
    # Création de l'état CEG
    else if (ett == "CEG") {
      # Chargement du fichier de base pour la compilation ----
      ## appelle et execution de la fonction de création de données
      source("5 - Scripts/Fonction_Fanaf_bases.R")
      comp_Fanaf_bases(branche = brch, annee = ann, etat = ett)
      ## Creation de l'etat de compilation
      CEG_base <- read_rds(paste0("5 - Scripts/Fanaf_",ett,"_N.Vie.RDS"))
      
      # Chargement du dossier ----
      CEG_comp <- openxlsx::read.xlsx(chem_e, sheet = 1)
      ## Remplacement des 'NA' par 0
      for (i in 1:nrow(CEG_comp)) {
        for (j in 1:ncol(CEG_comp)) {
          if (is.na(CEG_comp[i, j]) == TRUE) {CEG_comp[i, j] <- 0}
        }
      }
      rm(i, j)
      
      # Compilation ----
      ## Debit
      CEG_base[c(6:8, 10), c(3:5)] <- CEG_comp[c(6:8, 10), c(3:5)]
      CEG_base[c(12:17, 21:24), 3] <- CEG_comp[c(12:17, 21:24), 3]
      
      ## Credit
      CEG_base[34:36, 3:5] <- CEG_comp[34:36, 3:5]
      CEG_base[c(39:41, 44, 45), 3] <- CEG_comp[c(39:41, 44, 45), 3]
      CEG_base[48, 5] <- CEG_comp[48, 5]
      
      ## Formules
      CEG_base[9, 3] <- sum(as.numeric(CEG_base[6:7, 3])) - as.numeric(CEG_base[8, 3]) 
      CEG_base[9, 4] <- sum(as.numeric(CEG_base[6:7, 4])) - as.numeric(CEG_base[8, 4]) 
      CEG_base[9, 5] <- as.numeric(CEG_base[9, 3]) - as.numeric(CEG_base[9, 4]) 
      
      CEG_base[18, 3] <- sum(as.numeric(CEG_base[12:17, 3]))
      
      CEG_base[19, 3] <- sum(as.numeric(CEG_base[c(10, 18), 3]))
      CEG_base[19, 4] <- CEG_base[10, 4]
      CEG_base[19, 5] <- as.numeric(CEG_base[19, 3]) - as.numeric(CEG_base[19, 4])
      
      CEG_base[25, 5] <- sum(as.numeric(CEG_base[21:24, 3]))
      
      CEG_base[37, 3] <- sum(as.numeric(CEG_base[34:35, 3])) - as.numeric(CEG_base[36, 3])
      CEG_base[37, 4] <- sum(as.numeric(CEG_base[34:35, 4])) - as.numeric(CEG_base[36, 4])
      CEG_base[37, 5] <- as.numeric(CEG_base[37, 3]) - as.numeric(CEG_base[37, 4])
      
      CEG_base[42, 5] <- sum(as.numeric(CEG_base[39:41, 3]))
      
      CEG_base[46, 5] <- sum(as.numeric(CEG_base[44:45, 3]))
      
      CEG_base[26, 5] <- ifelse(
        sum(as.numeric(CEG_base[c(9, 19, 25), 5])) < sum(as.numeric(CEG_base[c(37, 42, 46, 48), 5])),
        sum(as.numeric(CEG_base[c(37, 42, 46, 48), 5])) - sum(as.numeric(CEG_base[c(9, 19, 25), 5])),
        0
      )
      
      CEG_base[49, 5] <- ifelse(
        sum(as.numeric(CEG_base[c(9, 19, 25), 5])) > sum(as.numeric(CEG_base[c(37, 42, 46, 48), 5])),
        sum(as.numeric(CEG_base[c(9, 19, 25), 5])) - sum(as.numeric(CEG_base[c(37, 42, 46, 48), 5])),
        0
      )
      
      CEG_base[27, 5] <- sum(as.numeric(CEG_base[c(9, 19, 25:26), 5]))
      CEG_base[50, 5] <- sum(as.numeric(CEG_base[c(37, 42, 46, 48:49), 5]))
      
      # Sauvegarde ----
      saveRDS(CEG_base, paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Message de fin ----
      cat(" - Action :", action, "\n",
          "- Année :", ann, "\n",
          "- Branche :", brch, "\n", 
          "- Ajout de l'état :", ett, "\n", 
          "- Compagnie :", comp, "\n", 
          "- Statut : Terminé")
    }
    
    # Création de l'état C1
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
      C1_base[c(4:8, 11:12, 14:15, 17:18, 20:21, 23:25, 27:28), c(2:11)] <- 
        C1_comp[c(6:10, 13:14, 16:17, 19:20, 22:23, 25:27, 29:30), c(2:11)]
      
      ## Credit
      C1_base[c(35:37, 40:41, 43:44, 46:47, 49:51, 53:55), c(2:11)] <- 
        C1_comp[c(40:42, 45:46, 48:49, 51:52, 54:56, 58:60), c(2:11)]
      
      ## Formules
      C1_base[9, 2:11] <- as.numeric(C1_base[4, 2:11]) + 
        as.numeric(C1_base[5, 2:11]) + as.numeric(C1_base[6, 2:11]) - 
        as.numeric(C1_base[7, 2:11]) - as.numeric(C1_base[8, 2:11])
      
      C1_base[22, 2:11] <- 
        (-1 * as.numeric(C1_base[11, 2:11])) + as.numeric(C1_base[12, 2:11]) - 
        as.numeric(C1_base[14, 2:11]) + as.numeric(C1_base[15, 2:11]) + 
        as.numeric(C1_base[17, 2:11]) - as.numeric(C1_base[18, 2:11]) - 
        as.numeric(C1_base[20, 2:11]) + as.numeric(C1_base[21, 2:11])
      
      C1_base[29, 2:11] <- as.numeric(C1_base[25, 2:11]) + 
        as.numeric(C1_base[27, 2:11]) - as.numeric(C1_base[28, 2:11])
      
      C1_base[38, 2:11] <- as.numeric(C1_base[35, 2:11]) + 
        as.numeric(C1_base[36, 2:11]) - as.numeric(C1_base[37, 2:11])
      
      C1_base[48, 2:11] <- 
        as.numeric(C1_base[40, 2:11]) - as.numeric(C1_base[41, 2:11]) + 
        as.numeric(C1_base[43, 2:11]) - as.numeric(C1_base[44, 2:11]) + 
        as.numeric(C1_base[46, 2:11]) - as.numeric(C1_base[47, 2:11])
      
      C1_base[56, 2:11] <- 
        as.numeric(C1_base[51, 2:11]) - as.numeric(C1_base[53, 2:11]) + 
        as.numeric(C1_base[54, 2:11]) + as.numeric(C1_base[55, 2:11])
      
      for (i in 2:11) {
        C1_base[30, i] <- 
          ifelse(
            sum(as.numeric(C1_base[c(9, 22:24, 29), i])) < 
              sum(as.numeric(C1_base[c(38, 48:50, 56), i])), 
            
            sum(as.numeric(C1_base[c(38, 48:50, 56), i])) - 
              sum(as.numeric(C1_base[c(9, 22:24, 29), i])), 
            
            0)
      }
      
      for (i in 2:11) {
        C1_base[57, i] <- 
          ifelse(
            sum(as.numeric(C1_base[c(38, 48:50, 56), i])) < 
              sum(as.numeric(C1_base[c(9, 22:24, 29), i])), 
            
            sum(as.numeric(C1_base[c(9, 22:24, 29), i])) - 
              sum(as.numeric(C1_base[c(38, 48:50, 56), i])),
            
            0)
      }
      
      for (i in 2:11) {
        C1_base[31, i] <- sum(as.numeric(C1_base[c(9, 22:24, 29:30), i])) 
      }
      
      for (i in 2:11) {
        C1_base[58, i] <- sum(as.numeric(C1_base[c(38, 48:50, 56:57), i])) 
      }
      
      for (i in c(4:9, 11:12, 14:15, 17:18, 20:25, 27:29, 31, 35:38, 40:41, 43:44, 46:51, 53:56, 58)) {
        C1_base[i, 12] <- sum(as.numeric(C1_base[i, 2:11]))
      }
      rm(i)
      
      C1_base[30, 12] <- ifelse(
        sum(as.numeric(C1_base[c(9, 22:24, 29), 12])) < 
          sum(as.numeric(C1_base[c(38, 48:50, 56), 12])), 
        
        sum(as.numeric(C1_base[c(38, 48:50, 56), 12])) - 
          sum(as.numeric(C1_base[c(9, 22:24, 29), 12])), 
        
        0)
      
      C1_base[57, 12] <- ifelse(
        sum(as.numeric(C1_base[c(38, 48:50, 56), 12])) < 
          sum(as.numeric(C1_base[c(9, 22:24, 29), 12])), 
        
        sum(as.numeric(C1_base[c(9, 22:24, 29), 12])) - 
          sum(as.numeric(C1_base[c(38, 48:50, 56), 12])),
        
        0)
      
      # Sauvegarde ----
      saveRDS(C1_base, paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Message de fin ----
      cat(" - Action :", action, "\n",
          "- Année :", ann, "\n",
          "- Branche :", brch, "\n", 
          "- Ajout de l'état :", ett, "\n", 
          "- Compagnie :", comp, "\n", 
          "- Statut : Terminé")
      
    }
    
    # Création de l'état C4
    else if (ett == "C4") {
      # Chargement du fichier de base pour la compilation ----
      ## appelle et execution de la fonction de création de données
      source("5 - Scripts/Fonction_Fanaf_bases.R")
      comp_Fanaf_bases(branche = brch, annee = ann, etat = ett)
      ## Creation de l'etat de compilation
      C4_base <- read_rds(paste0("5 - Scripts/Fanaf_",ett,"_N.Vie.RDS"))
      
      # Chargement du dossier ----
      C4_comp <- openxlsx::read.xlsx(chem_e, sheet = 1)
      ## Remplacement des 'NA' par 0
      for (i in 1:nrow(C4_comp)) {
        for (j in 1:ncol(C4_comp)) {
          if (is.na(C4_comp[i, j]) == TRUE) {C4_comp[i, j] <- 0}
        }
      }
      rm(i, j)
      
      # Compilation ----
      ## Engagements
      C4_base[3:7, 6] <- C4_comp[4:8, 6]
      
      ## Actifs
      C4_base[10:22, 4:6] <- C4_comp[11:23, 4:6]
      C4_base[24:31, 6] <- C4_comp[25:32, 6]
      
      ## Formules
      C4_base[8, 6] <- sum(as.numeric(C4_base[3:7, 6]))
      
      C4_base[23, 4] <- sum(as.numeric(C4_base[10:22, 4]))
      C4_base[23, 5] <- sum(as.numeric(C4_base[10:22, 5]))
      C4_base[23, 6] <- sum(as.numeric(C4_base[10:22, 6]))
      
      C4_base[32, 6] <- sum(as.numeric(C4_base[24:31, 6]))
      
      C4_base[33, 6] <- sum(as.numeric(C4_base[c(23, 32), 6]))
      
      # Sauvegarde ----
      saveRDS(C4_base, paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Message de fin ----
      cat(" - Action :", action, "\n",
          "- Année :", ann, "\n",
          "- Branche :", brch, "\n", 
          "- Ajout de l'état :", ett, "\n", 
          "- Compagnie :", comp, "\n", 
          "- Statut : Terminé")
    }
    
    # Création de l'état C5 (trop grande différence entre les états à faire manuellement)
    else if (ett == "C5") {}
    
    # Création de l'état C11
    else if (ett == "C11") {
      # Chargement du fichier de base pour la compilation ----
      ## appelle et execution de la fonction de création de données
      source("5 - Scripts/Fonction_Fanaf_bases.R")
      comp_Fanaf_bases(branche = brch, annee = ann, etat = ett)
      ## Creation de l'etat de compilation
      C11_base <- read_rds(paste0("5 - Scripts/Fanaf_",ett,"_N.Vie.RDS"))
      
      # Chargement du dossier ----
      C11_comp <- openxlsx::read.xlsx(chem_e, sheet = 1)
      ## Remplacement des 'NA' par 0
      for (i in 1:nrow(C11_comp)) {
        for (j in 1:ncol(C11_comp)) {
          if (is.na(C11_comp[i, j]) == TRUE) {C11_comp[i, j] <- 0}
        }
      }
      rm(i, j)
      
      # Compilation ----
      ## Engagements
      C11_base[c(5:12, 14:16, 22:24, 29), 3:5] <- 
        C11_comp[c(5:12, 14:16, 22:24, 29), 3:5]
      
      ## Formules
      C11_base[13, 3] <- sum(as.numeric(C11_base[5:12, 3]))
      C11_base[13, 4] <- sum(as.numeric(C11_base[5:12, 4]))
      C11_base[13, 5] <- sum(as.numeric(C11_base[5:12, 5]))
      
      C11_base[17, 3] <- sum(as.numeric(C11_base[14:16, 3]))
      C11_base[17, 4] <- sum(as.numeric(C11_base[14:16, 4]))
      C11_base[17, 5] <- sum(as.numeric(C11_base[14:16, 5]))
      
      C11_base[18, 3] <- as.numeric(C11_base[13, 3]) - as.numeric(C11_base[17, 3])
      C11_base[18, 4] <- as.numeric(C11_base[13, 4]) - as.numeric(C11_base[17, 4])
      C11_base[18, 5] <- as.numeric(C11_base[13, 5]) - as.numeric(C11_base[17, 5])
      
      C11_base[25, 3] <- max(as.numeric(C11_base[23, 3]) / as.numeric(C11_base[24, 3]), 0.5) 
      C11_base[25, 4] <- max(as.numeric(C11_base[23, 4]) / as.numeric(C11_base[24, 4]), 0.5) 
      C11_base[25, 5] <- max(as.numeric(C11_base[23, 5]) / as.numeric(C11_base[24, 5]), 0.5)
      
      C11_base[26, 3] <- as.numeric(C11_base[22, 3]) * 0.2 
      C11_base[26, 4] <- as.numeric(C11_base[22, 4]) * 0.2 
      C11_base[26, 5] <- as.numeric(C11_base[22, 5]) * 0.2
      
      C11_base[27, 3] <- as.numeric(C11_base[26, 3]) * as.numeric(C11_base[25, 3])
      C11_base[27, 4] <- as.numeric(C11_base[26, 4]) * as.numeric(C11_base[25, 4])
      C11_base[27, 5] <- as.numeric(C11_base[26, 5]) * as.numeric(C11_base[25, 5])
      
      C11_base[30, 3] <- as.numeric(C11_base[29, 3]) / 3
      C11_base[30, 4] <- as.numeric(C11_base[29, 4]) / 3
      C11_base[30, 5] <- as.numeric(C11_base[29, 5]) / 3
      
      C11_base[31, 3] <- C11_base[25, 3]
      C11_base[31, 4] <- C11_base[25, 4]
      C11_base[31, 5] <- C11_base[25, 5]
      
      C11_base[32, 3] <- as.numeric(C11_base[30, 3]) * 0.25 
      C11_base[32, 4] <- as.numeric(C11_base[30, 4]) * 0.25
      C11_base[32, 5] <- as.numeric(C11_base[30, 5]) * 0.25
      
      C11_base[33, 3] <- as.numeric(C11_base[31, 3]) * as.numeric(C11_base[32, 3]) 
      C11_base[33, 4] <- as.numeric(C11_base[31, 4]) * as.numeric(C11_base[32, 4])
      C11_base[33, 5] <- as.numeric(C11_base[31, 5]) * as.numeric(C11_base[32, 5])
      
      C11_base[34, 3] <- max(as.numeric(C11_base[27, 3]), as.numeric(C11_base[33, 3]))  
      C11_base[34, 4] <- max(as.numeric(C11_base[27, 4]), as.numeric(C11_base[33, 4])) 
      C11_base[34, 5] <- max(as.numeric(C11_base[27, 5]), as.numeric(C11_base[33, 5])) 
      
      C11_base[37, 3] <- ifelse(
        (as.numeric(C11_base[18, 3]) - as.numeric(C11_base[34, 3])) > 0,
        as.numeric(C11_base[18, 3]) - as.numeric(C11_base[34, 3]),
        0
      )
      C11_base[37, 4] <- ifelse(
        (as.numeric(C11_base[18, 4]) - as.numeric(C11_base[34, 4])) > 0,
        as.numeric(C11_base[18, 4]) - as.numeric(C11_base[34, 4]),
        0
      )
      C11_base[37, 5] <- ifelse(
        (as.numeric(C11_base[18, 5]) - as.numeric(C11_base[34, 5])) > 0,
        as.numeric(C11_base[18, 5]) - as.numeric(C11_base[34, 5]),
        0
      )
      
      C11_base[38, 3] <- ifelse(
        (as.numeric(C11_base[34, 3]) - as.numeric(C11_base[18, 3])) > 0,
        as.numeric(C11_base[34, 3]) - as.numeric(C11_base[18, 3]),
        0
      )
      C11_base[38, 4] <- ifelse(
        (as.numeric(C11_base[34, 4]) - as.numeric(C11_base[18, 4])) > 0,
        as.numeric(C11_base[34, 4]) - as.numeric(C11_base[18, 4]),
        0
      )
      C11_base[38, 5] <- ifelse(
        (as.numeric(C11_base[34, 5]) - as.numeric(C11_base[18, 5])) > 0,
        as.numeric(C11_base[34, 5]) - as.numeric(C11_base[18, 5]),
        0
      )
      
      # Sauvegarde ----
      saveRDS(C11_base, paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Message de fin ----
      cat(" - Action :", action, "\n",
          "- Année :", ann, "\n",
          "- Branche :", brch, "\n", 
          "- Ajout de l'état :", ett, "\n", 
          "- Compagnie :", comp, "\n", 
          "- Statut : Terminé")
    }
    
    # Message d'erreur
    else {cat("Veuillez choisir un etat répertorié dans la liste :", "\n", 
              "'Bilan', 'CEG', 'C1', 'C4', 'C5', 'C11'")}
  }
  
  # Création d'un état en VIE
  else if ( brch == "VIE") {
    # Création du Bilan
    if (ett == "Bilan") {}
    
    # Création de l'état CEG
    else if (ett == "CEG") {}
    
    # Création de l'état C1
    else if (ett == "C1") {}
    
    # Création de l'état C4
    else if (ett == "C4") {}
    
    # Création de l'état C5
    else if (ett == "C5") {}
    
    # Création de l'état C11
    else if (ett == "C11") {}
    
    # Message d'erreur
    else {cat("Veuillez choisir un etat répertorié dans la liste :", "\n", 
              "'Bilan', 'CEG', 'C1', 'C4', 'C5', 'C11'")}
  }
  
  #Message d'erreur
  else {cat("Veuillez choisir une branche répertoriée dans la liste :\n 'IARD', 'VIE'")}
  
}

# Ajout d'une compagnie supplémentaire pour un état donné
else if (action == "ajouter") {
  # Ajout d'un état en IARD
  if (brch == "IARD") {
    # Ajout d'un nouvel état bilan
    if (ett == "Bilan") {
      # Chargement du fichier de base pour la compilation ----
      Bilan_base <- read_rds(paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
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
      
      ## Passif
      Bilan_base[c(56:62, 64:71, 73:74, 75, 77, 79, 81:82, 85:87, 90:102, 104), c(3:4)] <- 
        Bilan_comp[c(57:63, 65:72, 74:75, 76, 78, 80, 82:83, 86:88, 91:103, 105), c(4:5)]
      
      Bilan_base[c(56:62, 64:71, 73:74, 75, 77, 79, 81:82, 85:87, 90:102, 104), 3] <- 
        as.numeric(Bilan_base[c(56:62, 64:71, 73:74, 75, 77, 79, 81:82, 85:87, 90:102, 104), 3]) +
        as.numeric(Bilan_comp[c(57:63, 65:72, 74:75, 76, 78, 80, 82:83, 86:88, 91:103, 105), 4])
      
      Bilan_base[c(56, 59, 62, 64:71, 73:74, 75, 77, 79, 81:82, 90:102, 104), 4] <- 
        as.numeric(Bilan_base[c(56, 59, 62, 64:71, 73:74, 75, 77, 79, 81:82, 90:102, 104), 4]) +
        as.numeric(Bilan_comp[c(57, 60, 63, 65:72, 74:75, 76, 78, 80, 82:83, 91:103, 105), 5])
      
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
      saveRDS(Bilan_base, paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Message de fin ----
      cat(" - Action :", action, "\n",
          "- Année :", ann, "\n",
          "- Branche :", brch, "\n", 
          "- Ajout de l'état :", ett, "\n", 
          "- Compagnie :", comp, "\n", 
          "- Statut : Terminé")
    }
    
    # Ajout d'un nouvel état CEG
    else if (ett == "CEG") {
      # Chargement du fichier de base pour la compilation ----
      CEG_base <- read_rds(paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Chargement du dossier ----
      CEG_comp <- openxlsx::read.xlsx(chem_e, sheet = 1)
      ## Remplacement des 'NA' par 0
      for (i in 1:nrow(CEG_comp)) {
        for (j in 1:ncol(CEG_comp)) {
          if (is.na(CEG_comp[i, j]) == TRUE) {CEG_comp[i, j] <- 0}
        }
      }
      rm(i, j)
      
      # Compilation ----
      ## Debit
      CEG_base[c(6:8, 10), c(3:5)] <- 
        as.numeric(CEG_base[c(6:8, 10), c(3:5)]) +
        as.numeric(CEG_comp[c(6:8, 10), c(3:5)])
      
      CEG_base[c(12:17, 21:24), 3] <- 
        as.numeric(CEG_base[c(12:17, 21:24), 3]) +
        as.numeric(CEG_comp[c(12:17, 21:24), 3])
      
      ## Credit
      CEG_base[34:36, 3:5] <- 
        as.numeric(CEG_base[34:36, 3:5]) + 
        as.numeric(CEG_comp[34:36, 3:5])
      
      CEG_base[c(39:41, 44, 45), 3] <- 
        as.numeric(CEG_base[c(39:41, 44, 45), 3]) + 
        as.numeric(CEG_comp[c(39:41, 44, 45), 3]) 
      
      CEG_base[48, 5] <- as.numeric(CEG_base[48, 5]) + as.numeric(CEG_comp[48, 5])
      
      ## Formules
      CEG_base[9, 3] <- sum(as.numeric(CEG_base[6:7, 3])) - as.numeric(CEG_base[8, 3]) 
      CEG_base[9, 4] <- sum(as.numeric(CEG_base[6:7, 4])) - as.numeric(CEG_base[8, 4]) 
      CEG_base[9, 5] <- as.numeric(CEG_base[9, 3]) - as.numeric(CEG_base[9, 4]) 
      
      CEG_base[18, 3] <- sum(as.numeric(CEG_base[12:17, 3]))
      
      CEG_base[19, 3] <- sum(as.numeric(CEG_base[c(10, 18), 3]))
      CEG_base[19, 4] <- CEG_base[10, 4]
      CEG_base[19, 5] <- as.numeric(CEG_base[19, 3]) - as.numeric(CEG_base[19, 4])
      
      CEG_base[25, 5] <- sum(as.numeric(CEG_base[21:24, 3]))
      
      CEG_base[37, 3] <- sum(as.numeric(CEG_base[34:35, 3])) - as.numeric(CEG_base[36, 3])
      CEG_base[37, 4] <- sum(as.numeric(CEG_base[34:35, 4])) - as.numeric(CEG_base[36, 4])
      CEG_base[37, 5] <- as.numeric(CEG_base[37, 3]) - as.numeric(CEG_base[37, 4])
      
      CEG_base[42, 5] <- sum(as.numeric(CEG_base[39:41, 3]))
      
      CEG_base[46, 5] <- sum(as.numeric(CEG_base[44:45, 3]))
      
      CEG_base[26, 5] <- ifelse(
        sum(as.numeric(CEG_base[c(9, 19, 25), 5])) < sum(as.numeric(CEG_base[c(37, 42, 46, 48), 5])),
        sum(as.numeric(CEG_base[c(37, 42, 46, 48), 5])) - sum(as.numeric(CEG_base[c(9, 19, 25), 5])),
        0
      )
      
      CEG_base[49, 5] <- ifelse(
        sum(as.numeric(CEG_base[c(9, 19, 25), 5])) > sum(as.numeric(CEG_base[c(37, 42, 46, 48), 5])),
        sum(as.numeric(CEG_base[c(9, 19, 25), 5])) - sum(as.numeric(CEG_base[c(37, 42, 46, 48), 5])),
        0
      )
      
      CEG_base[27, 5] <- sum(as.numeric(CEG_base[c(9, 19, 25:26), 5]))
      CEG_base[50, 5] <- sum(as.numeric(CEG_base[c(37, 42, 46, 48:49), 5]))
      
      # Sauvegarde ----
      saveRDS(CEG_base, paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Message de fin ----
      cat(" - Action :", action, "\n",
          "- Année :", ann, "\n",
          "- Branche :", brch, "\n", 
          "- Ajout de l'état :", ett, "\n", 
          "- Compagnie :", comp, "\n", 
          "- Statut : Terminé")
    }
    
    # Ajout d'un nouvel état C1
    else if (ett == "C1") {
      # Chargement du fichier de base pour la compilation ----
      C1_base <- read_rds(paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
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
      C1_base[c(4:8, 11:12, 14:15, 17:18, 20:21, 23:25, 27:28), c(2:11)] <- 
        C1_base[c(4:8, 11:12, 14:15, 17:18, 20:21, 23:25, 27:28), c(2:11)] + 
        C1_comp[c(6:10, 13:14, 16:17, 19:20, 22:23, 25:27, 29:30), c(2:11)]
      
      ## Credit
      C1_base[c(35:37, 40:41, 43:44, 46:47, 49:51, 53:55), c(2:11)] <- 
        C1_base[c(35:37, 40:41, 43:44, 46:47, 49:51, 53:55), c(2:11)] + 
        C1_comp[c(40:42, 45:46, 48:49, 51:52, 54:56, 58:60), c(2:11)]
      
      ## Formules
      C1_base[9, 2:11] <- as.numeric(C1_base[4, 2:11]) + 
        as.numeric(C1_base[5, 2:11]) + as.numeric(C1_base[6, 2:11]) - 
        as.numeric(C1_base[7, 2:11]) - as.numeric(C1_base[8, 2:11])
      
      C1_base[22, 2:11] <- 
        (-1 * as.numeric(C1_base[11, 2:11])) + as.numeric(C1_base[12, 2:11]) - 
        as.numeric(C1_base[14, 2:11]) + as.numeric(C1_base[15, 2:11]) + 
        as.numeric(C1_base[17, 2:11]) - as.numeric(C1_base[18, 2:11]) - 
        as.numeric(C1_base[20, 2:11]) + as.numeric(C1_base[21, 2:11])
      
      C1_base[29, 2:11] <- as.numeric(C1_base[25, 2:11]) + 
        as.numeric(C1_base[27, 2:11]) - as.numeric(C1_base[28, 2:11])
      
      C1_base[38, 2:11] <- as.numeric(C1_base[35, 2:11]) + 
        as.numeric(C1_base[36, 2:11]) - as.numeric(C1_base[37, 2:11])
      
      C1_base[48, 2:11] <- 
        as.numeric(C1_base[40, 2:11]) - as.numeric(C1_base[41, 2:11]) + 
        as.numeric(C1_base[43, 2:11]) - as.numeric(C1_base[44, 2:11]) + 
        as.numeric(C1_base[46, 2:11]) - as.numeric(C1_base[47, 2:11])
      
      C1_base[56, 2:11] <- 
        as.numeric(C1_base[51, 2:11]) - as.numeric(C1_base[53, 2:11]) + 
        as.numeric(C1_base[54, 2:11]) + as.numeric(C1_base[55, 2:11])
      
      for (i in 2:11) {
        C1_base[30, i] <- 
          ifelse(
            sum(as.numeric(C1_base[c(9, 22:24, 29), i])) < 
              sum(as.numeric(C1_base[c(38, 48:50, 56), i])), 
            
            sum(as.numeric(C1_base[c(38, 48:50, 56), i])) - 
              sum(as.numeric(C1_base[c(9, 22:24, 29), i])), 
            
            0)
      }
      
      for (i in 2:11) {
        C1_base[57, i] <- 
          ifelse(
            sum(as.numeric(C1_base[c(38, 48:50, 56), i])) < 
              sum(as.numeric(C1_base[c(9, 22:24, 29), i])), 
            
            sum(as.numeric(C1_base[c(9, 22:24, 29), i])) - 
              sum(as.numeric(C1_base[c(38, 48:50, 56), i])),
            
            0)
      }
      
      for (i in 2:11) {
        C1_base[31, i] <- sum(as.numeric(C1_base[c(9, 22:24, 29:30), i])) 
      }
      
      for (i in 2:11) {
        C1_base[58, i] <- sum(as.numeric(C1_base[c(38, 48:50, 56:57), i])) 
      }
      
      for (i in c(4:9, 11:12, 14:15, 17:18, 20:25, 27:29, 31, 35:38, 40:41, 43:44, 46:51, 53:56, 58)) {
        C1_base[i, 12] <- sum(as.numeric(C1_base[i, 2:11]))
      }
      rm(i)
      
      C1_base[30, 12] <- ifelse(
        sum(as.numeric(C1_base[c(9, 22:24, 29), 12])) < 
          sum(as.numeric(C1_base[c(38, 48:50, 56), 12])), 
        
        sum(as.numeric(C1_base[c(38, 48:50, 56), 12])) - 
          sum(as.numeric(C1_base[c(9, 22:24, 29), 12])), 
        
        0)
      
      C1_base[57, 12] <- ifelse(
        sum(as.numeric(C1_base[c(38, 48:50, 56), 12])) < 
          sum(as.numeric(C1_base[c(9, 22:24, 29), 12])), 
        
        sum(as.numeric(C1_base[c(9, 22:24, 29), 12])) - 
          sum(as.numeric(C1_base[c(38, 48:50, 56), 12])),
        
        0)
      
      # Sauvegarde ----
      saveRDS(C1_base, paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Message de fin ----
      cat(" - Action :", action, "\n",
          "- Année :", ann, "\n",
          "- Branche :", brch, "\n", 
          "- Ajout de l'état :", ett, "\n", 
          "- Compagnie :", comp, "\n", 
          "- Statut : Terminé")
    }
    
    # Ajout d'un nouvel état C4
    else if (ett == "C4") {
      # Chargement du fichier de base pour la compilation ----
      C4_base <- read_rds(paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Chargement du dossier ----
      C4_comp <- openxlsx::read.xlsx(chem_e, sheet = 1)
      ## Remplacement des 'NA' par 0
      for (i in 1:nrow(C4_comp)) {
        for (j in 1:ncol(C4_comp)) {
          if (is.na(C4_comp[i, j]) == TRUE) {C4_comp[i, j] <- 0}
        }
      }
      rm(i, j)
      
      # Compilation ----
      ## Engagements
      C4_base[3:7, 6] <- C4_base[3:7, 6] + C4_comp[4:8, 6]
      
      ## Actifs
      C4_base[10:22, 4:6] <- C4_base[10:22, 4:6] + C4_comp[11:23, 4:6]
      C4_base[24:31, 6] <- C4_base[24:31, 6] + C4_comp[25:32, 6]
      
      ## Formules
      C4_base[8, 6] <- sum(as.numeric(C4_base[3:7, 6]))
      
      C4_base[23, 4] <- sum(as.numeric(C4_base[10:22, 4]))
      C4_base[23, 5] <- sum(as.numeric(C4_base[10:22, 5]))
      C4_base[23, 6] <- sum(as.numeric(C4_base[10:22, 6]))
      
      C4_base[32, 6] <- sum(as.numeric(C4_base[24:31, 6]))
      
      C4_base[33, 6] <- sum(as.numeric(C4_base[c(23, 32), 6]))
      
      # Sauvegarde ----
      saveRDS(C4_base, paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Message de fin ----
      cat(" - Action :", action, "\n",
          "- Année :", ann, "\n",
          "- Branche :", brch, "\n", 
          "- Ajout de l'état :", ett, "\n", 
          "- Compagnie :", comp, "\n", 
          "- Statut : Terminé")
    }
    
    # Ajout d'un nouvel état C5 (trop grande différence entre les états à faire manuellement)
    else if (ett == "C5") {} 
    
    # Ajout d'un nouvel état C11
    else if (ett == "C11") {
      # Chargement du fichier de base pour la compilation ----
      C11_base <- read_rds(paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Chargement du dossier ----
      C11_comp <- openxlsx::read.xlsx(chem_e, sheet = 1)
      ## Remplacement des 'NA' par 0
      for (i in 1:nrow(C11_comp)) {
        for (j in 1:ncol(C11_comp)) {
          if (is.na(C11_comp[i, j]) == TRUE) {C11_comp[i, j] <- 0}
        }
      }
      rm(i, j)
      
      # Compilation ----
      ## Engagements
      C11_base[c(5:12, 14:16, 22:24, 29), 3:5] <- 
        C11_base[c(5:12, 14:16, 22:24, 29), 3:5] + 
        C11_comp[c(5:12, 14:16, 22:24, 29), 3:5]
      
      ## Formules
      C11_base[13, 3] <- sum(as.numeric(C11_base[5:12, 3]))
      C11_base[13, 4] <- sum(as.numeric(C11_base[5:12, 4]))
      C11_base[13, 5] <- sum(as.numeric(C11_base[5:12, 5]))
      
      C11_base[17, 3] <- sum(as.numeric(C11_base[14:16, 3]))
      C11_base[17, 4] <- sum(as.numeric(C11_base[14:16, 4]))
      C11_base[17, 5] <- sum(as.numeric(C11_base[14:16, 5]))
      
      C11_base[18, 3] <- as.numeric(C11_base[13, 3]) - as.numeric(C11_base[17, 3])
      C11_base[18, 4] <- as.numeric(C11_base[13, 4]) - as.numeric(C11_base[17, 4])
      C11_base[18, 5] <- as.numeric(C11_base[13, 5]) - as.numeric(C11_base[17, 5])
      
      C11_base[25, 3] <- max(as.numeric(C11_base[23, 3]) / as.numeric(C11_base[24, 3]), 0.5) 
      C11_base[25, 4] <- max(as.numeric(C11_base[23, 4]) / as.numeric(C11_base[24, 4]), 0.5) 
      C11_base[25, 5] <- max(as.numeric(C11_base[23, 5]) / as.numeric(C11_base[24, 5]), 0.5)
      
      C11_base[26, 3] <- as.numeric(C11_base[22, 3]) * 0.2 
      C11_base[26, 4] <- as.numeric(C11_base[22, 4]) * 0.2 
      C11_base[26, 5] <- as.numeric(C11_base[22, 5]) * 0.2
      
      C11_base[27, 3] <- as.numeric(C11_base[26, 3]) * as.numeric(C11_base[25, 3])
      C11_base[27, 4] <- as.numeric(C11_base[26, 4]) * as.numeric(C11_base[25, 4])
      C11_base[27, 5] <- as.numeric(C11_base[26, 5]) * as.numeric(C11_base[25, 5])
      
      C11_base[30, 3] <- as.numeric(C11_base[29, 3]) / 3
      C11_base[30, 4] <- as.numeric(C11_base[29, 4]) / 3
      C11_base[30, 5] <- as.numeric(C11_base[29, 5]) / 3
      
      C11_base[31, 3] <- C11_base[25, 3]
      C11_base[31, 4] <- C11_base[25, 4]
      C11_base[31, 5] <- C11_base[25, 5]
      
      C11_base[32, 3] <- as.numeric(C11_base[30, 3]) * 0.25 
      C11_base[32, 4] <- as.numeric(C11_base[30, 4]) * 0.25
      C11_base[32, 5] <- as.numeric(C11_base[30, 5]) * 0.25
      
      C11_base[33, 3] <- as.numeric(C11_base[31, 3]) * as.numeric(C11_base[32, 3]) 
      C11_base[33, 4] <- as.numeric(C11_base[31, 4]) * as.numeric(C11_base[32, 4])
      C11_base[33, 5] <- as.numeric(C11_base[31, 5]) * as.numeric(C11_base[32, 5])
      
      C11_base[34, 3] <- max(as.numeric(C11_base[27, 3]), as.numeric(C11_base[33, 3]))  
      C11_base[34, 4] <- max(as.numeric(C11_base[27, 4]), as.numeric(C11_base[33, 4])) 
      C11_base[34, 5] <- max(as.numeric(C11_base[27, 5]), as.numeric(C11_base[33, 5])) 
      
      C11_base[37, 3] <- ifelse(
        (as.numeric(C11_base[18, 3]) - as.numeric(C11_base[34, 3])) > 0,
        as.numeric(C11_base[18, 3]) - as.numeric(C11_base[34, 3]),
        0
      )
      C11_base[37, 4] <- ifelse(
        (as.numeric(C11_base[18, 4]) - as.numeric(C11_base[34, 4])) > 0,
        as.numeric(C11_base[18, 4]) - as.numeric(C11_base[34, 4]),
        0
      )
      C11_base[37, 5] <- ifelse(
        (as.numeric(C11_base[18, 5]) - as.numeric(C11_base[34, 5])) > 0,
        as.numeric(C11_base[18, 5]) - as.numeric(C11_base[34, 5]),
        0
      )
      
      C11_base[38, 3] <- ifelse(
        (as.numeric(C11_base[34, 3]) - as.numeric(C11_base[18, 3])) > 0,
        as.numeric(C11_base[34, 3]) - as.numeric(C11_base[18, 3]),
        0
      )
      C11_base[38, 4] <- ifelse(
        (as.numeric(C11_base[34, 4]) - as.numeric(C11_base[18, 4])) > 0,
        as.numeric(C11_base[34, 4]) - as.numeric(C11_base[18, 4]),
        0
      )
      C11_base[38, 5] <- ifelse(
        (as.numeric(C11_base[34, 5]) - as.numeric(C11_base[18, 5])) > 0,
        as.numeric(C11_base[34, 5]) - as.numeric(C11_base[18, 5]),
        0
      )
      
      # Sauvegarde ----
      saveRDS(C11_base, paste0("5 - Scripts/", "Fanaf_", ett, "_N.Vie_", ann, ".RDS"))
      
      # Message de fin ----
      cat(" - Action :", action, "\n",
          "- Année :", ann, "\n",
          "- Branche :", brch, "\n", 
          "- Ajout de l'état :", ett, "\n", 
          "- Compagnie :", comp, "\n", 
          "- Statut : Terminé")
    }
    
    # Message d'erreur
    else {cat("Veuillez choisir un etat répertorié dans la liste :", "\n", 
              "'Bilan', 'CEG', 'C1', 'C4', 'C5', 'C11'")}
  }
  
  # Ajout d'un état en VIE
  else if ( brch == "VIE") {
    # Ajout du bilan
    if (ett == "Bilan") {}
    
    # Ajout du CEG
    else if (ett == "CEG") {}
    
    # Ajout du C1
    else if (ett == "C1") {}
    
    # Ajout du C4
    else if (ett == "C4") {}
    
    # Ajout du C5
    else if (ett == "C5") {}
    
    # Ajout du C11
    else if (ett == "C11") {}
    
    # Message d'erreur
    else {cat("Veuillez choisir un etat répertorié dans la liste :", "\n", 
              "'Bilan', 'CEG', 'C1', 'C4', 'C5', 'C11'")}
  }
  
  #Message d'erreur
  else {cat("Veuillez choisir une branche répertoriée dans la liste :\n 'IARD', 'VIE'")}
}

# Message d'erreur
else{cat("Veuillez choisir une action répertoriée dans la liste :\n 'creer', 'ajouter'")}
