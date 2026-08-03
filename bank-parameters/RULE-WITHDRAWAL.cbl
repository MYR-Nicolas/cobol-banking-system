      *****************************************************************
      * Program name:    RULE-WITHDRAWAL
      * Original author: NMAYEUR
      *
      * Maintenance Log
      * Date        Author    Maintenance Requirement
      * ----------- --------  ---------------------------------------
      * 2026/08/03  NMAYEUR   Initial version
      *
      *****************************************************************
      * Business rules covered :
      *
      *BR-LIM-001 The number of monthly withdrawals must not exceed the 
      *           limit defined for the customer segment.
      *           Note: PREMIUM segment has no withdrawal limit.
      *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID  RULE-WITHDRAWAL.
       AUTHOR NMAYEUR.
       INSTALLATION COBOL DEVELOPMENT CENTER.
       DATE-WRITTEN 2026/08/03.
       SECURITY NON-CONFIDENTIAL.
      *****************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
     
       LINKAGE SECTION.
      *-----------------------------------------------------------------
      * Input data
      *-----------------------------------------------------------------
       01  LK-WTHDRW-COUNT            PIC 9(4) COMP.
       01  LK-WTHDRW-LIMIT            PIC 9(4) COMP.

       COPY CUSTOMER.

      *-----------------------------------------------------------------
      * Output - result flag
      *-----------------------------------------------------------------
       01  LK-WTHDRW-FLAG                PIC X.
           88  LK-WTHDRW-VALID           VALUE 'Y'.
           88  LK-WTHDRW-NOT-VALID       VALUE 'N'.

       PROCEDURE DIVISION USING LK-WTHDRW-COUNT
                                 LK-WTHDRW-LIMIT
                                 CUSTOMER-RECORD
                                 LK-WTHDRW-FLAG.

           EVALUATE TRUE
               WHEN SEG-PREMIUM
                   SET LK-WTHDRW-VALID TO TRUE
               WHEN SEG-STANDARD OR SEG-PROFESSIONAL OR SEG-YOUTH
                   EVALUATE TRUE
                       WHEN LK-WTHDRW-COUNT <= LK-WTHDRW-LIMIT
                           SET LK-WTHDRW-VALID TO TRUE
                       WHEN OTHER
                           SET LK-WTHDRW-NOT-VALID TO TRUE
                   END-EVALUATE
               WHEN OTHER
                   SET LK-WTHDRW-NOT-VALID TO TRUE
           END-EVALUATE.

           GOBACK.