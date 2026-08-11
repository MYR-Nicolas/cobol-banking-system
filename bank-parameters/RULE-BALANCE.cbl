      *****************************************************************
      * Program name:    RULE-BALANCE                              
      * Original author: NMAYEUR                                
      *
      * Maintenence Log                                              
      * Date      Author        Maintenance Requirement               
      * --------- ------------  --------------------------------------- 
      * 2026/08/03 NMAYEUR       Initial version
      *                                                               
      *****************************************************************
      * Business rules covered :
      *
      * BR-BAL-002 The balance after the operation must not exceed the 
      *             maximum balance allowed for the customer segment.
      *             
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  RULE-BALANCE.
       AUTHOR.      NMAYEUR.
       INSTALLATION. COBOL DEVELOPMENT CENTER.
       DATE-WRITTEN. 2026/08/03.
       SECURITY.    NON-CONFIDENTIAL.
      *****************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       LINKAGE SECTION.
      *-----------------------------------------------------------------
      * Input data
      *-----------------------------------------------------------------
       01  LK-SEG-VALUE-CHECK            PIC S9(11)V99 COMP-3.
       01  LK-SELECT-MAX-BALANCE         PIC S9(11)V99.


      *-----------------------------------------------------------------
      * Output - result flag
      *-----------------------------------------------------------------
       01  LK-BALANCE-FLAG                PIC X.
           88  LK-BALANCE-VALID           VALUE 'Y'.
           88  LK-BALANCE-NOT-VALID       VALUE 'N'.

       PROCEDURE DIVISION USING LK-SEG-VALUE-CHECK
                                 LK-SELECT-MAX-BALANCE
                                 LK-BALANCE-FLAG.

       MAIN.

           EVALUATE TRUE
               WHEN LK-SEG-VALUE-CHECK <= LK-SELECT-MAX-BALANCE
                   SET LK-BALANCE-VALID TO TRUE
               WHEN OTHER
                   SET LK-BALANCE-NOT-VALID TO TRUE
           END-EVALUATE.

           GOBACK.