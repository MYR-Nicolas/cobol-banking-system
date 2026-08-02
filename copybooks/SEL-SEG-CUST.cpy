      *================================================================*
      *  COPYBOOK  : SEL-SEG-CUST                                      *
      *  PURPOSE   : FILE-CONTROL SELECT CLAUSE FOR SEGMENTATION CUST  *
      *  TYPE      : SELECT (ENVIRONMENT DIVISION)                     *
      *----------------------------------------------------------------*
      *  FILE      : PARAMSEG          ORGANIZATION : VSAM KSDS        *
      *  ACCESS    : RANDOM             KEY : PS-SEGMENT-CODE          *
      *----------------------------------------------------------------*
      *  REQUIRES  : WS-PARAMSEG-STATUS DEFINED IN WORKING-STORAGE     *
      *  INCLUDE IN: FILE-CONTROL (ENVIRONMENT DIVISION)               *
      *----------------------------------------------------------------*
      *  AUTHOR    : N. MAYEUR           CREATED  : 2026-08-02         *
      *----------------------------------------------------------------*
      *  CHANGE LOG                                                    *
      *    DATE        VERS  AUTHOR    DESCRIPTION                     *
      *    2026-08-02  V01   NMAYEUR   INITIAL VERSION                 *
      *================================================================*
           SELECT PARAMSEG
               ASSIGN TO PARAMSEG
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS PS-SEGMENT-CODE
               FILE STATUS IS WS-PARAMSEG-STATUS.