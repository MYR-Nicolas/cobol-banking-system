      *================================================================*
      *  COPYBOOK  : TRANSACTION                                       *
      *  PURPOSE   : ACCOUNT MOVEMENT RECORD                           *
      *  TYPE      : RECORD                                            *
      *----------------------------------------------------------------*
      *  FILE      : TRANSACTION             ORGANIZATION : VSAM KSDS      *
      *  LRECL     : 071                 KEY : TRX-ID POS 1 LEN 9      *
      *----------------------------------------------------------------*
      *  REQUIRES  : NONE                                              *
      *  INCLUDE IN: FILE SECTION OR LINKAGE SECTION                   *
      *----------------------------------------------------------------*
      *  AUTHOR    : N. MAYEUR           CREATED  : 2026-07-20         *
      *----------------------------------------------------------------*
      *  CHANGE LOG                                                    *
      *    DATE        VERS  AUTHOR    DESCRIPTION                     *
      *    2026-07-20  V01   NMAYEUR   INITIAL VERSION.                *
      *    2026-07-27  V02   NMAYEUR   ADD TRX-BENEFICIARY-NAME,       *
      *================================================================*

       01 TRANSACTION-RECORD.
           05  TRX-ID              PIC X(09).
           05  TRX-DATE            PIC 9(08).
           05  TRX-TYPE            PIC X(08).
               88  TRX-TRANSFER        VALUE 'VIREMENT'.
               88  TRX-DEPOSIT         VALUE 'DEPOT'.
               88  TRX-WITHDRAWAL      VALUE 'RETRAIT'.
               88  TRX-TYPE-VALID      VALUE 'VIREMENT' 'DEPOT' 
                                             'RETRAIT'.
           05  TRX-ACC-FROM        PIC X(10).
           05  TRX-ACC-TO          PIC X(10).
               88  TRX-ACC-TO-EMPTY    VALUE SPACES.
           05  TRX-AMOUNT          PIC S9(09)V99 COMP-3.
           05  TRX-BENEFICIARY-NAME PIC X(20).
               88  TRX-BEN-EMPTY       VALUE SPACES.
           