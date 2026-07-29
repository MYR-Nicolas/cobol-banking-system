      *================================================================*
      *  COPYBOOK  : ACCOUNT                                           *
      *  PURPOSE   : BANK ACCOUNT RECORD                               *
      *  TYPE      : RECORD                                            *
      *----------------------------------------------------------------*
      *  FILE      : COMPTES             ORGANIZATION : VSAM KSDS      *
      *  LRECL     : 042                 KEY : ACC-NUMBER POS 1 LEN 10 *
      *----------------------------------------------------------------*
      *  REQUIRES  : NONE                                              *
      *  INCLUDE IN: FILE SECTION                                      *
      *----------------------------------------------------------------*
      *  AUTHOR    : N. MAYEUR           CREATED  : 2026-07-20         *
      *----------------------------------------------------------------*
      *  CHANGE LOG                                                    *
      *    DATE        VERS  AUTHOR    DESCRIPTION                     *
      *    2026-07-20  V01   NMAYEUR   INITIAL VERSION                 *
      *    2026-07-26  V02   NMAYEUR   ADDED ACC-STATUS                *
      *================================================================*
       01  ACCOUNT-RECORD.
           05  ACC-NUMBER          PIC X(10).
           05  ACC-CUSTOMER-ID     PIC X(07).
           05  ACC-TYPE            PIC X(10).
               88  ACC-CURRENT         VALUE 'COURANT'.
               88  ACC-SAVINGS         VALUE 'EPARGNE'.
               88  ACC-TYPE-VALID      VALUE 'COURANT' 'EPARGNE'.
           05  ACC-BALANCE         PIC S9(09)V99 COMP-3.
           05  ACC-OPEN-DATE       PIC 9(08).
           05  ACC-STATUS          PIC X(01).
               88  ACC-ACTIVE          VALUE 'A'.
               88  ACC-SUSPENDED       VALUE 'S'.
               88  ACC-CLOSED          VALUE 'C'.
               88  ACC-STATUS-VALID    VALUE 'A' 'S' 'C'.
           