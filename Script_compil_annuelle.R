# ---- Présentation ------------------------------------------------------------

# Arguments de la fonction :
# * action 
#   - 'supprimer' pour effacer les données compilées
#   - 'creer' pour créer un nouveau classeur avec la première ligne à charger
#   - 'ajouter' pour ajouter une nouvelle ligne au classeur ou modifier uen ligne déjà créée
#   
# * branche 
#   - 'VIE' 
#   - 'IARD'
#   - 'TOUT' uniquement valable lors de la suppression
#   
# * ann : l'année de compilation
# 
# * comp : la compagnie pour qui on veut compiler les données
#   - liste IARD : 2ACI, ACTIVA, ALLIANZ, AMSA, ATLANTA, ATLANTIQUE, AXA, COMAR, 
#                 CORIS, GNA, LA LOYALE, LEADWAY, MATCA,  NSIA, SAAR, SANLAM, SCHIBA, 
#                 SERENITY S.A, SIDAM S.A, SMABTP, SONAM, SUNU, WAFA
#   - liste VIE : à ajouter  
# 
# * chemin_C1 : chemin d'accès de l'état C1 de la compagnie concernée
# 
# * chemin_C4 : chemin d'accès de l'état C4 de la compagnies concernée
# 
# NB : il est important de s'assurer que les états C1 et C4 de toutes les compagnies 
# respectent la même mise en forme que celle présentée dans l'état C4 & C1 de 'ACTIVA 2023'
# car les référeeces des lignes sont faites sur cette base. Si ce n'est pas le cas 
# mettre  en forme l'état concerné !!!!!!!!!!!!
# cleSSH : SHA256:a0EGnccVMeN711IDR6iIwoRSlyysSiVdZubfSWbuDsE ismail sare@CPT-STAT
# ---- Exécution ---------------------------------------------------------------

setwd("C:/Users/Ismail SARE/OneDrive - ASSOCIATION DES SOCIETES D'ASSURANCES/Chiffres/Donnees")
source("5 - Scripts/Fonction_compil_annuelle_donnees.R")
comp_ann_donnees(
  action = "creer", 
  branche = "IARD", 
  ann = 2023, 
  comp = "ACTIVA", 
  chemin_C1 = "ACTIVA/Non vie/2023/Annuel/Re_ ACTIVA _ Rappel - Collecte de données annuelles de 2023/C1_IARD_2023.xlsx",
  chemin_C4 = "ACTIVA/Non vie/2023/Annuel/Re_ ACTIVA _ Rappel - Collecte de données annuelles de 2023/C4_IARD 2023.xlsx"
  )
comp_ann_donnees(
  action = "ajouter", 
  branche = "IARD", 
  ann = 2023, 
  comp = "AMSA", 
  chemin_C1 = "AMSA/2023/Dossier annuel 2023/C1_IARD AMSA CI 2023.xlsx",
  chemin_C4 = "AMSA/2023/Dossier annuel 2023/C4_IARD AMSA CI 2023.xlsx"
  )
