      *****************************************************************
      * Program name:    RULE-ACCOUNT-CTRL                               
      * Original author: NMAYEUR                                
      *
      * Maintenence Log                                              
      * Date      Author        Maintenance Requirement               
      * --------- ------------  --------------------------------------- 
      * 22/07/26 NMAYEUR      
      *                                                               
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  RULE-ACCOUNT-CTRL.
       AUTHOR. NMAYEUR. 
       INSTALLATION. COBOL DEVELOPMENT CENTER. 
       DATE-WRITTEN. 22/07/26. 
       SECURITY. NON-CONFIDENTIAL.
      *****************************************************************

          
       ENVIRONMENT DIVISION. 

       DATA DIVISION. 
       WORKING-STORAGE SECTION. 

       LINKAGE SECTION.
       01  LK-TXN-SOURCE-ACC          PIC X(10). 

       01  LK-ACCOUNT-EXISTS-FLAG     PIC X.
           88  LK-ACCOUNT-EXISTS              VALUE 'Y'.
           88  LK-ACCOUNT-NOT-EXISTS          VALUE 'N'.

       01  LK-LNAME-MATCH-FLAG        PIC X.
           88  LK-LNAME-MATCHES                VALUE 'Y'.
           88  LK-LNAME-NOT-MATCHES            VALUE 'N'.

       01  LK-ACC-STATUS-FLAG         PIC X.
           88  LK-ACC-STATUS-ACTIVE            VALUE 'Y'.
           88  LK-ACC-STATUS-INACTIVE          VALUE 'N'.
       
       PROCEDURE DIVISION USING LK-TXN-SOURCE-ACC
                                LK-TXN-LNAME-ACC 
                                LK-ACC-STATUT.
                          
           EVALUATE TRUE 
              




       
      
    