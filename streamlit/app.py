import streamlit as st

st.set_page_config(
    page_title="Project Specification - COBOL Core Banking System",
    layout="wide"
)

st.title("Project Specification")
st.subheader("COBOL Core Banking System")

st.info(
    "Educational project designed to simulate a Mainframe Banking System "
    "using COBOL, sequential files, copybooks and batch processing."
)

st.header("1. Context")

st.write("""
The purpose of this project is to develop a simplified banking application
that manages customer accounts and financial operations using COBOL and
sequential files.
""")

st.header("2. Project Objectives")

objectives = [
    "Consult bank accounts",
    "Manage deposits",
    "Manage withdrawals",
    "Perform transfers",
    "Store transaction history",
    "Generate daily reports",
    "Simulate batch processing"
]

for obj in objectives:
    st.markdown(f"- {obj}")

st.header("3. Functional Scope")

with st.expander("Function 1: Account Consultation", expanded=True):
    st.write("Search for a bank account using its account number.")
    st.markdown("**Input:** account number")
    st.markdown("**Expected output:**")
    st.code("""
Account number
Customer identifier
Account type
Balance
Opening date
""", language="text")

with st.expander("Function 2: Deposit"):
    st.write("Credit a bank account.")
    st.markdown("""
**Business rules:**
- The account must exist.
- The amount must be strictly positive.

**Result:** the account balance is updated and a transaction is created.
""")

with st.expander("Function 3: Withdrawal"):
    st.write("Debit a bank account.")
    st.markdown("""
**Business rules:**
- The account must exist.
- The amount must be strictly positive.
- The account balance must be sufficient.

**Result:** the account balance is updated and a transaction is created.
""")

with st.expander("Function 4: Transfer"):
    st.write("Transfer money between two bank accounts.")
    st.markdown("""
**Business rules:**
- The source account must exist.
- The target account must exist.
- The amount must be strictly positive.
- The source account must have sufficient balance.

**Result:** the source account is debited, the target account is credited and the transaction is stored.
""")

with st.expander("Function 5: Transaction History"):
    st.write("All accepted banking operations must be recorded in the transaction file.")
    st.code("""
DEPOSIT
WITHDRAW
TRANSFER
""", language="text")

with st.expander("Function 6: Daily Report"):
    st.write("Generate a summary report from the transaction file.")
    st.code("""
Number of accounts
Number of deposits
Number of withdrawals
Number of transfers
Total transaction amount
""", language="text")

st.header("4. Data Model")

col1, col2 = st.columns(2)

with col1:
    st.subheader("CUSTOMER File")

    st.table({
        "Field": [
            "CUST-ID",
            "CUST-LAST-NAME",
            "CUST-FIRST-NAME",
            "CUST-CITY",
            "CUST-SEGMENT"
        ],
        "COBOL Type": [
            "X(7)",
            "X(20)",
            "X(20)",
            "X(20)",
            "X(10)"
        ],
        "Description": [
            "Unique customer identifier",
            "Customer last name",
            "Customer first name",
            "Customer city",
            "Customer segment"
        ],
        "Example": [
            "C000001",
            "DUPONT",
            "MARIE",
            "PARIS",
            "PREMIUM"
        ]
    })

with col2:
    st.subheader("ACCOUNT File")

    st.table({
        "Field": [
            "ACC-NUMBER",
            "ACC-CUSTOMER-ID",
            "ACC-TYPE",
            "ACC-BALANCE",
            "ACC-OPEN-DATE"
        ],
        "COBOL Type": [
            "X(10)",
            "X(7)",
            "X(10)",
            "9(9)V99",
            "9(8)"
        ],
        "Description": [
            "Unique bank account number",
            "Customer identifier linked to the account",
            "Bank account type",
            "Account balance with two decimals",
            "Account opening date in YYYYMMDD format"
        ],
        "Example": [
            "0000000001",
            "C000001",
            "COURANT",
            "00000150050",
            "20240115"
        ]
    })

st.subheader("TRANSACTION File")

st.table({
    "Field": [
        "TXN-ID",
        "TXN-DATE",
        "TXN-TYPE",
        "TXN-SOURCE-ACC",
        "TXN-TARGET-ACC",
        "TXN-AMOUNT"
    ],
    "COBOL Type": [
        "X(9)",
        "9(8)",
        "X(8)",
        "X(10)",
        "X(10)",
        "9(9)V99"
    ],
    "Description": [
        "Unique transaction identifier",
        "Transaction date in YYYYMMDD format",
        "Transaction type",
        "Source or affected account",
        "Target account for transfers",
        "Transaction amount with two decimals"
    ],
    "Example": [
        "T00000001",
        "20260609",
        "DEPOSIT",
        "0000000001",
        "0000000002",
        "00000010000"
    ]
})

st.header("5. Technical Architecture")

st.code("""
cobol-core-banking-system/
│
├── data/
│   ├── comptes.dat
│   ├── clients.dat
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
│   ├── architecture.md
│   ├── project-specification.md
│   └── data-dictionary.md
│
└── app.py
""", language="text")

st.subheader("Planned COBOL Programs")

st.table({
    "Program": ["LSTCPT", "CNSCPT", "DEPOT", "RETRAIT", "VIREMENT", "RAPJOUR"],
    "Role": [
        "List all accounts",
        "Consult one account",
        "Perform a deposit",
        "Perform a withdrawal",
        "Perform a transfer",
        "Generate the daily report"
    ],
    "Type": ["Batch", "Batch", "Batch", "Batch", "Batch", "Batch"]
})

st.header("6. Technical Constraints")

st.markdown("""
### Main language
- COBOL

### Storage
- Sequential files

### Development environment
- VS Code
- GnuCOBOL
- Git
- GitHub
- Streamlit

### Planned evolutions
- JCL
- VSAM
- DB2
- CICS
""")

st.header("7. Business Rules")

rules = {
    "BR01": "An account must exist before it can be consulted.",
    "BR02": "A deposit amount must be strictly positive.",
    "BR03": "A withdrawal amount must be strictly positive.",
    "BR04": "A withdrawal is rejected if the account balance is insufficient.",
    "BR05": "A transfer requires a valid source account and a valid target account.",
    "BR06": "The source account of a transfer must have sufficient balance.",
    "BR07": "Each accepted operation must be recorded in the transaction file.",
    "BR08": "Business errors must be clearly displayed or written into a dedicated error file."
}

for code, rule in rules.items():
    st.markdown(f"**{code}**: {rule}")

st.header("8. Success Criteria")

success = [
    "All COBOL programs compile without errors.",
    "Sequential files are correctly read.",
    "Account consultation returns the expected information.",
    "Balances are correctly updated after deposits, withdrawals and transfers.",
    "Transactions are recorded in transactions.dat.",
    "Business errors are properly handled.",
    "The daily report is generated.",
    "Copybooks are reused across COBOL programs.",
    "The project is documented and published on GitHub."
]

for item in success:
    st.markdown(f"- {item}")

st.header("9. Roadmap")

st.table({
    "Version": [
        "V1.0",
        "V1.1",
        "V1.2",
        "V1.3",
        "V1.4",
        "V1.5",
        "V2.0",
        "V3.0"
    ],
    "Objective": [
        "Read account records",
        "Consult one account",
        "Deposit processing",
        "Withdrawal processing",
        "Transfer processing",
        "Transaction history and daily report",
        "Add JCL batch execution",
        "Evolution toward VSAM and DB2"
    ],
    "Status": [
        "To do",
        "To do",
        "To do",
        "To do",
        "To do",
        "To do",
        "Future",
        "Future"
    ]
})

st.header("10. Portfolio Positioning")

st.success("""
This project demonstrates practical skills in COBOL, IBM Z concepts,
batch processing, sequential file management, copybook design and
mainframe-oriented application architecture.
""")