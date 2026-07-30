      *****************************************************************
      * Program name:    RULE-FORMAT
      * Original author: NMAYEUR
      *
      * Maintenance Log
      * Date      Author        Maintenance Requirement
      * --------- ------------  ---------------------------------------
      * 29/07/26  NMAYEUR       Initial version
      *
      *****************************************************************
      * Business rules covered :
      *
      * BR-FMT-001 The amount must be strictly positive.
      *
      * BR-FMT-002 Max two decimal places. Enforced structurally by
      *            the PIC S9V99 COMP-3.
      *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  RULE-FORMAT.
       AUTHOR. NMAYEUR.
       INSTALLATION. COBOL DEVELOPMENT CENTER.
       DATE-WRITTEN. 29/07/26.
       SECURITY. NON-CONFIDENTIAL.
      *****************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       LINKAGE SECTION.
      *-----------------------------------------------------------------
      * Input data
      *-----------------------------------------------------------------
       01  AMT-CHECK                   PIC S9(11)V99 COMP-3.

      *-----------------------------------------------------------------
      * Output - result flag
      *-----------------------------------------------------------------
       01  LK-AMT-FLAG                 PIC X.
           88  LK-AMT-POSITIVE         VALUE 'Y'.
           88  LK-AMT-NEGATIVE-OR-ZERO VALUE 'N'.

       PROCEDURE DIVISION USING AMT-CHECK LK-AMT-FLAG.

       MAIN.

           EVALUATE TRUE
               WHEN AMT-CHECK > 0
                   SET LK-AMT-POSITIVE         TO TRUE
               WHEN OTHER
                   SET LK-AMT-NEGATIVE-OR-ZERO TO TRUE
           END-EVALUATE.

           GOBACK.