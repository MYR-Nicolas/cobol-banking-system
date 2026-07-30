      *****************************************************************
      * Program name:    RULE-ACCOUNT-CTRL                               
      * Original author: NMAYEUR                                
      *
      * Maintenence Log                                              
      * Date      Author        Maintenance Requirement               
      * --------- ------------  --------------------------------------- 
      * 22/07/26 NMAYEUR      
      *                                                               
      *****************************************************************
      * Business rules covered :
      *
      * BR-ACC-001  The account must exist.
      *             
      *
      * BR-ACC-002  The customer must exist.
      *             
      *
      * BR-ACC-003  The account must be active.
      *             
      *
      * BR-ACC-004  The account customer ID must match an existing
      *             customer ID.
      *            
      *
      * BR-ACC-005  The entered last name and first name must match
      *             the customer linked to the account.
      *             
      *
      * BR-ACC-006  The source and target accounts must be different.
      *             
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  RULE-ACCOUNT-CTRL.
       AUTHOR. NMAYEUR. 
       INSTALLATION. COBOL DEVELOPMENT CENTER. 
       DATE-WRITTEN. 22/07/26. 
       SECURITY. NON-CONFIDENTIAL.
      *****************************************************************

          
       ENVIRONMENT DIVISION.

       DATA DIVISION. 
       WORKING-STORAGE SECTION. 

       LINKAGE SECTION.
      *-----------------------------------------------------------------
      * Operation type - drives which checks are performed
      *-----------------------------------------------------------------
       01  LK-OPERATION-TYPE          PIC X(10).
           88  OP-DEPOSIT                      VALUE 'DEPOSIT'.
           88  OP-WITHDRAW                     VALUE 'WITHDRAW'.
           88  OP-TRANSFER                     VALUE 'TRANSFER'.
           88  OP-CONSULT                      VALUE 'CONSULT'.

      *-----------------------------------------------------------------
      * Input data - result of the caller's file reads
      *-----------------------------------------------------------------
       01  LK-ACCOUNT-FOUND-FLAG      PIC X.
           88  LK-ACCOUNT-FOUND               VALUE 'Y'.
           88  LK-ACCOUNT-NOT-FOUND           VALUE 'N'.

       01  LK-CUSTOMER-FOUND-FLAG     PIC X.
           88  LK-CUSTOMER-FOUND              VALUE 'Y'.
           88  LK-CUSTOMER-NOT-FOUND          VALUE 'N'.

      *-----------------------------------------------------------------
      * Input data - account and customer already read by the caller
      *-----------------------------------------------------------------
       01  LK-ACCOUNT-NUMBER          PIC X(10).
       01  LK-ACCOUNT-STATUS          PIC X(01).
           88  LK-IN-ACCOUNT-IS-ACTIVE         VALUE 'A'.
       01  LK-ACCOUNT-CUSTOMER-ID     PIC X(07).

       01  LK-CUSTOMER-ID             PIC X(07).
       01  LK-CUSTOMER-LAST-NAME      PIC X(20).
       01  LK-CUSTOMER-FIRST-NAME     PIC X(20).

      *-----------------------------------------------------------------
      * Input data - entered by the requester (name matching, CONSULT)
      *-----------------------------------------------------------------
       01  LK-ENTERED-LAST-NAME       PIC X(20).
       01  LK-ENTERED-FIRST-NAME      PIC X(20).

      *-----------------------------------------------------------------
      * Input data - transfer only (target account)
      *-----------------------------------------------------------------
       01  LK-TARGET-ACCOUNT-NUMBER   PIC X(10).

      *-----------------------------------------------------------------
      * Output - individual result flags (one per business rule)
      *-----------------------------------------------------------------
       01  LK-ACCOUNT-EXISTS-FLAG     PIC X.
           88  LK-ACCOUNT-EXISTS              VALUE 'Y'.
           88  LK-ACCOUNT-NOT-EXISTS          VALUE 'N'.
           88  LK-ACCOUNT-EXISTS-NA           VALUE '-'.

       01  LK-CUSTOMER-EXISTS-FLAG    PIC X.
           88  LK-CUSTOMER-EXISTS             VALUE 'Y'.
           88  LK-CUSTOMER-NOT-EXISTS         VALUE 'N'.
           88  LK-CUSTOMER-EXISTS-NA          VALUE '-'.

       01  LK-ACC-STATUS-FLAG         PIC X.
           88  LK-ACC-STATUS-ACTIVE           VALUE 'Y'.
           88  LK-ACC-STATUS-INACTIVE         VALUE 'N'.
           88  LK-ACC-STATUS-NA               VALUE '-'.

       01  LK-CUST-ID-MATCH-FLAG      PIC X.
           88  LK-CUST-ID-MATCHES             VALUE 'Y'.
           88  LK-CUST-ID-NOT-MATCHES         VALUE 'N'.
           88  LK-CUST-ID-MATCH-NA            VALUE '-'.

       01  LK-LNAME-MATCH-FLAG        PIC X.
           88  LK-LNAME-MATCHES               VALUE 'Y'.
           88  LK-LNAME-NOT-MATCHES           VALUE 'N'.
           88  LK-LNAME-MATCH-NA              VALUE '-'.

       01  LK-FNAME-MATCH-FLAG        PIC X.
           88  LK-FNAME-MATCHES               VALUE 'Y'.
           88  LK-FNAME-NOT-MATCHES           VALUE 'N'.
           88  LK-FNAME-MATCH-NA              VALUE '-'.

       01  LK-ACCOUNTS-DIFFERENT-FLAG PIC X.
           88  LK-ACCOUNTS-ARE-DIFFERENT      VALUE 'Y'.
           88  LK-ACCOUNTS-ARE-SAME           VALUE 'N'.
           88  LK-ACCOUNTS-DIFFERENT-NA       VALUE '-'.

       PROCEDURE DIVISION USING LK-OPERATION-TYPE
                                   LK-ACCOUNT-FOUND-FLAG
                                   LK-CUSTOMER-FOUND-FLAG
                                   LK-ACCOUNT-NUMBER
                                   LK-ACCOUNT-STATUS
                                   LK-ACCOUNT-CUSTOMER-ID
                                   LK-CUSTOMER-ID
                                   LK-CUSTOMER-LAST-NAME
                                   LK-CUSTOMER-FIRST-NAME
                                   LK-ENTERED-LAST-NAME
                                   LK-ENTERED-FIRST-NAME
                                   LK-TARGET-ACCOUNT-NUMBER
                                   LK-ACCOUNT-EXISTS-FLAG
                                   LK-CUSTOMER-EXISTS-FLAG
                                   LK-ACC-STATUS-FLAG
                                   LK-CUST-ID-MATCH-FLAG
                                   LK-LNAME-MATCH-FLAG
                                   LK-FNAME-MATCH-FLAG
                                   LK-ACCOUNTS-DIFFERENT-FLAG.

       MAIN.
           PERFORM INIT-FLAGS-TO-NA

           EVALUATE TRUE
               WHEN OP-DEPOSIT
                   PERFORM CHECK-ACCOUNT-EXISTS
                   PERFORM CHECK-CUSTOMER-EXISTS
                   PERFORM CHECK-ACCOUNT-STATUS

               WHEN OP-WITHDRAW
                   PERFORM CHECK-ACCOUNT-EXISTS
                   PERFORM CHECK-CUSTOMER-EXISTS
                   PERFORM CHECK-ACCOUNT-STATUS

               WHEN OP-TRANSFER
                   PERFORM CHECK-ACCOUNT-EXISTS
                   PERFORM CHECK-CUSTOMER-EXISTS
                   PERFORM CHECK-ACCOUNT-STATUS
                   PERFORM CHECK-ACCOUNTS-DIFFERENT

               WHEN OP-CONSULT
                   PERFORM CHECK-ACCOUNT-EXISTS
                   PERFORM CHECK-CUSTOMER-EXISTS
                   PERFORM CHECK-ACCOUNT-STATUS
                   PERFORM CHECK-CUSTOMER-ID-MATCH
                   PERFORM CHECK-LAST-NAME-MATCH
                   PERFORM CHECK-FIRST-NAME-MATCH

               WHEN OTHER
                   PERFORM SET-ALL-FLAGS-TO-ERROR
           END-EVALUATE.

           GOBACK.

       INIT-FLAGS-TO-NA.
           SET LK-ACCOUNT-EXISTS-NA      TO TRUE
           SET LK-CUSTOMER-EXISTS-NA     TO TRUE
           SET LK-ACC-STATUS-NA          TO TRUE
           SET LK-CUST-ID-MATCH-NA       TO TRUE
           SET LK-LNAME-MATCH-NA         TO TRUE
           SET LK-FNAME-MATCH-NA         TO TRUE
           SET LK-ACCOUNTS-DIFFERENT-NA  TO TRUE.

       SET-ALL-FLAGS-TO-ERROR.
           SET LK-ACCOUNT-NOT-EXISTS     TO TRUE
           SET LK-CUSTOMER-NOT-EXISTS    TO TRUE
           SET LK-ACC-STATUS-INACTIVE    TO TRUE
           SET LK-CUST-ID-NOT-MATCHES    TO TRUE
           SET LK-LNAME-NOT-MATCHES      TO TRUE
           SET LK-FNAME-NOT-MATCHES      TO TRUE
           SET LK-ACCOUNTS-ARE-SAME      TO TRUE.

       CHECK-ACCOUNT-EXISTS.
           IF LK-ACCOUNT-FOUND
               SET LK-ACCOUNT-EXISTS TO TRUE
           ELSE
               SET LK-ACCOUNT-NOT-EXISTS TO TRUE
           END-IF.

       CHECK-CUSTOMER-EXISTS.
           IF LK-CUSTOMER-FOUND
               SET LK-CUSTOMER-EXISTS TO TRUE
           ELSE
               SET LK-CUSTOMER-NOT-EXISTS TO TRUE
           END-IF.

       CHECK-ACCOUNT-STATUS.
           IF LK-IN-ACCOUNT-IS-ACTIVE
               SET LK-ACC-STATUS-ACTIVE TO TRUE
           ELSE
               SET LK-ACC-STATUS-INACTIVE TO TRUE
           END-IF.

       CHECK-CUSTOMER-ID-MATCH.
           IF LK-ACCOUNT-CUSTOMER-ID = LK-CUSTOMER-ID
               SET LK-CUST-ID-MATCHES TO TRUE
           ELSE
               SET LK-CUST-ID-NOT-MATCHES TO TRUE
           END-IF.

       CHECK-LAST-NAME-MATCH.
           IF LK-ENTERED-LAST-NAME = LK-CUSTOMER-LAST-NAME
               SET LK-LNAME-MATCHES TO TRUE
           ELSE
               SET LK-LNAME-NOT-MATCHES TO TRUE
           END-IF.

       CHECK-FIRST-NAME-MATCH.
           IF LK-ENTERED-FIRST-NAME = LK-CUSTOMER-FIRST-NAME
               SET LK-FNAME-MATCHES TO TRUE
           ELSE
               SET LK-FNAME-NOT-MATCHES TO TRUE
           END-IF.

       CHECK-ACCOUNTS-DIFFERENT.
           IF LK-ACCOUNT-NUMBER NOT = LK-TARGET-ACCOUNT-NUMBER
               SET LK-ACCOUNTS-ARE-DIFFERENT TO TRUE
           ELSE
               SET LK-ACCOUNTS-ARE-SAME TO TRUE
           END-IF.
