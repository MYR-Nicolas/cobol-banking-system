      *****************************************************************
      * Program name:    TEST-U-ACC
      * Original author: NMAYEUR
      *
      * Purpose : CSV driven unit test driver for RULE-ACCOUNT-CTRL.
      *           Reads acc-ctrl-tests.csv, calls the rule
      *           subprogram for each row, compares actual output
      *           flags against expected values, and writes a
      *           PASS/FAIL report.
      *
      * Maintenence Log
      * Date      Author        Maintenance Requirement
      * --------- ------------  ---------------------------------------
      * 20/08/26 NMAYEUR       Initial version
      *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  TEST-U-ACC.
       AUTHOR. NMAYEUR.
       DATE-WRITTEN. 20/08/26.
      *****************************************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *    Input file: the CSV list of test cases to run
           SELECT TEST-CASES-FILE 
               ASSIGN TO "/workspaces/cobol-banking-system/tests/input/a
      -         "cc-ctrl-tests.csv"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-TESTCASE-STATUS.

      *    Output file: the PASS/FAIL report written by this driver
           SELECT REPORT-FILE 
               ASSIGN TO "/workspaces/cobol-banking-system/logs/testsACC
      -         "OUNT-CTRL-RESULTS.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
      *    One raw CSV line read from the test cases file
       FD  TEST-CASES-FILE.
       01  TEST-CASE-LINE              PIC X(300).

      *    One line written to the report file
       FD  REPORT-FILE.
       01  REPORT-LINE                 PIC X(200).

       WORKING-STORAGE SECTION.

      *    Shared file status copybook (only WS-TESTCASE-STATUS used here)
       COPY WS-FILE-STATUS.

      *    Turns TRUE once the test cases file has been fully read
       01  WS-EOF-FLAG                 PIC X VALUE 'N'.
           88  WS-EOF                        VALUE 'Y'.

      *    Line counter, mainly useful for troubleshooting a bad CSV row
       01  WS-LINE-COUNT                PIC 9(4) VALUE 0.

      *    Running totals shown in the final summary
       01  WS-COUNTERS.
           05  WS-TOTAL-TESTS           PIC 9(4) VALUE 0.
           05  WS-PASSED-TESTS          PIC 9(4) VALUE 0.
           05  WS-FAILED-TESTS          PIC 9(4) VALUE 0.

      *-----------------------------------------------------------------
      * CSV columns - inputs to RULE-ACCOUNT-CTRL
      *-----------------------------------------------------------------
       01  WS-TEST-ID                  PIC X(10).
       01  WS-DESCRIPTION              PIC X(40).
       01  WS-IN-OPERATION-TYPE        PIC X(10).
       01  WS-IN-ACCOUNT-FOUND-FLAG    PIC X.
       01  WS-IN-CUSTOMER-FOUND-FLAG   PIC X.
       01  WS-IN-ACCOUNT-NUMBER        PIC X(10).
       01  WS-IN-ACCOUNT-STATUS        PIC X.
       01  WS-IN-ACCOUNT-CUSTOMER-ID   PIC X(7).
       01  WS-IN-CUSTOMER-ID           PIC X(7).
       01  WS-IN-CUSTOMER-LAST-NAME    PIC X(20).
       01  WS-IN-CUSTOMER-FIRST-NAME   PIC X(20).
       01  WS-IN-ENTERED-LAST-NAME     PIC X(20).
       01  WS-IN-ENTERED-FIRST-NAME    PIC X(20).
       01  WS-IN-TARGET-ACCOUNT-NUMBER PIC X(10).

      *-----------------------------------------------------------------
      * CSV columns - expected outputs
      *-----------------------------------------------------------------
       01  WS-EXP-ACCOUNT-EXISTS       PIC X.
       01  WS-EXP-CUSTOMER-EXISTS      PIC X.
       01  WS-EXP-ACC-STATUS           PIC X.
       01  WS-EXP-CUST-ID-MATCH        PIC X.
       01  WS-EXP-LNAME-MATCH          PIC X.
       01  WS-EXP-FNAME-MATCH          PIC X.
       01  WS-EXP-ACCOUNTS-DIFFERENT   PIC X.

      *-----------------------------------------------------------------
      * Actual outputs returned by RULE-ACCOUNT-CTRL
      *-----------------------------------------------------------------
       01  WS-OUT-ACCOUNT-EXISTS       PIC X.
       01  WS-OUT-CUSTOMER-EXISTS      PIC X.
       01  WS-OUT-ACC-STATUS           PIC X.
       01  WS-OUT-CUST-ID-MATCH        PIC X.
       01  WS-OUT-LNAME-MATCH          PIC X.
       01  WS-OUT-FNAME-MATCH          PIC X.
       01  WS-OUT-ACCOUNTS-DIFFERENT   PIC X.

      *    "PASS" or "FAIL" for the current test case
       01  WS-TEST-RESULT              PIC X(4).
      *    Text describing which field(s) did not match, if any
       01  WS-MISMATCH-DETAIL          PIC X(120).

       PROCEDURE DIVISION.

       MAIN.
      *    Open the CSV input and the report output
           OPEN INPUT TEST-CASES-FILE
           OPEN OUTPUT REPORT-FILE

      *    Read the first physical line (this will be the CSV header)
           PERFORM READ-NEXT-TEST-CASE

      *    Skip the CSV header line, read the first real test case
           IF NOT WS-EOF
               PERFORM READ-NEXT-TEST-CASE
           END-IF

      *    Main loop: one test case per CSV row until end of file
           PERFORM UNTIL WS-EOF
               ADD 1 TO WS-LINE-COUNT
               PERFORM PARSE-TEST-CASE-LINE
               PERFORM RUN-TEST-CASE
               PERFORM COMPARE-RESULTS
               PERFORM WRITE-REPORT-LINE
               PERFORM READ-NEXT-TEST-CASE
           END-PERFORM

           PERFORM WRITE-SUMMARY

           CLOSE TEST-CASES-FILE
           CLOSE REPORT-FILE

      *    Final summary shown on screen
           DISPLAY "==============================================="
           DISPLAY "UT-ACCOUNT-CTRL - Total  : " WS-TOTAL-TESTS
           DISPLAY "UT-ACCOUNT-CTRL - Passed : " WS-PASSED-TESTS
           DISPLAY "UT-ACCOUNT-CTRL - Failed : " WS-FAILED-TESTS
           DISPLAY "==============================================="

      *    Non-zero return code lets a CI pipeline detect failures
           IF WS-FAILED-TESTS > 0
               MOVE 1 TO RETURN-CODE
           END-IF

           GOBACK.

      *-----------------------------------------------------------------
      * Reads one line from the CSV file and checks the file status.
      * Sets WS-EOF on end of file or on any I/O error.
      *-----------------------------------------------------------------
       READ-NEXT-TEST-CASE.
           READ TEST-CASES-FILE
               AT END
                   SET WS-EOF TO TRUE
           END-READ

      *    If the read did not hit end of file, make sure it actually
      *    succeeded (status must be '00' - see copybook WS-FILE-STATUS)
           IF NOT WS-EOF
               IF NOT TESTCASE-OK
                   DISPLAY "UT-ACCOUNT-CTRL - I/O error on "
                       "ACCOUNT-CTRL-TESTS.csv - FILE STATUS="
                       WS-TESTCASE-STATUS
                   MOVE 1 TO RETURN-CODE
                   SET WS-EOF TO TRUE
               END-IF
           END-IF.

      *-----------------------------------------------------------------
      * Splits the current CSV line (comma separated) into its columns
      *-----------------------------------------------------------------
       PARSE-TEST-CASE-LINE.
           UNSTRING TEST-CASE-LINE DELIMITED BY ","
               INTO WS-TEST-ID
                    WS-DESCRIPTION
                    WS-IN-OPERATION-TYPE
                    WS-IN-ACCOUNT-FOUND-FLAG
                    WS-IN-CUSTOMER-FOUND-FLAG
                    WS-IN-ACCOUNT-NUMBER
                    WS-IN-ACCOUNT-STATUS
                    WS-IN-ACCOUNT-CUSTOMER-ID
                    WS-IN-CUSTOMER-ID
                    WS-IN-CUSTOMER-LAST-NAME
                    WS-IN-CUSTOMER-FIRST-NAME
                    WS-IN-ENTERED-LAST-NAME
                    WS-IN-ENTERED-FIRST-NAME
                    WS-IN-TARGET-ACCOUNT-NUMBER
                    WS-EXP-ACCOUNT-EXISTS
                    WS-EXP-CUSTOMER-EXISTS
                    WS-EXP-ACC-STATUS
                    WS-EXP-CUST-ID-MATCH
                    WS-EXP-LNAME-MATCH
                    WS-EXP-FNAME-MATCH
                    WS-EXP-ACCOUNTS-DIFFERENT
           END-UNSTRING.

      *-----------------------------------------------------------------
      * Calls RULE-ACCOUNT-CTRL with the parsed input columns and
      * collects the 7 output flags it returns
      *-----------------------------------------------------------------
       RUN-TEST-CASE.
           CALL "RULE-ACCOUNT-CTRL" USING
                   WS-IN-OPERATION-TYPE
                   WS-IN-ACCOUNT-FOUND-FLAG
                   WS-IN-CUSTOMER-FOUND-FLAG
                   WS-IN-ACCOUNT-NUMBER
                   WS-IN-ACCOUNT-STATUS
                   WS-IN-ACCOUNT-CUSTOMER-ID
                   WS-IN-CUSTOMER-ID
                   WS-IN-CUSTOMER-LAST-NAME
                   WS-IN-CUSTOMER-FIRST-NAME
                   WS-IN-ENTERED-LAST-NAME
                   WS-IN-ENTERED-FIRST-NAME
                   WS-IN-TARGET-ACCOUNT-NUMBER
                   WS-OUT-ACCOUNT-EXISTS
                   WS-OUT-CUSTOMER-EXISTS
                   WS-OUT-ACC-STATUS
                   WS-OUT-CUST-ID-MATCH
                   WS-OUT-LNAME-MATCH
                   WS-OUT-FNAME-MATCH
                   WS-OUT-ACCOUNTS-DIFFERENT
           END-CALL.

      *-----------------------------------------------------------------
      * Compares each actual output flag to its expected value.
      * Builds a mismatch message and sets PASS/FAIL, then updates
      * the running totals.
      *-----------------------------------------------------------------
       COMPARE-RESULTS.
           ADD 1 TO WS-TOTAL-TESTS
           MOVE SPACES TO WS-MISMATCH-DETAIL
           MOVE "PASS" TO WS-TEST-RESULT

      *    BR-ACC-001 : account exists
           IF WS-OUT-ACCOUNT-EXISTS NOT = WS-EXP-ACCOUNT-EXISTS
               STRING WS-MISMATCH-DETAIL DELIMITED BY SPACE
                   " ACCOUNT-EXISTS exp=" DELIMITED BY SIZE
                   WS-EXP-ACCOUNT-EXISTS DELIMITED BY SIZE
                   " got=" DELIMITED BY SIZE
                   WS-OUT-ACCOUNT-EXISTS DELIMITED BY SIZE
                   INTO WS-MISMATCH-DETAIL
               END-STRING
               MOVE "FAIL" TO WS-TEST-RESULT
           END-IF

      *    BR-ACC-002 : customer exists
           IF WS-OUT-CUSTOMER-EXISTS NOT = WS-EXP-CUSTOMER-EXISTS
               STRING WS-MISMATCH-DETAIL DELIMITED BY SPACE
                   " CUSTOMER-EXISTS exp=" DELIMITED BY SIZE
                   WS-EXP-CUSTOMER-EXISTS DELIMITED BY SIZE
                   " got=" DELIMITED BY SIZE
                   WS-OUT-CUSTOMER-EXISTS DELIMITED BY SIZE
                   INTO WS-MISMATCH-DETAIL
               END-STRING
               MOVE "FAIL" TO WS-TEST-RESULT
           END-IF

      *    BR-ACC-003 : account is active
           IF WS-OUT-ACC-STATUS NOT = WS-EXP-ACC-STATUS
               STRING WS-MISMATCH-DETAIL DELIMITED BY SPACE
                   " ACC-STATUS exp=" DELIMITED BY SIZE
                   WS-EXP-ACC-STATUS DELIMITED BY SIZE
                   " got=" DELIMITED BY SIZE
                   WS-OUT-ACC-STATUS DELIMITED BY SIZE
                   INTO WS-MISMATCH-DETAIL
               END-STRING
               MOVE "FAIL" TO WS-TEST-RESULT
           END-IF

      *    BR-ACC-004 : account customer ID matches customer ID
           IF WS-OUT-CUST-ID-MATCH NOT = WS-EXP-CUST-ID-MATCH
               STRING WS-MISMATCH-DETAIL DELIMITED BY SPACE
                   " CUST-ID-MATCH exp=" DELIMITED BY SIZE
                   WS-EXP-CUST-ID-MATCH DELIMITED BY SIZE
                   " got=" DELIMITED BY SIZE
                   WS-OUT-CUST-ID-MATCH DELIMITED BY SIZE
                   INTO WS-MISMATCH-DETAIL
               END-STRING
               MOVE "FAIL" TO WS-TEST-RESULT
           END-IF

      *    BR-ACC-005 : entered last name matches customer last name
           IF WS-OUT-LNAME-MATCH NOT = WS-EXP-LNAME-MATCH
               STRING WS-MISMATCH-DETAIL DELIMITED BY SPACE
                   " LNAME-MATCH exp=" DELIMITED BY SIZE
                   WS-EXP-LNAME-MATCH DELIMITED BY SIZE
                   " got=" DELIMITED BY SIZE
                   WS-OUT-LNAME-MATCH DELIMITED BY SIZE
                   INTO WS-MISMATCH-DETAIL
               END-STRING
               MOVE "FAIL" TO WS-TEST-RESULT
           END-IF

      *    BR-ACC-005 : entered first name matches customer first name
           IF WS-OUT-FNAME-MATCH NOT = WS-EXP-FNAME-MATCH
               STRING WS-MISMATCH-DETAIL DELIMITED BY SPACE
                   " FNAME-MATCH exp=" DELIMITED BY SIZE
                   WS-EXP-FNAME-MATCH DELIMITED BY SIZE
                   " got=" DELIMITED BY SIZE
                   WS-OUT-FNAME-MATCH DELIMITED BY SIZE
                   INTO WS-MISMATCH-DETAIL
               END-STRING
               MOVE "FAIL" TO WS-TEST-RESULT
           END-IF

      *    BR-ACC-006 : source and target accounts are different
           IF WS-OUT-ACCOUNTS-DIFFERENT NOT = WS-EXP-ACCOUNTS-DIFFERENT
               STRING WS-MISMATCH-DETAIL DELIMITED BY SPACE
                   " ACCOUNTS-DIFFERENT exp=" DELIMITED BY SIZE
                   WS-EXP-ACCOUNTS-DIFFERENT DELIMITED BY SIZE
                   " got=" DELIMITED BY SIZE
                   WS-OUT-ACCOUNTS-DIFFERENT DELIMITED BY SIZE
                   INTO WS-MISMATCH-DETAIL
               END-STRING
               MOVE "FAIL" TO WS-TEST-RESULT
           END-IF

      *    Update the running totals with this test case's result
           IF WS-TEST-RESULT = "PASS"
               ADD 1 TO WS-PASSED-TESTS
           ELSE
               ADD 1 TO WS-FAILED-TESTS
           END-IF.

      *-----------------------------------------------------------------
      * Builds and writes one report line: TEST-ID [PASS/FAIL] description
      * followed by the mismatch detail, if any
      *-----------------------------------------------------------------
       WRITE-REPORT-LINE.
           MOVE SPACES TO REPORT-LINE
           STRING WS-TEST-ID    DELIMITED BY SPACE
                   " [" DELIMITED BY SIZE
                   WS-TEST-RESULT DELIMITED BY SIZE
                   "] " DELIMITED BY SIZE
                   FUNCTION TRIM(WS-DESCRIPTION) DELIMITED BY SIZE
                   WS-MISMATCH-DETAIL DELIMITED BY SIZE
                   INTO REPORT-LINE
           END-STRING
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE.

      *-----------------------------------------------------------------
      * Writes the final totals line (TOTAL / PASSED / FAILED) to the
      * report file
      *-----------------------------------------------------------------
       WRITE-SUMMARY.
           MOVE SPACES TO REPORT-LINE
           STRING "-----------------------------------------------"
               DELIMITED BY SIZE INTO REPORT-LINE
           END-STRING
           WRITE REPORT-LINE

           MOVE SPACES TO REPORT-LINE
           STRING "TOTAL="  DELIMITED BY SIZE
                   WS-TOTAL-TESTS   DELIMITED BY SIZE
                   " PASSED=" DELIMITED BY SIZE
                   WS-PASSED-TESTS  DELIMITED BY SIZE
                   " FAILED=" DELIMITED BY SIZE
                   WS-FAILED-TESTS  DELIMITED BY SIZE
                   INTO REPORT-LINE
           END-STRING
           WRITE REPORT-LINE.