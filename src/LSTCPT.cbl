       IDENTIFICATION DIVISION.
       PROGRAM-ID. LSTCPT.

      * ---------------------------------------
      * PROGRAM-ID  : LSTCPT
      * AUTHOR      : N-MAYEUR
      * DATE-WRITEN : 20260609
      * OBJECT      : List all accounts.
      * VERSION     : v1.0
      * ---------------------------------------
      * VERSION HISTORY
      * v1.0 09/06/2026 initialization.
      * ---------------------------------------

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE
           ASSIGN TO "data/comptes.dat"
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD ACCOUNT-FILE.
           COPY ACCOUNT.

       WORKING-STORAGE SECTION.
       01 WS-EOF-FLAG      PIC X VALUE 'N'.
           88 END-OF-FILE   VALUE 'Y'.
           88 NOT-END       VALUE 'N'.

       PROCEDURE DIVISION.

       0000-MAIN-PROCESS.
           PERFORM 1000-INITIALIZE
           PERFORM 2000-PROC-LIST
           PERFORM 4000-END-PROG
           STOP RUN.

       1000-INITIALIZE.
           MOVE 'N' TO WS-EOF-FLAG.
       
       2000-PROC-LIST.

           OPEN INPUT ACCOUNT-FILE

           PERFORM UNTIL END-OF-FILE
            READ ACCOUNT-FILE
              AT END
                 MOVE 'Y' TO WS-EOF-FLAG
              NOT AT END
                 PERFORM 3000-DISPLAY-LIST
      
           END-READ
           END-PERFORM.
          

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
           CLOSE ACCOUNT-FILE

           DISPLAY "======================================"
           DISPLAY "END OF PROCESSING"
           DISPLAY "======================================".

          