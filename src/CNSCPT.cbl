IDENTIFICATION DIVISION.
PROGRAM-ID. CNSCPT.

*> ---------------------------------------
*> PROGRAM-ID  : CNSCPT
*> AUTHOR      : N-MAYEUR
*> OBJECT      : Consult one account.
*> VERSION     : v1.0
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
01 WS-EOF-FLAG        PIC X VALUE 'N'.
   88 END-OF-FILE     VALUE 'Y'.
   88 NOT-END         VALUE 'N'.

01 WS-ACCOUNT-SEARCH  PIC X(10).
01 WS-FOUND-FLAG      PIC X VALUE 'N'.
   88 ACCOUNT-FOUND   VALUE 'Y'.
   88 ACCOUNT-NOT-FOUND VALUE 'N'.

PROCEDURE DIVISION.

MAIN-PROCESS.

    DISPLAY "======================================"
    DISPLAY "      ACCOUNT CONSULTATION PROGRAM"
    DISPLAY "======================================"

    DISPLAY "ENTER ACCOUNT NUMBER: "
    ACCEPT WS-ACCOUNT-SEARCH

    OPEN INPUT ACCOUNT-FILE

    PERFORM UNTIL END-OF-FILE OR ACCOUNT-FOUND
        READ ACCOUNT-FILE
            AT END
                MOVE 'Y' TO WS-EOF-FLAG
            NOT AT END
                IF ACC-NUMBER = WS-ACCOUNT-SEARCH
                    MOVE 'Y' TO WS-FOUND-FLAG
                    DISPLAY "----------------------------"
                    DISPLAY "ACCOUNT : " ACC-NUMBER
                    DISPLAY "CUSTOMER: " ACC-CUSTOMER-ID
                    DISPLAY "TYPE    : " ACC-TYPE
                    DISPLAY "BALANCE : " ACC-BALANCE
                    DISPLAY "OPEN DT : " ACC-OPEN-DATE
                END-IF
        END-READ
    END-PERFORM

    CLOSE ACCOUNT-FILE

    IF ACCOUNT-NOT-FOUND
        DISPLAY "ACCOUNT NOT FOUND: " WS-ACCOUNT-SEARCH
    END-IF

    DISPLAY "======================================"
    DISPLAY "END OF PROCESSING"
    DISPLAY "======================================"

    STOP RUN.