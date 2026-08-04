
      * ---------------------------------------
      * PROGRAM-ID  : LSTCPT
      * AUTHOR      : N-MAYEUR
      * DATE-WRITEN : 20260609
      * OBJECT      : List all accounts.
      * VERSION     : v2.0
      * ---------------------------------------
      * VERSION HISTORY
      * v1.0 09/06/2026 initialization.
      * v2.0 2026/08/04 optimization with implementation copybook.
      * ---------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. LSTACC.


       ENVIRONMENT DIVISION.


       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY SEL-ACC.

       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNTS-KSDS.
           COPY ACCOUNT.

       WORKING-STORAGE SECTION.
           COPY WS-FILE-STATUS.

       PROCEDURE DIVISION.

       0000-MAIN-PROCESS.

           PERFORM 1000-INITIALIZE
           PERFORM 2000-PROC-LIST
           PERFORM 4000-END-PROG

           STOP RUN.

       1000-INITIALIZE.

           MOVE SPACES TO WS-ACCOUNTS-STATUS.

       2000-PROC-LIST.

           OPEN INPUT ACCOUNTS-KSDS

           IF NOT ACCOUNTS-OK
               DISPLAY "ERROR OPENING ACCOUNTS-KSDS - STATUS: "
                       WS-ACCOUNTS-STATUS
           ELSE
               PERFORM UNTIL ACCOUNTS-EOF
                   READ ACCOUNTS-KSDS
                       AT END
                           CONTINUE
                       NOT AT END
                           PERFORM 3000-DISPLAY-LIST
                   END-READ
               END-PERFORM
           END-IF.

       3000-DISPLAY-LIST.

           DISPLAY "======================================"
           DISPLAY "      ACCOUNT LISTING PROGRAM"
           DISPLAY "======================================"
           DISPLAY "ACCOUNT : " ACC-NUMBER
           DISPLAY "CUSTOMER: " ACC-CUSTOMER-ID
           DISPLAY "TYPE    : " ACC-TYPE
           DISPLAY "BALANCE : " ACC-BALANCE
           DISPLAY "OPEN DT : " ACC-OPEN-DATE.

       4000-END-PROG.

           IF ACCOUNTS-OK OR ACCOUNTS-EOF
               CLOSE ACCOUNTS-KSDS
           END-IF

           DISPLAY "======================================"
           DISPLAY "END OF PROCESSING"
           DISPLAY "======================================".