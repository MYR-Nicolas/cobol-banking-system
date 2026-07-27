      *================================================================*
      *  COPYBOOK  : CUSTOMER                                          *
      *  PURPOSE   : CUSTOMER RECORD                                   *
      *  TYPE      : RECORD                                            *
      *----------------------------------------------------------------*
      *  FILE      : CLIENTS             ORGANIZATION : VSAM KSDS      *
      *  LRECL     : 077                 KEY : CUST-ID POS 1 LEN 7     *
      *----------------------------------------------------------------*
      *  REQUIRES  : NONE                                              *
      *  INCLUDE IN: FILE SECTION OR LINKAGE SECTION                   *
      *----------------------------------------------------------------*
      *  AUTHOR    : N. MAYEUR           CREATED  : 2026-07-20         *
      *----------------------------------------------------------------*
      *  CHANGE LOG                                                    *
      *    DATE        VERS  AUTHOR    DESCRIPTION                     *
      *    2026-07-20  V01   NMAYEUR   INITIAL VERSION.                *
      *    2026-07-27  V02   NMAYEUR   ADD CUST-SEGMENT.               *
      *================================================================*
       01  CUSTOMER-RECORD.
           05  CUST-ID             PIC X(07).
           05  CUST-LAST-NAME      PIC X(20).
           05  CUST-FIRST-NAME     PIC X(20).
           05  CUST-CITY           PIC X(20).
           05  CUST-SEGMENT        PIC X(10).
               88  SEG-STANDARD        VALUE 'STANDARD'.
               88  SEG-PREMIUM         VALUE 'PREMIUM'.
               88  SEG-PROFESSIONAL    VALUE 'PRO'.
               88  SEG-YOUTH           VALUE 'JEUNE'.
               88  SEG-VALID           VALUE 'STANDARD' 'PREMIUM'
                                             'PRO' 'JEUNE'.
           