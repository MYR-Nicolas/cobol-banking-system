       IDENTIFICATION DIVISION.
       PROGRAM-ID. DEPOT.

      * ---------------------------------------
      * PROGRAM-ID  : DEPOT
      * AUTHOR      : N-MAYEUR
      * OBJECT      : Deposit money into an account.
      * VERSION     : v1.0
      * ---------------------------------------

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE
               ASSIGN TO "data/comptes.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT TEMP-ACCOUNT-FILE
               ASSIGN TO "data/comptes.tmp"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  ACCOUNT-FILE.
       COPY ACCOUNT.

       FD  TEMP-ACCOUNT-FILE.
       01  TEMP-ACCOUNT-RECORD       PIC X(46).

       WORKING-STORAGE SECTION.

       01  WS-EOF-FLAG               PIC X VALUE 'N'.
           88  END-OF-FILE           VALUE 'Y'.
           88  NOT-END               VALUE 'N'.

       01  WS-ACCOUNT-SEARCH         PIC X(10).

       01  WS-DEPOSIT-AMOUNT         PIC 9(9)V99.

       01  WS-FOUND-FLAG             PIC X VALUE 'N'.
           88  ACCOUNT-FOUND         VALUE 'Y'.
           88  ACCOUNT-NOT-FOUND     VALUE 'N'.

       01  WS-VALID-FLAG             PIC X VALUE 'Y'.
           88  VALID-DATA            VALUE 'Y'.
           88  INVALID-DATA          VALUE 'N'.

       PROCEDURE DIVISION.

       0000-MAIN-PROCESS.

           PERFORM 1000-INITIALIZE
           PERFORM 1100-INPUT-AMT
           PERFORM 2000-PROC-DEPOSIT
           PERFORM 3000-END-PROG

           STOP RUN.

       1000-INITIALIZE.

           SET NOT-END TO TRUE
           SET ACCOUNT-NOT-FOUND TO TRUE
           SET VALID-DATA TO TRUE.

       1100-INPUT-AMT.

           DISPLAY "======================================"
           DISPLAY "          DEPOSIT PROGRAM"
           DISPLAY "======================================"

           DISPLAY "ENTER ACCOUNT NUMBER: "
           ACCEPT WS-ACCOUNT-SEARCH

           DISPLAY "ENTER DEPOSIT AMOUNT: "
           ACCEPT WS-DEPOSIT-AMOUNT.

       2000-PROC-DEPOSIT.

           IF WS-DEPOSIT-AMOUNT <= 0
               SET INVALID-DATA TO TRUE
               DISPLAY "INVALID AMOUNT"
           END-IF

           IF VALID-DATA

               OPEN INPUT ACCOUNT-FILE
               OPEN OUTPUT TEMP-ACCOUNT-FILE

               PERFORM UNTIL END-OF-FILE

                   READ ACCOUNT-FILE

                       AT END
                           SET END-OF-FILE TO TRUE

                       NOT AT END

                           IF ACC-NUMBER = WS-ACCOUNT-SEARCH
                               SET ACCOUNT-FOUND TO TRUE
                               ADD WS-DEPOSIT-AMOUNT TO ACC-BALANCE
                               DISPLAY "DEPOSIT ACCEPTED"
                               DISPLAY "NEW BALANCE: " ACC-BALANCE
                           END-IF

                           WRITE TEMP-ACCOUNT-RECORD
                               FROM ACCOUNT-RECORD

                   END-READ

               END-PERFORM

               CLOSE ACCOUNT-FILE
               CLOSE TEMP-ACCOUNT-FILE

               IF ACCOUNT-NOT-FOUND
                   DISPLAY "ACCOUNT NOT FOUND: " WS-ACCOUNT-SEARCH
                   DISPLAY "TEMP FILE CREATED WITHOUT UPDATE"
               ELSE
                   DISPLAY "ACCOUNT FILE UPDATED IN data/comptes.tmp"
               END-IF

           END-IF.

       3000-END-PROG.

           DISPLAY "======================================"
           DISPLAY "END OF PROCESSING"
           DISPLAY "======================================".
           