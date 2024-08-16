comp_Fanaf_bases <- function(branche, annee, etat) {
  # Initialisation ----
  setwd("C:/Users/Ismail SARE/OneDrive - ASSOCIATION DES SOCIETES D'ASSURANCES/Chiffres/Donnees")
  
  # Packages ----
  require(tidyverse) # Traitement de données
  require(openxlsx) # chargement docs excel
  # Conditions ----
  if (branche == "VIE") {
    # Chargement des états de base pour la compilation ----
    if (etat == "Bilan") {
      ## Bilan Vie 
      base_Bil_Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "BILAN VIE")
      ### On indique l'annee concernée
      (c <- colnames(base_Bil_Vie))
      c[which(c == "2023")] <- annee
      colnames(base_Bil_Vie) <- c
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_Bil_Vie)) {
        for (j in 1:ncol(base_Bil_Vie)) {
          if (is.na(base_Bil_Vie[i,j] == TRUE)) {base_Bil_Vie[i,j] <- 0}
        }
      }
      rm(c,i,j)
      ### Sauvegarde
      saveRDS(base_Bil_Vie, "5 - Scripts/Fanaf_Bilan_Vie.RDS")
    }
    
    else if (etat == "CEG") {
      ## CEG VIE
      base_CEG_Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "CEG VIE")
      ### On indique l'annee concernée
      base_CEG_Vie[1, ncol(base_CEG_Vie)] <- annee
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_CEG_Vie)) {
        for (j in 1:ncol(base_CEG_Vie)) {
          if (is.na(base_CEG_Vie[i,j] == TRUE)) {base_CEG_Vie[i,j] <- 0}
        }
      }
      rm(i,j)
      ### Sauvegarde
      saveRDS(base_CEG_Vie, "5 - Scripts/Fanaf_CEG_Vie.RDS")
    }
    
    else if (etat == "C1") {
      ## C1 VIE
      base_C1_Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "C1 VIE")
      ### On indique l'annee concernée
      (c <- colnames(base_C1_Vie)) 
      c[which(c == "2023")] <- annee
      colnames(base_C1_Vie) <- c
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_C1_Vie)) {
        for (j in 1:ncol(base_C1_Vie)) {
          if (is.na(base_C1_Vie[i,j] == TRUE)) {base_C1_Vie[i,j] <- 0}
        }
      }
      rm(c,i,j)
      ### Sauvegarde
      saveRDS(base_C1_Vie, "5 - Scripts/Fanaf_C1_Vie.RDS")
    }
    
    else if (etat == "C4") {
      ## C4 VIE
      base_C4_Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "C4 VIE")
      ### On indique l'annee concernée
      (c <- colnames(base_C4_Vie)) 
      c[which(c == "2023")] <- annee
      colnames(base_C4_Vie) <- c
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_C4_Vie)) {
        for (j in 1:ncol(base_C4_Vie)) {
          if (is.na(base_C4_Vie[i,j] == TRUE)) {base_C4_Vie[i,j] <- 0}
        }
      }
      rm(c,i,j)
      ### Sauvegarde
      saveRDS(base_C4_Vie, "5 - Scripts/Fanaf_C4_Vie.RDS")
    }
    
    else if (etat == "C5") {
      ## C5 VIE
      base_C5_Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "C5 VIE SYNTH")
      ### On indique l'annee concernée
      (c <- colnames(base_C5_Vie)) 
      c[which(c == "2023")] <- annee
      colnames(base_C5_Vie) <- c
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_C5_Vie)) {
        for (j in 1:ncol(base_C5_Vie)) {
          if (is.na(base_C5_Vie[i,j] == TRUE)) {base_C5_Vie[i,j] <- 0}
        }
      }
      rm(c,i,j)
      ### Sauvegarde
      saveRDS(base_C5_Vie, "5 - Scripts/Fanaf_C5_Vie.RDS")
    }
    
    else if (etat == "C11") {
      ## C11 VIE
      base_C11_Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "C11 VIE")
      ### On indique l'annee concernée
      base_C11_Vie[4, c(3,4,5)] <- c(annee - 2, annee - 1, annee)
      base_C11_Vie[20, c(3,4,5)] <- c(annee - 2, annee - 1, annee)
      base_C11_Vie[28, c(3,4,5)] <- c(annee - 2, annee - 1, annee)
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_C11_Vie)) {
        for (j in 1:ncol(base_C11_Vie)) {
          if (is.na(base_C11_Vie[i,j] == TRUE)) {base_C11_Vie[i,j] <- 0}
        }
      }
      rm(i,j)
      ### Sauvegarde
      saveRDS(base_C11_Vie, "5 - Scripts/Fanaf_C11_Vie.RDS")
    }
    
    else {print(cat("Veuillez choisir un etat répertorié dans la liste :\n 'Bilan', 'CEG', 'C1', 'C4', 'C5', 'C11'"))}
  }
  
  else if (branche == "IARD") {
    # Chargement des états de base pour la compilation ----
    if (etat == "Bilan") {
      ## BILAN NON VIE
      base_Bil_N.Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "BILAN NON VIE")
      ### On indique l'annee concernée
      (c <- colnames(base_Bil_N.Vie)) 
      c[which(c == "2023")] <- annee
      colnames(base_Bil_N.Vie) <- c
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_Bil_N.Vie)) {
        for (j in 1:ncol(base_Bil_N.Vie)) {
          if (is.na(base_Bil_N.Vie[i,j] == TRUE)) {base_Bil_N.Vie[i,j] <- 0}
        }
      }
      rm(c,i,j)
      ### Sauvegarde
      saveRDS(base_Bil_N.Vie, "5 - Scripts/Fanaf_Bilan_N.Vie.RDS")
    }
    
    else if (etat == "CEG") {
      ## CEG NON VIE
      base_CEG_N.Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "CEG NON VIE")
      ### On indique l'annee concernée
      base_CEG_N.Vie[1, ncol(base_CEG_N.Vie)] <- annee
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_CEG_N.Vie)) {
        for (j in 1:ncol(base_CEG_N.Vie)) {
          if (is.na(base_CEG_N.Vie[i,j] == TRUE)) {base_CEG_N.Vie[i,j] <- 0}
        }
      }
      rm(i,j)
      ### Sauvegarde
      saveRDS(base_CEG_N.Vie, "5 - Scripts/Fanaf_CEG_N.Vie.RDS")
    }
    
    else if (etat == "C1") {
      ## C1 NON VIE
      base_C1_N.Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "C1 NON VIE")
      ### On indique l'annee concernée
      (c <- colnames(base_C1_N.Vie)) 
      c[which(c == "2023")] <- annee
      colnames(base_C1_N.Vie) <- c
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_C1_N.Vie)) {
        for (j in 1:ncol(base_C1_N.Vie)) {
          if (is.na(base_C1_N.Vie[i,j] == TRUE)) {base_C1_N.Vie[i,j] <- 0}
        }
      }
      rm(c,i,j)
      ### Sauvegarde
      saveRDS(base_C1_N.Vie, "5 - Scripts/Fanaf_C1_N.Vie.RDS")
    }
    
    else if (etat == "C4") {
      ## C4 NON VIE
      base_C4_N.Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "C4 NON VIE")
      ### On indique l'annee concernée
      (c <- colnames(base_C4_N.Vie)) 
      c[which(c == "2023")] <- annee
      colnames(base_C4_N.Vie) <- c
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_C4_N.Vie)) {
        for (j in 1:ncol(base_C4_N.Vie)) {
          if (is.na(base_C4_N.Vie[i,j] == TRUE)) {base_C4_N.Vie[i,j] <- 0}
        }
      }
      rm(c,i,j)
      ### Sauvegarde
      saveRDS(base_C4_N.Vie, "5 - Scripts/Fanaf_C4_N.Vie.RDS")
    }
    
    else if (etat == "C5") {
      ## C5 NON VIE
      base_C5_N.Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "C5 NON VIE SYNTH")
      ### On indique l'annee concernée
      (c <- colnames(base_C5_N.Vie)) 
      c[which(c == "2023")] <- annee
      colnames(base_C5_N.Vie) <- c
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_C5_N.Vie)) {
        for (j in 1:ncol(base_C5_N.Vie)) {
          if (is.na(base_C5_N.Vie[i,j] == TRUE)) {base_C5_N.Vie[i,j] <- 0}
        }
      }
      rm(c,i,j)
      ### Sauvegarde
      saveRDS(base_C5_N.Vie, "5 - Scripts/Fanaf_C5_N.Vie.RDS")
    }
    
    else if (etat == "C11") {
      ## C11 NON VIE
      base_C11_N.Vie <- openxlsx::read.xlsx("3 - FANAF/Modele FANAF.xlsx", sheet = "C11 NON VIE")
      ### On indique l'annee concernée
      base_C11_N.Vie[1, ncol(base_C11_N.Vie)] <- annee
      base_C11_N.Vie[4, c(3, 4, 5)] <- c(annee - 2, annee - 1, annee)
      base_C11_N.Vie[20, c(3, 4, 5)] <- c(annee - 2, annee - 1, annee)
      base_C11_N.Vie[36, c(3, 4, 5)] <- c(annee - 2, annee - 1, annee)
      ### Remplacement des 'NA' par 0
      for (i in 1:nrow(base_C11_N.Vie)) {
        for (j in 1:ncol(base_C11_N.Vie)) {
          if (is.na(base_C11_N.Vie[i,j] == TRUE)) {base_C11_N.Vie[i,j] <- 0}
        }
      }
      rm(i,j)
      ### Sauvegarde
      saveRDS(base_C11_N.Vie, "5 - Scripts/Fanaf_C11_N.Vie.RDS")
    }
    
    else {print(cat("Veuillez choisir un etat répertorié dans la liste :\n 'Bilan', 'CEG', 'C1', 'C4', 'C5', 'C11'"))}
  }
  
  else{print(cat("Veuillez choisir une branche répertoriée dans la liste :\n 'IARD', 'VIE'"))}
}