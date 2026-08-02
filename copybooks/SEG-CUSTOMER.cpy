      *================================================================*
      *  COPYBOOK  : SEG-CUSTOMER                                      *
      *  PURPOSE   : CUSTOMER SEGMENTATION                             *
      *  TYPE      : RECORD                                            *
      *----------------------------------------------------------------*
      *  FILE      : PARAMSEG           ORGANIZATION : VSAM KSDS       *
      *  LRECL     : 128              KEY : PS-SEGMENT-CODE POS 1 LEN 8*
      *----------------------------------------------------------------*
      *  REQUIRES  : NONE                                              *
      *  INCLUDE IN: FILE SECTION OR LINKAGE SECTION                   *
      *----------------------------------------------------------------*
      *  AUTHOR    : N. MAYEUR           CREATED  : 2026-08-01         *
      *----------------------------------------------------------------*
      *  CHANGE LOG                                                    *
      *    DATE        VERS  AUTHOR    DESCRIPTION                     *
      *    2026-08-01  V01   NMAYEUR   INITIAL VERSION.                *
      *================================================================*
       01  SEG-PARAM-RECORD.
           05  SEG-CUST.
               10  PS-SEGMENT-CODE           PIC X(08).
               10  PS-SEGMENT-LABEL          PIC X(30).

           05  SEG-DEPOSIT.
               10  PS-MIN-DEPOSIT            PIC 9(09)V99.
               10  PS-MAX-DEPOSIT            PIC 9(09)V99.

           05  SEG-WITHDRAWAL.
               10  PS-MIN-WITHDRAWAL         PIC 9(09)V99.
               10  PS-MAX-WITHDRAWAL         PIC 9(09)V99.
               10  PS-FREE-WITHDRAWALS       PIC 9(03).
               10  PS-FREE-WITHDR-FLAG       PIC X(01).
                   88  PS-FREE-WITHDR-UNLIMITED-YES  VALUE 'Y'.
                   88  PS-FREE-WITHDR-UNLIMITED-NO   VALUE 'N'.
               10  PS-WITHDRAWAL-FEE         PIC 9(05)V99.

           05  SEG-TRANSFER.
               10  PS-MIN-TRANSFER           PIC 9(09)V99.
               10  PS-MAX-TRANSFER           PIC 9(09)V99.

           05  SEG-BALANCE.
               10  PS-MAX-BALANCE            PIC 9(11)V99.
    
