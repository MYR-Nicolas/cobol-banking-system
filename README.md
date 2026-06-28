# COBOL Core Banking System

Projet pédagogique de simulation d'un système bancaire développé en COBOL.

L'objectif est de reproduire les principes fondamentaux des applications bancaires Mainframe en utilisant des fichiers séquentiels, des copybooks et des traitements batch.

---

## Objectifs

- Apprendre la programmation COBOL
- Manipuler des fichiers séquentiels
- Structurer un projet comme dans un environnement Mainframe
- Mettre en œuvre des règles de gestion bancaires
- Préparer l'intégration future de JCL, VSAM, DB2 et CICS

---

## Fonctionnalités

### Consultation de compte

Recherche d'un compte à partir de son numéro.

### Dépôt

Crédit d'un compte bancaire.

### Retrait

Débit d'un compte avec contrôle du solde disponible.

### Virement

Transfert d'argent entre deux comptes.

### Historique des transactions

Enregistrement des opérations réalisées.

### Rapport journalier

Génération d'un rapport de synthèse des opérations.

---

## Technologies

- COBOL
- VS Code
- Git
- GitHub

### Évolutions prévues

- JCL
- VSAM
- DB2
- CICS

---

## Roadmap

### Version 1

- [X] Lecture des comptes
- [ ] Consultation de compte
- [ ] Dépôt
- [ ] Retrait
- [ ] Virement

### Version 2

- [ ] Historique des transactions
- [ ] Rapport journalier

### Version 3

- [ ] Traitements batch JCL

### Version 4

- [ ] VSAM

### Version 5

- [ ] DB2

### Version 6

- [ ] CICS

---



Commande bash :

Vérification de la syntaxe:

cobc -fsyntax-only -Wall -I copybooks src/LSTCPT.cbl
cobc -fsyntax-only -Wall -I copybooks src/CNSCPT.cbl
cobc -fsyntax-only -Wall -I copybooks src/DEPOT.cbl


Compilation : 

cobc -x -Wall -I copybooks src/LSTCPT.cbl
cobc -x -Wall -I copybooks src/CNSCPT.cbl
cobc -x -Wall -I copybooks src/DEPOT.cbl

Exécuter :

./LSTCPT
./CNSCPT
./DEPOT
