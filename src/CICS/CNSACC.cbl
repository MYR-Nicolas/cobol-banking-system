       IDENTIFICATION DIVISION.
       PROGRAM-ID. CNSCPT.

      * ---------------------------------------
      * PROGRAM-ID  : CNSCPT
      * AUTHOR      : N-MAYEUR
      * OBJECT      : Consult one account.
      * VERSION     : v1.2
      * TEST : 0000000050 LEFEBVRE JEAN
      * ---------------------------------------

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE
               ASSIGN TO "data/accounts_ksds.dat"
               ORGANIZATION IS SEQUENTIAL.

           SELECT CUSTOMERS-KSDS
               ASSIGN TO "data/customers_ksds.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-CUSTOMERS-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD ACCOUNT-FILE.
           COPY ACCOUNT.

       FD CUSTOMERS-KSDS.
           COPY CUSTOMER.

       WORKING-STORAGE SECTION.

       COPY WS-FILE-STATUS.

      ******************************************************************
      * SAVED RECORDS
      ******************************************************************
       COPY ACCOUNT REPLACING 
                       ==ACCOUNT-RECORD== BY ==WS-ACCOUNT-RECORD==.

       COPY CUSTOMER REPLACING 
                       ==CUSTOMER-RECORD== BY ==WS-CUSTOMER-RECORD==.

      ******************************************************************
      * FILE HANDLING FLAGS
      ******************************************************************
       01 WS-EOF-FLAG              PIC X VALUE 'N'.
           88 END-OF-FILE          VALUE 'Y'.
           88 NOT-END              VALUE 'N'.

       01 WS-FOUND-FLAG            PIC X VALUE 'N'.
           88 ACCOUNT-FOUND        VALUE 'Y'.
           88 ACCOUNT-NOT-FOUND    VALUE 'N'.

       01 WS-CUST-EOF-FLAG         PIC X VALUE 'N'.
           88 END-OF-CUST-FILE     VALUE 'Y'.

       01 WS-CUST-FOUND-FLAG       PIC X VALUE 'N'.
           88 CUSTOMER-FOUND       VALUE 'Y'.
           88 CUSTOMER-NOT-FOUND   VALUE 'N'.

      ******************************************************************
      * INPUT DATA
      ******************************************************************
       01 WS-ACCOUNT-SEARCH        PIC X(10).
       01 WS-L-NAME-SEARCH         PIC X(20).
       01 WS-F-NAME-SEARCH         PIC X(20).

      ******************************************************************
      * RULE-ACCOUNT-CTRL INTERFACE
      ******************************************************************
       01 WS-RULE-PGM              PIC X(20) VALUE 'RULE-ACCOUNT-CTRL'.

       01 WS-OPERATION-TYPE        PIC X(10).
       01 WS-TARGET-ACCOUNT        PIC X(10) VALUE SPACES.

          01 WS-RULE-RESULTS.
           05 WS-R-ACC-EXISTS      PIC X.
           05 WS-R-CUST-EXISTS     PIC X.
           05 WS-R-ACC-STATUS      PIC X.
           05 WS-R-CUST-ID-MATCH   PIC X.
           05 WS-R-LNAME-MATCH     PIC X.
           05 WS-R-FNAME-MATCH     PIC X.
           05 WS-R-ACC-DIFFERENT   PIC X.

       01 WS-RULES-OK-FLAG         PIC X VALUE 'Y'.
           88 RULES-OK             VALUE 'Y'.
           88 RULES-KO             VALUE 'N'.

      ******************************************************************
      * DISPLAY EDITING
      ******************************************************************
       01 WS-BALANCE-EDIT          PIC -(12)9.99.

       PROCEDURE DIVISION.

       0000-MAIN-PROCESS.

           PERFORM 1000-INITIALIZE
           PERFORM 2000-GET-INPUT
           PERFORM 3000-PROCESS-FILE
           PERFORM 6000-END-PROGRAMME

           STOP RUN.

       1000-INITIALIZE.

           SET NOT-END            TO TRUE
           SET ACCOUNT-NOT-FOUND  TO TRUE
           SET CUSTOMER-NOT-FOUND TO TRUE
           SET RULES-OK           TO TRUE
           MOVE 'N' TO WS-CUST-EOF-FLAG.

       2000-GET-INPUT.

           DISPLAY "======================================"
           DISPLAY "      ACCOUNT CONSULTATION PROGRAM"
           DISPLAY "======================================"
           DISPLAY "ENTER ACCOUNT NUMBER: " WITH NO ADVANCING
           ACCEPT WS-ACCOUNT-SEARCH
           DISPLAY "ENTER LAST NAME    : " WITH NO ADVANCING
           ACCEPT WS-L-NAME-SEARCH
           DISPLAY "ENTER FIRST NAME   : " WITH NO ADVANCING
           ACCEPT WS-F-NAME-SEARCH.

       3000-PROCESS-FILE.

           OPEN INPUT ACCOUNT-FILE

           PERFORM UNTIL END-OF-FILE OR ACCOUNT-FOUND
              READ ACCOUNT-FILE
                 AT END
                    SET END-OF-FILE TO TRUE
                 NOT AT END
                    IF ACC-NUMBER OF ACCOUNT-RECORD = WS-ACCOUNT-SEARCH
                       SET ACCOUNT-FOUND TO TRUE
                       MOVE ACCOUNT-RECORD TO WS-ACCOUNT-RECORD
                    END-IF
              END-READ
           END-PERFORM

           CLOSE ACCOUNT-FILE

           IF ACCOUNT-NOT-FOUND
               DISPLAY "ACCOUNT NOT FOUND: " WS-ACCOUNT-SEARCH
           ELSE
               PERFORM 3500-READ-CUSTOMER
               IF CUSTOMER-NOT-FOUND
                   DISPLAY "CUSTOMER NOT FOUND: "
                       ACC-CUSTOMER-ID OF WS-ACCOUNT-RECORD
               ELSE
                   PERFORM 4000-RULE-ACCOUNT
                   PERFORM 4500-PROCESS-RULE
                   IF RULES-OK
                       PERFORM 5000-DISPLAY-ACC
                   END-IF
               END-IF
           END-IF.

       3500-READ-CUSTOMER.

           OPEN INPUT CUSTOMERS-KSDS

           PERFORM UNTIL END-OF-CUST-FILE OR CUSTOMER-FOUND
              READ CUSTOMERS-KSDS
                 AT END
                    SET END-OF-CUST-FILE TO TRUE
                 NOT AT END
                    IF CUST-ID OF CUSTOMER-RECORD
                       = ACC-CUSTOMER-ID OF WS-ACCOUNT-RECORD
                       SET CUSTOMER-FOUND TO TRUE
                       MOVE CUSTOMER-RECORD TO WS-CUSTOMER-RECORD
                    END-IF
              END-READ
           END-PERFORM

           CLOSE CUSTOMERS-KSDS.

       4000-RULE-ACCOUNT.

           MOVE 'CONSULT' TO WS-OPERATION-TYPE

           CALL WS-RULE-PGM USING WS-OPERATION-TYPE
                                  WS-FOUND-FLAG
                                  WS-CUST-FOUND-FLAG
                                  ACC-NUMBER      OF WS-ACCOUNT-RECORD
                                  ACC-STATUS      OF WS-ACCOUNT-RECORD
                                  ACC-CUSTOMER-ID OF WS-ACCOUNT-RECORD
                                  CUST-ID         OF WS-CUSTOMER-RECORD
                                  CUST-LAST-NAME  OF WS-CUSTOMER-RECORD
                                  CUST-FIRST-NAME OF WS-CUSTOMER-RECORD
                                  WS-L-NAME-SEARCH
                                  WS-F-NAME-SEARCH
                                  WS-TARGET-ACCOUNT
                                  WS-R-ACC-EXISTS
                                  WS-R-CUST-EXISTS
                                  WS-R-ACC-STATUS
                                  WS-R-CUST-ID-MATCH
                                  WS-R-LNAME-MATCH
                                  WS-R-FNAME-MATCH
                                  WS-R-ACC-DIFFERENT
               ON EXCEPTION
                   DISPLAY "ERROR: MODULE " WS-RULE-PGM " NOT FOUND"
                   SET RULES-KO TO TRUE
           END-CALL.

       4500-PROCESS-RULE.

           SET RULES-OK TO TRUE

           IF WS-R-ACC-STATUS = 'N'
               SET RULES-KO TO TRUE
               DISPLAY "ERROR: ACCOUNT IS NOT ACTIVE"
           END-IF

           IF WS-R-CUST-ID-MATCH = 'N'
               SET RULES-KO TO TRUE
               DISPLAY "ERROR: CUSTOMER ID MISMATCH"
           END-IF

           IF WS-R-LNAME-MATCH = 'N'
               SET RULES-KO TO TRUE
               DISPLAY "ERROR: LAST NAME MISMATCH"
           END-IF

           IF WS-R-FNAME-MATCH = 'N'
               SET RULES-KO TO TRUE
               DISPLAY "ERROR: FIRST NAME MISMATCH"
           END-IF.

       5000-DISPLAY-ACC.

           MOVE ACC-BALANCE OF WS-ACCOUNT-RECORD TO WS-BALANCE-EDIT

           DISPLAY "----------------------------"
           DISPLAY "ACCOUNT : " ACC-NUMBER OF WS-ACCOUNT-RECORD
           DISPLAY "CUSTOMER: " ACC-CUSTOMER-ID OF WS-ACCOUNT-RECORD
           DISPLAY "NAME    : " CUST-FIRST-NAME OF WS-CUSTOMER-RECORD
                                " " CUST-LAST-NAME OF WS-CUSTOMER-RECORD
           DISPLAY "TYPE    : " ACC-TYPE OF WS-ACCOUNT-RECORD
           DISPLAY "BALANCE : " WS-BALANCE-EDIT
           DISPLAY "OPEN DT : " ACC-OPEN-DATE OF WS-ACCOUNT-RECORD.

       6000-END-PROGRAMME.

           DISPLAY "======================================"
           DISPLAY "END OF PROCESSING"
           DISPLAY "======================================".