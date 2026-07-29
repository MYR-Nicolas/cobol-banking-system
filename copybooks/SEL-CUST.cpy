      *================================================================*
      *  COPYBOOK  : SEL-CUST                                          *
      *  PURPOSE   : FILE-CONTROL SELECT CLAUSE FOR CUSTOMERS          *
      *  TYPE      : SELECT (ENVIRONMENT DIVISION)                     *
      *----------------------------------------------------------------*
      *  FILE      : CUSTOMERS_KSDS.DAT   ORGANIZATION : VSAM KSDS     *
      *  ACCESS    : DYNAMIC              KEY : CUST-ID                *
      *----------------------------------------------------------------*
      *  REQUIRES  : WS-CUSTOMERS-STATUS DEFINED IN WORKING-STORAGE    *
      *  INCLUDE IN: FILE-CONTROL (ENVIRONMENT DIVISION)               *
      *----------------------------------------------------------------*
      *  AUTHOR    : N. MAYEUR           CREATED  : 2026-07-29         *
      *----------------------------------------------------------------*
      *  CHANGE LOG                                                    *
      *    DATE        VERS  AUTHOR    DESCRIPTION                     *
      *    2026-07-29  V01   NMAYEUR   INITIAL VERSION                 *
      *================================================================*
           SELECT CUSTOMERS-KSDS
               ASSIGN TO 'CUSTOMERS_KSDS.DAT'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS CUST-ID
               FILE STATUS IS WS-CUSTOMERS-STATUS.