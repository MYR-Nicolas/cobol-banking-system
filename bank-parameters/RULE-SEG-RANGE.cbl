      *****************************************************************
      * Program name:    RULE-SEG-RANGE
      * Original author: NMAYEUR
      *
      * Maintenance Log
      * Date        Author    Maintenance Requirement
      * ----------- --------  ---------------------------------------
      * 2026/08/02  NMAYEUR   Initial version
      *
      *****************************************************************
      * Business rules covered :
      *
      * BR-SEG-001 The amount must be greater than or equal to the
      *            minimum defined for the customer segment and
      *            operation type.
      *
      * BR-SEG-002 The amount must be less than or equal to the
      *            maximum defined for the customer segment and
      *            operation type.
      *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID  RULE-SEG-RANGE.
       AUTHOR NMAYEUR.
       INSTALLATION COBOL DEVELOPMENT CENTER.
       DATE-WRITTEN 2026/08/02.
       SECURITY NON-CONFIDENTIAL.
      *****************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *-----------------------------------------------------------------
      * Local working storage variables
      *-----------------------------------------------------------------
       01  WS-SELECTED-MIN              PIC S9(11)V99.
       01  WS-SELECTED-MAX              PIC S9(11)V99.

       LINKAGE SECTION.
      *-----------------------------------------------------------------
      * Input data
      *-----------------------------------------------------------------
       01  LK-SEG-VALUE-CHECK            PIC S9(11)V99 COMP-3.

       01  LK-OPERATION-TYPE             PIC X(02).
           88  LK-OP-DEPOSIT             VALUE 'DP'.
           88  LK-OP-WITHDRAWAL          VALUE 'WD'.
           88  LK-OP-TRANSFER            VALUE 'TR'.
           88  LK-OP-BALANCE             VALUE 'BL'.

       COPY SEG-CUSTOMER.

      *-----------------------------------------------------------------
      * Output - result flag
      *-----------------------------------------------------------------
       01  LK-RANGE-FLAG                 PIC X.
           88  LK-RANGE-VALID            VALUE 'Y'.
           88  LK-RANGE-NOT-VALID        VALUE 'N'.

       PROCEDURE DIVISION USING LK-SEG-VALUE-CHECK
                                 LK-OPERATION-TYPE
                                 SEG-PARAM-RECORD
                                 LK-RANGE-FLAG.

       MAIN.

           PERFORM SELECT-BOUNDS.
           PERFORM CHECK-RANGE.
           GOBACK.

       SELECT-BOUNDS.

           EVALUATE TRUE
               WHEN LK-OP-DEPOSIT
                   MOVE PS-MIN-DEPOSIT    TO WS-SELECTED-MIN
                   MOVE PS-MAX-DEPOSIT    TO WS-SELECTED-MAX
               WHEN LK-OP-WITHDRAWAL
                   MOVE PS-MIN-WITHDRAWAL TO WS-SELECTED-MIN
                   MOVE PS-MAX-WITHDRAWAL TO WS-SELECTED-MAX
               WHEN LK-OP-TRANSFER
                   MOVE PS-MIN-TRANSFER   TO WS-SELECTED-MIN
                   MOVE PS-MAX-TRANSFER   TO WS-SELECTED-MAX
               WHEN LK-OP-BALANCE
                   MOVE ZERO               TO WS-SELECTED-MIN
                   MOVE PS-MAX-BALANCE    TO WS-SELECTED-MAX
               WHEN OTHER
                  
                   MOVE ZERO               TO WS-SELECTED-MIN
                   MOVE ZERO               TO WS-SELECTED-MAX
           END-EVALUATE.

       CHECK-RANGE.

           EVALUATE TRUE
               WHEN LK-SEG-VALUE-CHECK >= WS-SELECTED-MIN
                AND LK-SEG-VALUE-CHECK <= WS-SELECTED-MAX
                   SET LK-RANGE-VALID     TO TRUE
               WHEN OTHER
                   SET LK-RANGE-NOT-VALID TO TRUE
           END-EVALUATE.

       

       