      *================================================================*
      *  COPYBOOK  : WS-FILE-STATUS                                    *
      *  PURPOSE   : FILE STATUS VARIABLES FOR ALL VSAM FILES          *
      *  TYPE      : WORKING-STORAGE                                   *
      *----------------------------------------------------------------*
      *  FILES COVERED : ACCOUNTS, CUSTOMERS, TRANSACTIONS             *
      *----------------------------------------------------------------*
      *  REQUIRES  : NONE                                              *
      *  INCLUDE IN: WORKING-STORAGE SECTION                           *
      *----------------------------------------------------------------*
      *  AUTHOR    : N. MAYEUR           CREATED  : 2026-07-29         *
      *----------------------------------------------------------------*
      *  CHANGE LOG                                                    *
      *    DATE        VERS  AUTHOR    DESCRIPTION                     *
      *    2026-07-29  V01   NMAYEUR   INITIAL VERSION                 *
      *================================================================*
       01  WS-FILE-STATUS-GROUP.

           05  WS-ACCOUNTS-STATUS          PIC X(02).
               88  ACCOUNTS-OK                 VALUE '00'.
               88  ACCOUNTS-DUPLICATE          VALUE '22'.
               88  ACCOUNTS-NOT-FOUND          VALUE '23'.
               88  ACCOUNTS-EOF                VALUE '10'.
               88  ACCOUNTS-INVALID-KEY        VALUE '21' '23'.

           05  WS-CUSTOMERS-STATUS         PIC X(02).
               88  CUSTOMERS-OK                VALUE '00'.
               88  CUSTOMERS-DUPLICATE         VALUE '22'.
               88  CUSTOMERS-NOT-FOUND         VALUE '23'.
               88  CUSTOMERS-EOF               VALUE '10'.
               88  CUSTOMERS-INVALID-KEY       VALUE '21' '23'.

           05  WS-TRANSACTIONS-STATUS      PIC X(02).
               88  TRANSACTIONS-OK             VALUE '00'.
               88  TRANSACTIONS-DUPLICATE      VALUE '22'.
               88  TRANSACTIONS-NOT-FOUND      VALUE '23'.
               88  TRANSACTIONS-EOF            VALUE '10'.
               88  TRANSACTIONS-INVALID-KEY    VALUE '21' '23'.