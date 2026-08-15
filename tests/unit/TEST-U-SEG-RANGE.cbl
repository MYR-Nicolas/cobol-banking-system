      *****************************************************************
      * Program name:    TEST-U-SEG-RANGE
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
      * Unit test driver for RULE-SEG-RANGE.
      * Covers BR-SEG-001 (the amount is greater than or equal to the 
      *    minimum defined by customer segmentation and operation type)
      *    and BR-SEG-002 (the amount is less than or equal to the 
      *    maximum defined by customer segmentation and operation type)
      *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  TEST-U-SEG-RANGE.
       AUTHOR. NMAYEUR.
       DATE-WRITTEN. 13/08/26.
      *****************************************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           SELECT CSV-FILE
               ASSIGN TO "/workspaces/cobol-banking-system/tests/input/t
      -         "est-operations-cases.csv"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-CSV-STATUS.
 
           SELECT PARAMSEG-FILE
               ASSIGN TO "/workspaces/cobol-banking-system/data/PARAMSEG
      -         ".DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PARAMSEG-STATUS.
 
       DATA DIVISION.
       FILE SECTION.
       FD  CSV-FILE.
       01  CSV-LINE                      PIC X(200).
 
       FD  PARAMSEG-FILE.
       01  PARAMSEG-LINE                 PIC X(128).
 
       WORKING-STORAGE SECTION.
 
       01  WS-CSV-STATUS                 PIC XX.
           88  WS-CSV-OK                 VALUE '00'.
           88  WS-CSV-EOF                VALUE '10'.
 
       01  WS-PARAMSEG-STATUS            PIC XX.
           88  WS-PARAMSEG-OK            VALUE '00'.
           88  WS-PARAMSEG-EOF           VALUE '10'.
 
      *-----------------------------------------------------------------
      * Table segmentation customer
      *-----------------------------------------------------------------
       01  WS-SEGPARM-TABLE.
           05  WS-SEGPARM-COUNT          PIC 9(3) VALUE 0.
           05  WS-SEGPARM-ENTRY          PIC X(128)
                                          OCCURS 20 TIMES.
 
       01  WS-SEG-IDX                    PIC 9(3).
       01  WS-SEG-FOUND-SW               PIC X VALUE 'N'.
           88  WS-SEG-FOUND              VALUE 'Y'.
 
  
       COPY SEG-CUSTOMER.
 
      *-----------------------------------------------------------------
      * CSV fields
      *-----------------------------------------------------------------
       01  WS-CSV-FIELDS.
           05  WS-CSV-LABEL               PIC X(40).
           05  WS-CSV-SEGMENT             PIC X(08).
           05  WS-CSV-OPERATION           PIC X(15).
           05  WS-CSV-CHECK-VALUE         PIC X(15).
           05  WS-CSV-EXPECTED            PIC X(01).
 
       01  WS-CHECK-VALUE-NUM             PIC S9(11)V99 COMP-3.
       01  WS-CHECK-VALUE-DISPLAY         PIC -Z(9)9.99.
 
       01  WS-FIRST-LINE-SW               PIC X VALUE 'Y'.
           88  WS-FIRST-LINE              VALUE 'Y'.
 
      *-----------------------------------------------------------------
      * Other data passed to RULE-SEG-RANGE
      *-----------------------------------------------------------------
       01  LK-OPERATION-TYPE              PIC X(02).
 
       01  LK-RANGE-FLAG                  PIC X.
           88  LK-RANGE-VALID             VALUE 'Y'.
           88  LK-RANGE-NOT-VALID         VALUE 'N'.
 
      *-----------------------------------------------------------------
      * Counters
      *-----------------------------------------------------------------
       01  WS-TOTAL-COUNT                 PIC 9(5) VALUE ZERO.
       01  WS-PASS-COUNT                  PIC 9(5) VALUE ZERO.
       01  WS-FAIL-COUNT                  PIC 9(5) VALUE ZERO.
 
       PROCEDURE DIVISION.
 
       MAIN.
 
           PERFORM LOAD-SEGPARM-TABLE.
           PERFORM RUN-CSV-TESTS.
           PERFORM DISPLAY-SUMMARY.
 
           GOBACK.
 
      *-----------------------------------------------------------------
      * Load all segment records from PARAMSEG.DAT
      *-----------------------------------------------------------------
       LOAD-SEGPARM-TABLE.
 
           OPEN INPUT PARAMSEG-FILE
 
           PERFORM UNTIL WS-PARAMSEG-EOF
               READ PARAMSEG-FILE
                   AT END
                       SET WS-PARAMSEG-EOF TO TRUE
                   NOT AT END
                       ADD 1 TO WS-SEGPARM-COUNT
                       MOVE PARAMSEG-LINE
                           TO WS-SEGPARM-ENTRY(WS-SEGPARM-COUNT)
               END-READ
           END-PERFORM
 
           CLOSE PARAMSEG-FILE
 
           DISPLAY "Loaded " WS-SEGPARM-COUNT " segment record(s) "
                   "from PARAMSEG.DAT".
 
      *-----------------------------------------------------------------
      * Main CSV-driven test loop.
      *-----------------------------------------------------------------
       RUN-CSV-TESTS.
 
           OPEN INPUT CSV-FILE
 
           PERFORM UNTIL WS-CSV-EOF
               READ CSV-FILE
                   AT END
                       SET WS-CSV-EOF TO TRUE
                   NOT AT END
                       IF WS-FIRST-LINE
                           MOVE 'N' TO WS-FIRST-LINE-SW
                       ELSE
                           PERFORM PROCESS-TEST-CASE
                       END-IF
               END-READ
           END-PERFORM
 
           CLOSE CSV-FILE.
 
       PROCESS-TEST-CASE.
 
           PERFORM PARSE-CSV-LINE
           PERFORM LOOKUP-SEGMENT
 
           IF WS-SEG-FOUND
               PERFORM CALL-RULE-SEG-RANGE
               PERFORM COMPARE-RESULT
           ELSE
               ADD 1 TO WS-TOTAL-COUNT
               ADD 1 TO WS-FAIL-COUNT
               DISPLAY "[FAIL] " WS-CSV-LABEL
                       " | segment not found: " WS-CSV-SEGMENT
           END-IF.
 
       PARSE-CSV-LINE.
 
           UNSTRING CSV-LINE DELIMITED BY ','
               INTO WS-CSV-LABEL
                    WS-CSV-SEGMENT
                    WS-CSV-OPERATION
                    WS-CSV-CHECK-VALUE
                    WS-CSV-EXPECTED
           END-UNSTRING
 
           COMPUTE WS-CHECK-VALUE-NUM =
               FUNCTION NUMVAL(WS-CSV-CHECK-VALUE)
 
           EVALUATE WS-CSV-OPERATION
               WHEN 'DEPOSIT'
                   MOVE 'DP' TO LK-OPERATION-TYPE
               WHEN 'WITHDRAWAL'
                   MOVE 'WD' TO LK-OPERATION-TYPE
               WHEN 'TRANSFER'
                   MOVE 'TR' TO LK-OPERATION-TYPE
               WHEN 'BALANCE'
                   MOVE 'BL' TO LK-OPERATION-TYPE
               WHEN OTHER
                   MOVE SPACES TO LK-OPERATION-TYPE
           END-EVALUATE.
 
      *-----------------------------------------------------------------
      * Lookup of the segment record matching WS-CSV-SEGMENT.
      *-----------------------------------------------------------------
       LOOKUP-SEGMENT.
 
           MOVE 'N' TO WS-SEG-FOUND-SW
 
           PERFORM VARYING WS-SEG-IDX FROM 1 BY 1
               UNTIL WS-SEG-IDX > WS-SEGPARM-COUNT
                  OR WS-SEG-FOUND
 
               MOVE WS-SEGPARM-ENTRY(WS-SEG-IDX) TO SEG-PARAM-RECORD
 
               IF PS-SEGMENT-CODE = WS-CSV-SEGMENT
                   SET WS-SEG-FOUND TO TRUE
               END-IF
 
           END-PERFORM.
 
       CALL-RULE-SEG-RANGE.
 
           CALL 'RULE-SEG-RANGE' USING WS-CHECK-VALUE-NUM
                                        LK-OPERATION-TYPE
                                        SEG-PARAM-RECORD
                                        LK-RANGE-FLAG
           END-CALL.
 
       COMPARE-RESULT.
 
           ADD 1 TO WS-TOTAL-COUNT
           MOVE WS-CHECK-VALUE-NUM TO WS-CHECK-VALUE-DISPLAY
 
           IF LK-RANGE-FLAG = WS-CSV-EXPECTED
               ADD 1 TO WS-PASS-COUNT
               DISPLAY "[PASS] " WS-CSV-LABEL
                       " | value=" WS-CHECK-VALUE-DISPLAY
                       " | expected=" WS-CSV-EXPECTED
                       " actual=" LK-RANGE-FLAG
           ELSE
               ADD 1 TO WS-FAIL-COUNT
               DISPLAY "[FAIL] " WS-CSV-LABEL
                       " | value=" WS-CHECK-VALUE-DISPLAY
                       " | expected=" WS-CSV-EXPECTED
                       " actual=" LK-RANGE-FLAG
           END-IF.
 
       DISPLAY-SUMMARY.
 
           DISPLAY " ".
           DISPLAY "=========================================".
           DISPLAY "TEST-U-SEG-RANGE SUMMARY".
           DISPLAY "  Total cases : " WS-TOTAL-COUNT.
           DISPLAY "  Passed      : " WS-PASS-COUNT.
           DISPLAY "  Failed      : " WS-FAIL-COUNT.
           DISPLAY "=========================================".
