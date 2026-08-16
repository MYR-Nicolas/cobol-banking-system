      *****************************************************************
      * Program name:    TEST-U-WD
      * Original author: NMAYEUR
      *
      * Maintenance Log
      * Date      Author        Maintenance Requirement
      * --------- ------------  ---------------------------------------
      * 15/08/26  NMAYEUR       Initial version
      *
      *****************************************************************
      * Purpose :
      *
      * Unit test driver for RULE-WITHDRAWAL.

      * Business rules covered :
      * BR-LIM-001 The number of monthly withdrawals must not exceed the
      *           limit defined for the customer segment.
      *           Note: PREMIUM segment has no withdrawal limit.
      *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  TEST-U-WD.
       AUTHOR. NMAYEUR.
       DATE-WRITTEN. 15/08/26.
      *****************************************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT CSV-FILE
               ASSIGN TO "/workspaces/cobol-banking-system/tests/input/t
      -         "est-rule-wd.csv"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-CSV-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  CSV-FILE.
       01  CSV-LINE                      PIC X(200).

       WORKING-STORAGE SECTION.

       01  WS-CSV-STATUS                 PIC XX.
           88  WS-CSV-OK                 VALUE '00'.
           88  WS-CSV-EOF                VALUE '10'.

       01  WS-EOF-FLAG                   PIC X VALUE 'F'.
           88  END-OF-FILE               VALUE 'T'.

      *-----------------------------------------------------------------
      * CSV fields
      *-----------------------------------------------------------------
       01  WS-CSV-FIELDS.
           05  WS-CSV-CUST-SEGMENT       PIC X(10).
           05  WS-CSV-WTHDRW-COUNT       PIC 9(4).
           05  WS-CSV-WTHDRW-LIMIT       PIC 9(4).
           05  WS-CSV-EXPECTED-FLAG      PIC X.

      *-----------------------------------------------------------------
      * Working copies passed to RULE-WITHDRAWAL
      *-----------------------------------------------------------------
       01  WS-WTHDRW-COUNT               PIC 9(4) COMP.
       01  WS-WTHDRW-LIMIT               PIC 9(4) COMP.


           COPY CUSTOMER.

       01  WS-ACTUAL-FLAG                PIC X.
           88  WS-ACTUAL-VALID           VALUE 'Y'.
           88  WS-ACTUAL-NOT-VALID       VALUE 'N'.

      *-----------------------------------------------------------------
      * Counters
      *-----------------------------------------------------------------
       01  WS-TOTAL-COUNT                PIC 9(5) VALUE ZERO.
       01  WS-PASS-COUNT                 PIC 9(5) VALUE ZERO.
       01  WS-FAIL-COUNT                 PIC 9(5) VALUE ZERO.

       PROCEDURE DIVISION.

       MAIN.
           OPEN INPUT CSV-FILE
           IF NOT WS-CSV-OK
               DISPLAY "READ ERROR CSV : " WS-CSV-STATUS
               STOP RUN
           END-IF

      *    Skip header line
           READ CSV-FILE
               AT END SET END-OF-FILE TO TRUE
           END-READ

           PERFORM UNTIL END-OF-FILE
               READ CSV-FILE
                   AT END SET END-OF-FILE TO TRUE
                   NOT AT END
                       PERFORM PROCESS-TEST-CASE
               END-READ
           END-PERFORM

           CLOSE CSV-FILE

           PERFORM DISPLAY-SUMMARY

           STOP RUN.

       PROCESS-TEST-CASE.
           PERFORM READ-CSV
           PERFORM CALL-RULE-WITHDRAWAL
           PERFORM COMPARE-RESULT.

       READ-CSV.
           UNSTRING CSV-LINE DELIMITED BY ','
               INTO WS-CSV-CUST-SEGMENT
                    WS-CSV-WTHDRW-COUNT
                    WS-CSV-WTHDRW-LIMIT
                    WS-CSV-EXPECTED-FLAG
           END-UNSTRING

      
           MOVE WS-CSV-WTHDRW-COUNT TO WS-WTHDRW-COUNT
           MOVE WS-CSV-WTHDRW-LIMIT TO WS-WTHDRW-LIMIT
           INITIALIZE CUSTOMER-RECORD
           MOVE WS-CSV-CUST-SEGMENT TO CUST-SEGMENT.

       CALL-RULE-WITHDRAWAL.
           CALL 'RULE-WITHDRAWAL' USING WS-WTHDRW-COUNT
                                        WS-WTHDRW-LIMIT
                                        CUSTOMER-RECORD
                                        WS-ACTUAL-FLAG.

       COMPARE-RESULT.
           ADD 1 TO WS-TOTAL-COUNT

           IF WS-CSV-EXPECTED-FLAG = WS-ACTUAL-FLAG
               ADD 1 TO WS-PASS-COUNT
               DISPLAY "[PASS] " WS-CSV-CUST-SEGMENT
                       " | count=" WS-CSV-WTHDRW-COUNT
                       " | limit=" WS-CSV-WTHDRW-LIMIT
                       " | expected=" WS-CSV-EXPECTED-FLAG
                       " actual=" WS-ACTUAL-FLAG
           ELSE
               ADD 1 TO WS-FAIL-COUNT
               DISPLAY "[FAIL] " WS-CSV-CUST-SEGMENT
                       " | count=" WS-CSV-WTHDRW-COUNT
                       " | limit=" WS-CSV-WTHDRW-LIMIT
                       " | expected=" WS-CSV-EXPECTED-FLAG
                       " actual=" WS-ACTUAL-FLAG
           END-IF.

       DISPLAY-SUMMARY.
           DISPLAY " ".
           DISPLAY "=========================================".
           DISPLAY "TEST-U-WD SUMMARY".
           DISPLAY "  Total cases : " WS-TOTAL-COUNT.
           DISPLAY "  Passed      : " WS-PASS-COUNT.
           DISPLAY "  Failed      : " WS-FAIL-COUNT.
           DISPLAY "=========================================".