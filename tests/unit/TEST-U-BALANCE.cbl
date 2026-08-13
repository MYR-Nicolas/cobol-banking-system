      *****************************************************************
      * Program name:    TEST-U-BALANCE
      * Original author: NMAYEUR
      *
      * Maintenance Log
      * Date      Author        Maintenance Requirement
      * --------- ------------  ---------------------------------------
      * 13/08/26  NMAYEUR       Initial version
      * 13/08/26  NMAYEUR       V2 switch test data source to CSV
      *                         file; add coverage for all customer
      *                         segments
      *****************************************************************
      * Purpose :
      *
      * Unit test driver for RULE-BALANCE.
      * Covers BR-BAL-002 The balance after the operation must not
      *    exceed the maximum balance allowed for the customer segment.
      *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  TEST-U-BALANCE.
       AUTHOR. NMAYEUR.
       DATE-WRITTEN. 13/08/26.
      *****************************************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           SELECT TEST-CASE-FILE 
               ASSIGN TO "/workspaces/cobol-banking-system/tests/input/t
      -    "est-balance-cases.csv"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-TESTCASE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  TEST-CASE-FILE.
       01  WS-CSV-LINE                 PIC X(100).

       WORKING-STORAGE SECTION.

           COPY WS-FILE-STATUS.

       01  WS-EOF-FLAG                 PIC X VALUE "N".
           88  WS-EOF                  VALUE "Y".

       01  WS-LINE-COUNT               PIC 9(3) VALUE 0.

       01  WS-CSV-FIELDS.
           05  WS-CSV-LABEL            PIC X(30).
           05  WS-CSV-SEGMENT          PIC X(10).
           05  WS-CSV-NEW-SOLD-X       PIC X(15).
           05  WS-CSV-MAX-SEG-X        PIC X(15).
           05  WS-CSV-EXPECTED         PIC X.

       01  WS-T-NEW-SOLD                PIC S9(11)V99 COMP-3.
       01  WS-T-MAX-SEG                 PIC S9(11)V99.
       01  WS-ACTUAL-FLAG               PIC X.
       01  WS-PASS-COUNT                PIC 9(3) VALUE 0.
       01  WS-FAIL-COUNT                PIC 9(3) VALUE 0.

       01  WS-T-NEW-SOLD-DISPLAY        PIC -Z(9)9.99.
       01  WS-T-MAX-SEG-DISPLAY         PIC -Z(9)9.99.


       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT TEST-CASE-FILE
           IF NOT TESTCASE-OK
               DISPLAY "ERROR OPENING CSV: " WS-TESTCASE-STATUS
               GOBACK
           END-IF

           READ TEST-CASE-FILE
               AT END SET WS-EOF TO TRUE
           END-READ

           PERFORM UNTIL WS-EOF
               READ TEST-CASE-FILE
                   AT END SET WS-EOF TO TRUE
                   NOT AT END
                       ADD 1 TO WS-LINE-COUNT
                       PERFORM RUN-TEST
               END-READ
           END-PERFORM

           CLOSE TEST-CASE-FILE
           PERFORM DISPLAY-SUMMARY
           GOBACK.

 
       RUN-TEST.

           UNSTRING WS-CSV-LINE DELIMITED BY ","
               INTO WS-CSV-LABEL
                    WS-CSV-SEGMENT
                    WS-CSV-NEW-SOLD-X
                    WS-CSV-MAX-SEG-X
                    WS-CSV-EXPECTED
           END-UNSTRING

           MOVE FUNCTION NUMVAL(WS-CSV-NEW-SOLD-X) TO WS-T-NEW-SOLD
           MOVE FUNCTION NUMVAL(WS-CSV-MAX-SEG-X)  TO WS-T-MAX-SEG
           MOVE WS-T-NEW-SOLD TO WS-T-NEW-SOLD-DISPLAY
           MOVE WS-T-MAX-SEG  TO WS-T-MAX-SEG-DISPLAY

           CALL "RULE-BALANCE" USING
               WS-T-NEW-SOLD
               WS-T-MAX-SEG
               WS-ACTUAL-FLAG

           IF WS-ACTUAL-FLAG = WS-CSV-EXPECTED
               ADD 1 TO WS-PASS-COUNT
               DISPLAY "[PASS] " WS-CSV-SEGMENT " - " WS-CSV-LABEL
                   " | new sold=" WS-T-NEW-SOLD-DISPLAY
                   " | max seg=" WS-T-MAX-SEG-DISPLAY
                   " | expected=" WS-CSV-EXPECTED
                   " actual=" WS-ACTUAL-FLAG
           ELSE
               ADD 1 TO WS-FAIL-COUNT
               DISPLAY "[FAIL] " WS-CSV-SEGMENT " - " WS-CSV-LABEL
                   " | new sold=" WS-T-NEW-SOLD-DISPLAY
                   " | max seg=" WS-T-MAX-SEG-DISPLAY
                   " | expected=" WS-CSV-EXPECTED
                   " actual=" WS-ACTUAL-FLAG
           END-IF.

      *-----------------------------------------------------------------
      * Final report
      *-----------------------------------------------------------------
       DISPLAY-SUMMARY.

           DISPLAY " ".
           DISPLAY "=========================================".
           DISPLAY "TEST-U-BALANCE SUMMARY".
           DISPLAY "  Total cases : " WS-LINE-COUNT.
           DISPLAY "  Passed      : " WS-PASS-COUNT.
           DISPLAY "  Failed      : " WS-FAIL-COUNT.
           DISPLAY "=========================================".