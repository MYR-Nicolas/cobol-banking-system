      *****************************************************************
      * Program name:    TEST-U-FORMAT
      * Original author: NMAYEUR
      *
      * Maintenance Log
      * Date      Author        Maintenance Requirement
      * --------- ------------  ---------------------------------------
      * 08/08/26  NMAYEUR       Initial version
      *
      *****************************************************************
      * Purpose :
      *
      * Unit test driver for RULE-FORMAT.
      * Covers BR-FMT-001 (amount must be strictly positive).
      *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  TEST-U-FORMAT.
       AUTHOR. NMAYEUR.
       DATE-WRITTEN. 08/08/26.
      *****************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-TEST-CASES.
           05  WS-T-COUNT             PIC 9(2) VALUE 5.
           05  WS-T-TABLE OCCURS 5 TIMES.
               10  WS-T-LABEL         PIC X(30).
               10  WS-T-AMOUNT        PIC S9(11)V99 COMP-3.
               10  WS-T-EXPECTED-FLAG PIC X.

      
       01  WS-IDX                      PIC 9(2).
       01  WS-ACTUAL-FLAG              PIC X.
       01  WS-PASS-COUNT               PIC 9(3) VALUE 0.
       01  WS-FAIL-COUNT               PIC 9(3) VALUE 0.

       01  WS-AMOUNT-DISPLAY           PIC -Z(9)9.99.

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

           MOVE "T01 - Nominal positive amount"
               TO WS-T-LABEL(1)
           MOVE 1500.50                TO WS-T-AMOUNT(1)
           MOVE 'Y'                    TO WS-T-EXPECTED-FLAG(1)

           MOVE "T02 - Smallest positive amount"
               TO WS-T-LABEL(2)
           MOVE 0.01                   TO WS-T-AMOUNT(2)
           MOVE 'Y'                    TO WS-T-EXPECTED-FLAG(2)

           MOVE "T03 - Zero amount (boundary)"
               TO WS-T-LABEL(3)
           MOVE 0.00                   TO WS-T-AMOUNT(3)
           MOVE 'N'                    TO WS-T-EXPECTED-FLAG(3)

           MOVE "T04 - Negative amount"
               TO WS-T-LABEL(4)
           MOVE -250.75                TO WS-T-AMOUNT(4)
           MOVE 'N'                    TO WS-T-EXPECTED-FLAG(4)

           MOVE "T05 - Large positive amount"
               TO WS-T-LABEL(5)
           MOVE 99999999999.99         TO WS-T-AMOUNT(5)
           MOVE 'Y'                    TO WS-T-EXPECTED-FLAG(5)

           .

       RUN-ALL-TESTS.

           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > WS-T-COUNT

               CALL "RULE-FORMAT" USING
                   WS-T-AMOUNT(WS-IDX)
                   WS-ACTUAL-FLAG

               MOVE WS-T-AMOUNT(WS-IDX) TO WS-AMOUNT-DISPLAY

               IF WS-ACTUAL-FLAG = WS-T-EXPECTED-FLAG(WS-IDX)
                   ADD 1 TO WS-PASS-COUNT
                   DISPLAY "[PASS] " WS-T-LABEL(WS-IDX)
                       " | amount=" WS-AMOUNT-DISPLAY
                       " | expected=" WS-T-EXPECTED-FLAG(WS-IDX)
                       " actual=" WS-ACTUAL-FLAG
               ELSE
                   ADD 1 TO WS-FAIL-COUNT
                   DISPLAY "[FAIL] " WS-T-LABEL(WS-IDX)
                       " | amount=" WS-AMOUNT-DISPLAY
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
           DISPLAY "T-FORMAT SUMMARY".
           DISPLAY "  Total cases : " WS-T-COUNT.
           DISPLAY "  Passed      : " WS-PASS-COUNT.
           DISPLAY "  Failed      : " WS-FAIL-COUNT.
           DISPLAY "=========================================".