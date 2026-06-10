IDENTIFICATION DIVISION.
PROGRAM-ID. LSTCPT.

*> ---------------------------------------
*> PROGRAM-ID  : LSTCPT
*> AUTHOR      : N-MAYEUR
*> DATE-WRITEN : 20260609
*> OBJECT      : List all accounts.
*> VERSION     : v1.0
*> ---------------------------------------
*> VERSION HISTORY
*> v1.0 09/06/2026 initialization.
*> ---------------------------------------

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

MAIN-PROCESS.

    OPEN INPUT ACCOUNT-FILE

    DISPLAY "======================================"
    DISPLAY "      ACCOUNT LISTING PROGRAM"
    DISPLAY "======================================"

    PERFORM UNTIL END-OF-FILE
        READ ACCOUNT-FILE
            AT END
                MOVE 'Y' TO WS-EOF-FLAG
            NOT AT END
                DISPLAY "----------------------------"
                DISPLAY "ACCOUNT : " ACC-NUMBER
                DISPLAY "CUSTOMER: " ACC-CUSTOMER-ID
                DISPLAY "TYPE    : " ACC-TYPE
                DISPLAY "BALANCE : " ACC-BALANCE
                DISPLAY "OPEN DT : " ACC-OPEN-DATE
        END-READ
    END-PERFORM

    CLOSE ACCOUNT-FILE

    DISPLAY "======================================"
    DISPLAY "END OF PROCESSING"
    DISPLAY "======================================"

    STOP RUN.