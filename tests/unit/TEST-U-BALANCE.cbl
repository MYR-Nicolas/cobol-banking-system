      *****************************************************************
      * Program name:    TEST-U-BALANCE
      * Original author: NMAYEUR
      *
      * Maintenance Log
      * Date      Author        Maintenance Requirement
      * --------- ------------  ---------------------------------------
      * 13/08/26  NMAYEUR       Initial version
      *
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

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-TEST-CASES.
           05  WS-T-COUNT              PIC 9(3) VALUE 3.
           05  WS-T-TABLE OCCURS 3 TIMES.
               10  WS-T-LABEL          PIC X(30).
               10  WS-T-NEW-SOLD       PIC S9(11)V99 COMP-3.
               10  WS-T-MAX-SEG        PIC S9(11)V99.
               10  WS-T-EXPECTED-FLAG  PIC X.

       01  WS-IDX                      PIC 9(3).
       01  WS-ACTUAL-FLAG              PIC X.
       01  WS-PASS-COUNT               PIC 9(3) VALUE 0.
       01  WS-FAIL-COUNT               PIC 9(3) VALUE 0.

       01  WS-T-NEW-SOLD-DISPLAY       PIC -Z(9)9.99.
       01  WS-T-MAX-SEG-DISPLAY        PIC -Z(9)9.99.


       PROCEDURE DIVISION.

       MAIN.

           PERFORM INIT-TEST-CASES.
           PERFORM RUN-ALL-TESTS.
           PERFORM DISPLAY-SUMMARY.

           GOBACK.

      *-----------------------------------------------------------------
      * Test cases
      *-----------------------------------------------------------------
       INIT-TEST-CASES.

      * New sold exceeds limit
           MOVE "New sold exceeds limit" TO WS-T-LABEL(1).
           MOVE 20000.01                 TO WS-T-NEW-SOLD(1).
           MOVE 20000.00                 TO WS-T-MAX-SEG(1).
           MOVE "N"                      TO WS-T-EXPECTED-FLAG(1).

      * New sold equal limit
           MOVE "New sold equal limit"   TO WS-T-LABEL(2).
           MOVE 20000.00                 TO WS-T-NEW-SOLD(2).
           MOVE 20000.00                 TO WS-T-MAX-SEG(2).
           MOVE "Y"                      TO WS-T-EXPECTED-FLAG(2).

      * New sold under limit
           MOVE "New sold under limit"   TO WS-T-LABEL(3).
           MOVE 19999.99                 TO WS-T-NEW-SOLD(3).
           MOVE 20000.00                 TO WS-T-MAX-SEG(3).
           MOVE "Y"                      TO WS-T-EXPECTED-FLAG(3).

       RUN-ALL-TESTS.

           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > WS-T-COUNT

               CALL "RULE-BALANCE" USING
                   WS-T-NEW-SOLD(WS-IDX)
                   WS-T-MAX-SEG(WS-IDX)
                   WS-ACTUAL-FLAG

               MOVE WS-T-NEW-SOLD(WS-IDX) TO WS-T-NEW-SOLD-DISPLAY
               MOVE WS-T-MAX-SEG(WS-IDX)  TO WS-T-MAX-SEG-DISPLAY

               IF WS-ACTUAL-FLAG = WS-T-EXPECTED-FLAG(WS-IDX)
                   ADD 1 TO WS-PASS-COUNT
                   DISPLAY "[PASS] " WS-T-LABEL(WS-IDX)
                       " | new sold=" WS-T-NEW-SOLD-DISPLAY
                       " | max seg=" WS-T-MAX-SEG-DISPLAY
                       " | expected=" WS-T-EXPECTED-FLAG(WS-IDX)
                       " actual=" WS-ACTUAL-FLAG
               ELSE
                   ADD 1 TO WS-FAIL-COUNT
                   DISPLAY "[FAIL] " WS-T-LABEL(WS-IDX)
                       " | new sold=" WS-T-NEW-SOLD-DISPLAY
                       " | max seg=" WS-T-MAX-SEG-DISPLAY
                       " | expected=" WS-T-EXPECTED-FLAG(WS-IDX)
                       " actual=" WS-ACTUAL-FLAG
               END-IF

           END-PERFORM.

      *-----------------------------------------------------------------
      * Final report
      *-----------------------------------------------------------------
       DISPLAY-SUMMARY.

           DISPLAY " ".
           DISPLAY "=========================================".
           DISPLAY "TEST-U-BALANCE SUMMARY".
           DISPLAY "  Total cases : " WS-T-COUNT.
           DISPLAY "  Passed      : " WS-PASS-COUNT.
           DISPLAY "  Failed      : " WS-FAIL-COUNT.
           DISPLAY "=========================================".
