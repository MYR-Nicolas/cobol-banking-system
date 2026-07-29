      *================================================================*
      *  COPYBOOK  : SEL-TRX                                           *
      *  PURPOSE   : FILE-CONTROL SELECT CLAUSE FOR TRANSACTIONS       *
      *  TYPE      : SELECT (ENVIRONMENT DIVISION)                     *
      *----------------------------------------------------------------*
      *  FILE      : TRANSACTIONS_KSDS.DAT   ORGANIZATION : VSAM KSDS  *
      *  ACCESS    : DYNAMIC              KEY : TRX-ID                 *
      *----------------------------------------------------------------*
      *  REQUIRES  : WS-TRANSACTIONS-STATUS DEFINED IN WORKING-STORAGE *
      *  INCLUDE IN: FILE-CONTROL (ENVIRONMENT DIVISION)               *
      *----------------------------------------------------------------*
      *  AUTHOR    : N. MAYEUR           CREATED  : 2026-07-29         *
      *----------------------------------------------------------------*
      *  CHANGE LOG                                                    *
      *    DATE        VERS  AUTHOR    DESCRIPTION                     *
      *    2026-07-29  V01   NMAYEUR   INITIAL VERSION                 *
      *================================================================*
           SELECT TRANSACTIONS-KSDS
               ASSIGN TO 'TRANSACTIONS_KSDS.DAT'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS TRX-ID
               ALTERNATE RECORD KEY IS TRX-ACC-FROM
                   WITH DUPLICATES
               ALTERNATE RECORD KEY IS TRX-ACC-TO
                   WITH DUPLICATES
               FILE STATUS IS WS-TRANSACTIONS-STATUS.