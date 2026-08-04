      *================================================================*
      *  COPYBOOK  : SEL-ACC                                      *
      *  PURPOSE   : FILE-CONTROL SELECT CLAUSE FOR ACCOUNTS           *
      *  TYPE      : SELECT (ENVIRONMENT DIVISION)                     *
      *----------------------------------------------------------------*
      *  FILE      : ACCOUNTS_KSDS.DAT   ORGANIZATION : VSAM KSDS      *
      *  ACCESS    : DYNAMIC             KEY : ACC-NUMBER              *
      *----------------------------------------------------------------*
      *  REQUIRES  : WS-ACCOUNTS-STATUS DEFINED IN WORKING-STORAGE     *
      *  INCLUDE IN: FILE-CONTROL (ENVIRONMENT DIVISION)               *
      *----------------------------------------------------------------*
      *  AUTHOR    : N. MAYEUR           CREATED  : 2026-07-29         *
      *----------------------------------------------------------------*
      *  CHANGE LOG                                                    *
      *    DATE        VERS  AUTHOR    DESCRIPTION                     *
      *    2026-07-29  V01   NMAYEUR   INITIAL VERSION                 *
      *================================================================*
           SELECT ACCOUNTS-KSDS
               ASSIGN TO 'data/accounts_ksds.dat'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS ACC-NUMBER
               FILE STATUS IS WS-ACCOUNTS-STATUS .
           