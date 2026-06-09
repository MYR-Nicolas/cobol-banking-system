# Architecture

## Project: COBOL Core Banking System

This document describes the technical architecture of the project.

---

## 1. Global Architecture

```text
User 
      |
      v
COBOL Programs
      |
      v
Sequential Files
      |
      v
Reports / Transactions
```

Each COBOL program is responsible for one business function:

- account listing;
- account consultation;
- deposit;
- withdrawal;
- transfer;
- daily reporting.

---

## 2. Project Structure

```text
cobol-core-banking-system/
│
├── data/
│   ├── clients.dat
│   ├── comptes.dat
│   └── transactions.dat
│
├── copybooks/
│   ├── client.cpy
│   ├── compte.cpy
│   ├── transaction.cpy
│   └── status.cpy
│
├── src/
│   ├── LSTCPT.cbl
│   ├── CNSCPT.cbl
│   ├── DEPOT.cbl
│   ├── RETRAIT.cbl
│   ├── VIREMENT.cbl
│   └── RAPJOUR.cbl
│
├── docs/
│   ├── cahier-des-charges.md
│   ├── dictionnaire-donnees.md
│   └── architecture.md
│
└── app.py
```

---

## 3. Main Components

| Component | Role |
|---|---|
| `data/` | Contains input and output sequential files |
| `copybooks/` | Contains reusable COBOL data structures |
| `src/` | Contains COBOL source programs |
| `docs/` | Contains project documentation |
| `app.py` | Streamlit documentation interface |

---

## 4. Data Files

| File | Description |
|---|---|
| `clients.dat` | Stores customer information |
| `comptes.dat` | Stores bank account information |
| `transactions.dat` | Stores banking operations history |


---

## 5. COBOL Programs

| Program | Description | Input File | Output File |
|---|---|---|---|
| `LSTCPT.cbl` | Lists all bank accounts | `comptes.dat` | Display |
| `CNSCPT.cbl` | Searches and displays one account | `comptes.dat` | Display |
| `DEPOT.cbl` | Adds money to an account | `comptes.dat` | `transactions.dat` |
| `RETRAIT.cbl` | Withdraws money from an account | `comptes.dat` | `transactions.dat` |
| `VIREMENT.cbl` | Transfers money between accounts | `comptes.dat` | `transactions.dat` |
| `RAPJOUR.cbl` | Generates a daily summary report | `transactions.dat` | Display / report file |

---

## 6. Copybooks

| Copybook | Description |
|---|---|
| `client.cpy` | Defines the customer record structure |
| `compte.cpy` | Defines the account record structure |
| `transaction.cpy` | Defines the transaction record structure |
| `status.cpy` | Defines technical working-storage variables such as EOF flags and error codes |


---

## 7. Logical Data Model

```text
CUSTOMER-RECORD
   CUST-ID
      |
      +--> ACCOUNT-RECORD
              ACC-CUSTOMER-ID
              ACC-NUMBER
                   |
                   +--> TRANSACTION-RECORD
                          TXN-SOURCE-ACC
                          TXN-TARGET-ACC
```

Business relationships:

- one customer can own several accounts;
- one account can have several transactions;
- a transfer references both a source account and a target account.

---

## 8. Data Flow

### 8.1 Account consultation

```text
CNSCPT.cbl
   |
   v
Read comptes.dat
   |
   v
Search account by account number
   |
   v
Display account information
```

### 8.2 Deposit

```text
DEPOT.cbl
   |
   v
Read comptes.dat
   |
   v
Find target account
   |
   v
Add amount to account balance
   |
   v
Write transaction into transactions.dat
```

### 8.3 Withdrawal

```text
RETRAIT.cbl
   |
   v
Read comptes.dat
   |
   v
Find target account
   |
   v
Check available balance
   |
   v
Subtract amount from account balance
   |
   v
Write transaction into transactions.dat
```

### 8.4 Transfer

```text
VIREMENT.cbl
   |
   v
Read source account
   |
   v
Read target account
   |
   v
Check source account balance
   |
   v
Debit source account
   |
   v
Credit target account
   |
   v
Write transaction into transactions.dat
```

### 8.5 Daily report

```text
RAPJOUR.cbl
   |
   v
Read transactions.dat
   |
   v
Aggregate operations by type
   |
   v
Display daily report
```

---

## 9. Execution Logic

```text
INITIALIZATION
      |
      v
PROCESSING
      |
      v
FINALIZATION
```


```cobol
PROCEDURE DIVISION.

    PERFORM INITIALIZATION
    PERFORM PROCESSING
    PERFORM FINALIZATION

    STOP RUN.
```

---

## 10. Business Rules

| Rule | Description |
|---|---|
| RG01 | An account must exist before being consulted. |
| RG02 | A deposit amount must be strictly positive. |
| RG03 | A withdrawal amount must be strictly positive. |
| RG04 | A withdrawal is rejected if the account balance is insufficient. |
| RG05 | A transfer requires a valid source account and a valid target account. |
| RG06 | The source account of a transfer must have sufficient balance. |
| RG07 | Each accepted operation must be recorded in the transaction file. |
| RG08 | Business errors must be displayed clearly or written into a dedicated error file. |

---

## 11. Technical Choices

| Choice | Reason |
|---|---|
| COBOL | Main language for business processing |
| Sequential files | Simple storage format close to batch processing logic |
| Copybooks | Reusable and centralized data structures |
| One program per business function | Clear modular organization |
| Streamlit | Modern documentation and presentation interface |
| GitHub | Version control and portfolio publication |

---

## 12. Current Scope

The current version focuses on:

- COBOL syntax and program structure;
- file reading and writing;
- sequential file processing;
- business rules implementation;
- project documentation;
- GitHub portfolio presentation.

The current version does not include:

- DB2;
- VSAM;
- CICS;
- real z/OS execution;
- production-grade security.

---

## 13. Future Evolution

The project can later evolve toward a more realistic mainframe architecture:

```text
COBOL
  |
  v
JCL
  |
  v
VSAM
  |
  v
DB2
  |
  v
CICS
```

Planned improvements:

- add JCL jobs for batch execution;
- replace sequential files with VSAM files;
- add DB2 tables for account and transaction storage;
- add CICS screens for online transaction processing;
- add batch reports as output files;
- add a Streamlit dashboard reading transaction data.

---