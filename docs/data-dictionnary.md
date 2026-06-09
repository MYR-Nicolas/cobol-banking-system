# Data Dictionary

## 1. CLIENT File

### COBOL Structure

```cobol
01 CUSTOMER-RECORD.
   05 CUST-ID          PIC X(7).
   05 CUST-LAST-NAME   PIC X(20).
   05 CUST-FIRST-NAME  PIC X(20).
   05 CUST-CITY        PIC X(20).
   05 CUST-SEGMENT     PIC X(10).
```

| Field | COBOL Type | Length | Description | Example |
|---|---:|---:|---|---|
| CUST-ID | X(7) | 7 | Unique customer identifier | C000001 |
| CUST-LAST-NAME | X(20) | 20 | Customer last name | LEFEBVRE |
| CUST-FIRST-NAME | X(20) | 20 | Customer first name | JEAN |
| CUST-CITY | X(20) | 20 | Customer city | PARIS |
| CUST-SEGMENT | X(10) | 10 | Customer segment | PREMIUM |

---

## 2. ACCOUNT File

### COBOL Structure

```cobol
01 ACCOUNT-RECORD.
   05 ACC-NUMBER       PIC X(10).
   05 ACC-CUSTOMER-ID  PIC X(7).
   05 ACC-TYPE         PIC X(10).
   05 ACC-BALANCE      PIC 9(9)V99.
   05 ACC-OPEN-DATE    PIC 9(8).
```

| Field | COBOL Type | Length | Description | Example |
|---|---:|---:|---|---|
| ACC-NUMBER | X(10) | 10 | Unique bank account number | 0000000001 |
| ACC-CUSTOMER-ID | X(7) | 7 | Customer identifier linked to the account | C000001 |
| ACC-TYPE | X(10) | 10 | Account type | COURANT |
| ACC-BALANCE | 9(9)V99 | 11 | Account balance with 2 decimals | 00000150050 |
| ACC-OPEN-DATE | 9(8) | 8 | Account opening date, format YYYYMMDD | 20240115 |

---

## 3. TRANSACTION File

### COBOL Structure

```cobol
01 TRANSACTION-RECORD.
   05 TXN-ID           PIC X(9).
   05 TXN-DATE         PIC 9(8).
   05 TXN-TYPE         PIC X(8).
   05 TXN-SOURCE-ACC   PIC X(10).
   05 TXN-TARGET-ACC   PIC X(10).
   05 TXN-AMOUNT       PIC 9(9)V99.
```

| Field | COBOL Type | Length | Description | Example |
|---|---:|---:|---|---|
| TXN-ID | X(9) | 9 | Unique transaction identifier | T00000001 |
| TXN-DATE | 9(8) | 8 | Transaction date, format YYYYMMDD | 20260609 |
| TXN-TYPE | X(8) | 8 | Transaction type | DEPOSIT |
| TXN-SOURCE-ACC | X(10) | 10 | Source account or affected account | 0000000001 |
| TXN-TARGET-ACC | X(10) | 10 | Target account for transfers | 0000000002 |
| TXN-AMOUNT | 9(9)V99 | 11 | Transaction amount with 2 decimals | 00000010000 |

---

## 4. Allowed Values

### Account Type

| Value | Meaning |
|---|---|
| COURANT | Current account |
| EPARGNE | Savings account |

### Customer Segment

| Value | Meaning |
|---|---|
| STANDARD | Standard customer |
| PREMIUM | Premium customer |
| PRO | Professional customer |
| JEUNE | Young customer |

### Transaction Type

| Value | Meaning |
|---|---|
| DEPOSIT | Money deposit |
| WITHDRAW | Money withdrawal |
| TRANSFER | Transfer between two accounts |

---
