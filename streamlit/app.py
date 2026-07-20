import streamlit as st
import textwrap

# =============================================================================
# STREAMLIT PAGE CONFIGURATION
# =============================================================================

st.set_page_config(
    page_title="Project Specification - COBOL Core Banking System",
    layout="wide",
)


# =============================================================================
# GLOBAL STYLING
# Defines the visual identity of the Streamlit application.
# =============================================================================

GLOBAL_CSS = """
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap');

.stApp {
    background:
        radial-gradient(circle at top left,  rgba(59,130,246,0.08), transparent 28%),
        radial-gradient(circle at top right, rgba(99,102,241,0.08), transparent 24%),
        linear-gradient(180deg, #f8fbff 0%, #f6f8fc 45%, #f8fafc 100%);
}

.main .block-container {
    max-width: 1340px;
    padding-top: 1.4rem;
    padding-bottom: 3rem;
}

h1, h2, h3 {
    color: #0f172a;
    letter-spacing: -0.02em;
    font-family: 'Inter', sans-serif;
}

section[data-testid="stSidebar"] {
    background: linear-gradient(180deg, #f8fbff 0%, #f4f7fb 100%);
    border-right: 1px solid rgba(226,232,240,0.9);
}

section[data-testid="stSidebar"] * {
    color: #1e293b !important;
}

section[data-testid="stSidebar"] .stButton > button {
    background: linear-gradient(135deg, #1e3a8a, #2563eb) !important;
    color: white !important;
    border: none !important;
    font-weight: 600 !important;
    border-radius: 10px !important;
}

[data-testid="stMetric"] {
    background: rgba(255,255,255,0.94);
    border: 1px solid rgba(226,232,240,0.95);
    border-radius: 16px;
    padding: 0.8rem 0.9rem;
    box-shadow: 0 8px 20px rgba(15,23,42,0.05);
}

div[data-testid="stExpander"] {
    border-radius: 14px;
    overflow: hidden;
    border: 1px solid rgba(191,219,254,0.9);
}

.hero-box {
    background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 55%, #2563eb 100%);
    color: white;
    border-radius: 24px;
    padding: 1.6rem 1.6rem 1.4rem 1.6rem;
    box-shadow: 0 18px 45px rgba(30,58,138,0.22);
    margin-bottom: 1.2rem;
}

.section-box {
    background: rgba(255,255,255,0.90);
    border: 1px solid rgba(226,232,240,0.95);
    border-radius: 18px;
    padding: 1rem 1.1rem;
    box-shadow: 0 8px 24px rgba(15,23,42,0.05);
    margin-bottom: 1rem;
    overflow: hidden;
}

.badge {
    display: inline-block;
    padding: 0.35rem 0.75rem;
    border-radius: 999px;
    margin: 0.15rem 0.2rem 0.15rem 0;
    font-size: 0.82rem;
    font-weight: 600;
    background: #eef2ff;
    color: #3730a3;
    border: 1px solid #c7d2fe;
}

.badge-success {
    background:#ecfdf5;
    color:#065f46;
    border:1px solid #a7f3d0;
}

.badge-error {
    background:#fef2f2;
    color:#991b1b;
    border:1px solid #fecaca;
}

.badge-warning {
    background:#fff7ed;
    color:#9a3412;
    border:1px solid #fdba74;
}

.badge-info {
    background:#eff6ff;
    color:#1d4ed8;
    border:1px solid #bfdbfe;
}

.badge-cics {
    background:#fdf4ff;
    color:#86198f;
    border:1px solid #f5d0fe;
}

.badge-batch {
    background:#eef2ff;
    color:#3730a3;
    border:1px solid #c7d2fe;
}

.kpi-grid {
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(160px,1fr));
    gap:1px;
    background:rgba(226,232,240,0.9);
    border:1px solid rgba(226,232,240,0.9);
    border-radius:18px;
    overflow:hidden;
    margin-bottom:1.5rem;
    box-shadow:0 8px 24px rgba(15,23,42,0.05);
}

.kpi-cell {
    background:rgba(255,255,255,0.96);
    padding:1.3rem 1.5rem;
}

.kpi-label {
    font-size:0.68rem;
    font-weight:700;
    letter-spacing:0.09em;
    text-transform:uppercase;
    color:#94a3b8;
    margin-bottom:0.5rem;
}

.kpi-value {
    font-size:2rem;
    font-weight:800;
    color:#0f172a;
    letter-spacing:-0.04em;
    line-height:1;
    font-family:'Inter',sans-serif;
}

.kpi-value.c-blue {
    color:#2563eb;
}

.sec-label {
    font-size:0.68rem;
    font-weight:700;
    letter-spacing:0.10em;
    text-transform:uppercase;
    color:#94a3b8;
    margin:1.8rem 0 0.9rem 0;
    padding-bottom:0.5rem;
    border-bottom:1px solid rgba(226,232,240,0.9);
}

.detail-table {
    width:100%;
    border-collapse:collapse;
    font-size:0.85rem;
}

.detail-table td {
    padding:0.65rem 0;
    border-bottom:1px solid rgba(241,245,249,0.9);
    color:#374151;
    vertical-align:top;
}

.detail-table td:first-child {
    color:#94a3b8;
    width:38%;
    font-size:0.72rem;
    font-weight:600;
    text-transform:uppercase;
    letter-spacing:0.06em;
}

.detail-table tr:last-child td {
    border-bottom:none;
}

.model-row-wrap {
    border:1px solid rgba(226,232,240,0.9);
    border-radius:14px;
    overflow:hidden;
    background:rgba(255,255,255,0.96);
    margin-bottom:1rem;
    box-shadow:0 4px 12px rgba(15,23,42,0.04);
}

.model-row {
    display:flex;
    align-items:center;
    justify-content:space-between;
    padding:0.8rem 1.1rem;
    border-bottom:1px solid rgba(241,245,249,0.9);
    gap:1rem;
}

.model-row:last-child {
    border-bottom:none;
}

.model-name {
    font-family:'JetBrains Mono',monospace;
    font-size:0.82rem;
    font-weight:500;
    color:#1e293b;
}

.model-type-tag {
    font-size:0.65rem;
    font-weight:700;
    letter-spacing:0.08em;
    text-transform:uppercase;
    color:#94a3b8;
    margin-bottom:0.15rem;
}

.model-group-label {
    font-size:0.7rem;
    font-weight:800;
    letter-spacing:0.1em;
    text-transform:uppercase;
    padding:0.55rem 1.1rem;
    background:rgba(248,250,252,0.9);
    border-bottom:1px solid rgba(241,245,249,0.9);
}

.check-row {
    display:flex;
    align-items:flex-start;
    gap:0.85rem;
    padding:0.85rem 0;
    border-bottom:1px solid rgba(241,245,249,0.9);
}

.check-row:last-child {
    border-bottom:none;
}

.check-text {
    font-size:0.85rem;
    color:#374151;
}

.check-text strong {
    color:#111827;
    font-weight:600;
}

.road-pill {
    display:inline-block;
    padding:0.25rem 0.65rem;
    border-radius:999px;
    font-size:0.72rem;
    font-weight:700;
    letter-spacing:0.06em;
}

.road-todo {
    background:#eff6ff;
    color:#1d4ed8;
    border:1px solid #bfdbfe;
}

.road-future {
    background:#f5f3ff;
    color:#5b21b6;
    border:1px solid #ddd6fe;
}

.road-done {
    background:#ecfdf5;
    color:#065f46;
    border:1px solid #a7f3d0;
}

.success-banner {
    background: linear-gradient(135deg, #ecfdf5, #d1fae5);
    border: 1px solid #6ee7b7;
    border-radius: 16px;
    padding: 1.2rem 1.4rem;
    color: #065f46;
    font-size: 0.9rem;
    line-height: 1.7;
    margin-top: 1rem;
}

.test-folder-cell {
    background:rgba(255,255,255,0.96);
    border:1px solid rgba(226,232,240,0.9);
    border-radius:12px;
    padding:0.85rem 1rem;
}

.test-folder-name {
    font-family:'JetBrains Mono',monospace;
    font-size:0.82rem;
    font-weight:700;
    color:#0f172a;
    margin-bottom:0.25rem;
}

.test-folder-desc {
    font-size:0.78rem;
    color:#64748b;
    line-height:1.5;
}

.constraint-warning {
    background: linear-gradient(135deg, #fff7ed, #fffbeb);
    border: 1px solid #fdba74;
    border-left: 6px solid #f97316;
    border-radius: 16px;
    padding: 1rem 1.15rem;
    margin: 0 0 1.1rem 0;
    box-shadow: 0 8px 22px rgba(249,115,22,0.10);
}

.constraint-warning-title {
    color: #9a3412;
    font-size: 0.82rem;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    margin-bottom: 0.35rem;
}

.constraint-warning-text {
    color: #7c2d12;
    font-size: 0.9rem;
    line-height: 1.65;
}

</style>
"""

st.markdown(GLOBAL_CSS, unsafe_allow_html=True)



# =============================================================================
# IMPLEMENTATION NOTICE
# Displays a professional warning about the current CICS simulation constraint.
# =============================================================================

st.markdown("""
<div class="constraint-warning">
  <div class="constraint-warning-title">Implementation Notice</div>
  <div class="constraint-warning-text">
    CICS-designated programs are currently implemented and executed in
    <strong>BATCH mode</strong> due to environment and platform constraints.
    They remain structured as a CICS-oriented simulation and are planned to
    evolve toward true online transaction processing when a compatible
    mainframe/CICS runtime is available.
  </div>
</div>
""", unsafe_allow_html=True)


# =============================================================================
# HERO SECTION
# Project presentation banner displayed at the top of the page.
# =============================================================================

st.markdown("""
<div class="hero-box">
  <div style="font-size:1.6rem; font-weight:800; letter-spacing:-0.03em; line-height:1.1;">
    COBOL Core Banking System
  </div>
  <div style="font-size:0.85rem; opacity:0.75; margin-top:0.3rem; font-weight:400;">
    Project Specification - Educational Mainframe Banking Simulation
  </div>
  <p style="font-size:0.95rem; opacity:0.9; line-height:1.65; margin:1rem 0 1rem 0;">
    Educational project designed to simulate a Mainframe Banking System
    using COBOL, sequential files, copybooks and batch processing.
  </p>
  <div>
    <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">COBOL</span>
    <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">GnuCOBOL</span>
    <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">Sequential Files</span>
    <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">Copybooks</span>
    <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">Batch Processing</span>
    <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">CICS</span>
    <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">JCL Planned</span>
    <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">Tests Suite</span>
  </div>
</div>
""", unsafe_allow_html=True)


# =============================================================================
# KPI SECTION
# Displays project statistics and key indicators.
# =============================================================================

st.markdown("""
<div class="kpi-grid">
  <div class="kpi-cell">
    <div class="kpi-label">Language</div>
    <div class="kpi-value" style="font-size:1.5rem;">COBOL</div>
  </div>
  <div class="kpi-cell">
    <div class="kpi-label">COBOL Programs</div>
    <div class="kpi-value c-blue">6</div>
  </div>
  <div class="kpi-cell">
    <div class="kpi-label">Batch Programs</div>
    <div class="kpi-value c-blue">1</div>
  </div>
  <div class="kpi-cell">
    <div class="kpi-label">CICS Programs</div>
    <div class="kpi-value c-blue">5</div>
  </div>
  <div class="kpi-cell">
    <div class="kpi-label">Data Files</div>
    <div class="kpi-value c-blue">3</div>
  </div>
  <div class="kpi-cell">
    <div class="kpi-label">Copybooks</div>
    <div class="kpi-value c-blue">3</div>
  </div>
  <div class="kpi-cell">
    <div class="kpi-label">Test Suites</div>
    <div class="kpi-value c-blue">6</div>
  </div>
</div>
""", unsafe_allow_html=True)


# =============================================================================
# SECTION 1 - PROJECT CONTEXT
# Presents the project objectives and overall business context.
# =============================================================================

st.markdown('<div class="sec-label">Section 1 - Context</div>', unsafe_allow_html=True)

st.markdown("""
<div class="section-box">
  <div style="font-size:1.15rem; font-weight:700; color:#0f172a; margin-bottom:0.4rem;">Project Overview</div>
  <div style="color:#475569; line-height:1.7;">
    The purpose of this project is to develop a simplified banking application
    that manages customer accounts and financial operations using COBOL and
    sequential files. It serves as a hands-on introduction to mainframe
    concepts: batch programs, online CICS transactions, copybooks, structured
    record layouts, and file-based persistence.
  </div>
</div>
""", unsafe_allow_html=True)


# =============================================================================
# SECTION 2 - PROJECT OBJECTIVES
# Defines the main business functionalities delivered by the system.
# =============================================================================

st.markdown('<div class="sec-label">Section 2 - Project Objectives</div>', unsafe_allow_html=True)

objectives = [
    "Consult bank accounts",
    "Manage deposits",
    "Manage withdrawals",
    "Perform transfers",
    "Store transaction history",
    "Generate daily reports",
    "Simulate batch processing",
    "Simulate online CICS transactions",
]

obj_html = '<div class="model-row-wrap">'
for text in objectives:
    obj_html += f"""
    <div class="model-row">
      <span class="check-text" style="flex:1;">{text}</span>
      <span class="badge-info badge">Planned</span>
    </div>"""
obj_html += "</div>"

st.markdown(obj_html, unsafe_allow_html=True)


# =============================================================================
# SECTION 3 - FUNCTIONAL SCOPE
# Detailed description of all business functions implemented.
# =============================================================================

st.markdown('<div class="sec-label">Section 3 - Functional Scope</div>', unsafe_allow_html=True)

functions = [
    {
        "num": "F1",
        "title": "Account Listing",
        "program": "LSTACC",
        "mode": "BATCH",
        "desc": "List all bank accounts from the account file.",
        "rules": [
            "Input: account file (full read)",
            "Output: list of all accounts with their balance",
        ],
    },
    {
        "num": "F2",
        "title": "Account Consultation",
        "program": "CNSACC",
        "mode": "CICS",
        "desc": "Search for a bank account using its account number, online.",
        "rules": [
            "Input: account number",
            "Output: account number, customer ID, account type, balance, opening date",
        ],
    },
    {
        "num": "F3",
        "title": "Deposit",
        "program": "DEPOSIT",
        "mode": "CICS",
        "desc": "Credit a bank account, online.",
        "rules": [
            "The account must exist.",
            "The amount must be strictly positive.",
            "Result: balance updated and transaction created.",
        ],
    },
    {
        "num": "F4",
        "title": "Withdrawal",
        "program": "WITHDRAW",
        "mode": "CICS",
        "desc": "Debit a bank account, online.",
        "rules": [
            "The account must exist.",
            "The amount must be strictly positive.",
            "The account balance must be sufficient.",
            "Result: balance updated and transaction created.",
        ],
    },
    {
        "num": "F5",
        "title": "Transfer",
        "program": "TRANSFER",
        "mode": "CICS",
        "desc": "Transfer money between two bank accounts, online.",
        "rules": [
            "Source and target accounts must exist.",
            "Amount must be strictly positive.",
            "Source account must have sufficient balance.",
            "Result: source debited, target credited and transaction stored.",
        ],
    },
    {
        "num": "F6",
        "title": "Daily Report",
        "program": "DAYRPT",
        "mode": "BATCH",
        "desc": "Generate a summary report from the transaction file.",
        "rules": [
            "Number of accounts",
            "Number of deposits, withdrawals, and transfers",
            "Total transaction amount",
        ],
    },
]

mode_badge = {
    "BATCH": '<span class="badge badge-batch">BATCH</span>',
    "CICS": '<span class="badge badge-cics">CICS</span>',
}

for fn in functions:
    rules_html = "".join(
        f"""
        <div class="check-row">
          <span style="color:#2563eb;font-weight:700;font-size:0.8rem;">-</span>
          <span class="check-text">{rule}</span>
        </div>
        """
        for rule in fn["rules"]
    )

    st.markdown(
        f"""
        <div class="section-box" style="margin-bottom:0.75rem;">
          <div style="display:flex; align-items:center; gap:0.75rem; margin-bottom:0.5rem;">
            <span style="background:#eef2ff; color:#3730a3; border-radius:8px; padding:0.2rem 0.6rem; font-size:0.75rem; font-weight:800;">{fn["num"]}</span>
            <span style="font-size:1.05rem; font-weight:700; color:#0f172a;">{fn["title"]}</span>
            <span style="font-family:'JetBrains Mono',monospace; font-size:0.75rem; color:#94a3b8; margin-left:auto;">{fn["program"]}</span>
            {mode_badge[fn["mode"]]}
          </div>
          <div style="color:#475569; font-size:0.88rem; margin-bottom:0.6rem;">{fn["desc"]}</div>
          {rules_html}
        </div>
        """,
        unsafe_allow_html=True,
    )


# =============================================================================
# SECTION 4 - DATA MODEL
# Defines file structures and business entities used by the application.
# =============================================================================

st.markdown('<div class="sec-label">Section 4 - Data Model</div>', unsafe_allow_html=True)

col1, col2 = st.columns(2)

with col1:
    st.markdown("""
    <div class="section-box">
      <div style="font-size:0.8rem; font-weight:800; text-transform:uppercase; letter-spacing:0.08em; color:#2563eb; margin-bottom:0.5rem;">CUSTOMER File</div>
      <table class="detail-table">
        <tr><td>CUST-ID</td><td><code>X(7)</code> - Unique customer identifier <span style="color:#94a3b8">e.g. C000001</span></td></tr>
        <tr><td>CUST-LAST-NAME</td><td><code>X(20)</code> - Customer last name</td></tr>
        <tr><td>CUST-FIRST-NAME</td><td><code>X(20)</code> - Customer first name</td></tr>
        <tr><td>CUST-CITY</td><td><code>X(20)</code> - Customer city</td></tr>
        <tr><td>CUST-SEGMENT</td><td><code>X(10)</code> - Customer segment <span style="color:#94a3b8">e.g. PREMIUM</span></td></tr>
      </table>
    </div>
    """, unsafe_allow_html=True)

with col2:
    st.markdown("""
    <div class="section-box">
      <div style="font-size:0.8rem; font-weight:800; text-transform:uppercase; letter-spacing:0.08em; color:#2563eb; margin-bottom:0.5rem;">ACCOUNT File</div>
      <table class="detail-table">
        <tr><td>ACC-NUMBER</td><td><code>X(10)</code> - Unique bank account number</td></tr>
        <tr><td>ACC-CUSTOMER-ID</td><td><code>X(7)</code> - Linked customer identifier</td></tr>
        <tr><td>ACC-TYPE</td><td><code>X(10)</code> - Account type <span style="color:#94a3b8">e.g. CHECKING</span></td></tr>
        <tr><td>ACC-BALANCE</td><td><code>9(9)V99</code> - Balance with two decimals</td></tr>
        <tr><td>ACC-OPEN-DATE</td><td><code>9(8)</code> - Opening date YYYYMMDD</td></tr>
      </table>
    </div>
    """, unsafe_allow_html=True)

st.markdown("""
<div class="section-box">
  <div style="font-size:0.8rem; font-weight:800; text-transform:uppercase; letter-spacing:0.08em; color:#2563eb; margin-bottom:0.5rem;">TRANSACTION File</div>
  <table class="detail-table">
    <tr><td>TXN-ID</td><td><code>X(9)</code> - Unique transaction identifier <span style="color:#94a3b8">e.g. T00000001</span></td></tr>
    <tr><td>TXN-DATE</td><td><code>9(8)</code> - Transaction date YYYYMMDD</td></tr>
    <tr><td>TXN-TYPE</td><td><code>X(8)</code> - Type: DEPOSIT / WITHDRAW / TRANSFER</td></tr>
    <tr><td>TXN-SOURCE-ACC</td><td><code>X(10)</code> - Source or affected account</td></tr>
    <tr><td>TXN-TARGET-ACC</td><td><code>X(10)</code> - Target account for transfers only</td></tr>
    <tr><td>TXN-AMOUNT</td><td><code>9(9)V99</code> - Transaction amount with two decimals</td></tr>
  </table>
</div>
""", unsafe_allow_html=True)


# =============================================================================
# SECTION 5 - TECHNICAL ARCHITECTURE
# Presents the physical organization of the project and COBOL components.
# =============================================================================

st.markdown('<div class="sec-label">Section 5 - Technical Architecture</div>', unsafe_allow_html=True)




st.markdown("""
    <div class="section-box">
      <div style="
        font-size:0.8rem;
        font-weight:800;
        text-transform:uppercase;
        letter-spacing:0.08em;
        color:#2563eb;
        margin-bottom:0.75rem;">
        Project Structure
      </div>
    </div>
    """, unsafe_allow_html=True)

project_structure = """
cobol-core-banking-system/
|
|-- data/
|   |-- accounts.dat
|   |-- customers.dat
|   |-- transactions.dat
|
|-- copybooks/
|   |-- CUSTOMER.cpy
|   |-- ACCOUNT.cpy
|   |-- TRANSACTION.cpy
|
|-- bank-parameters/
|   |-- RULE-ACCOUNT-CTRL.cbl  
|   |-- RULE-FORMAT.cbl           
|   |-- RULE-SEGMENT-RANGE.cbl    
|   |-- RULE-BALANCE.cbl          
|   |-- RULE-LIMIT.cbl            
|
|-- jcl
|-- src/
|   |-- BATCH/
|   |   |-- LSTACC.cbl
|   |
|   |-- CICS/
|       |-- CNSACC.cbl            -> CALL RULE-ACCOUNT-CTRL
|       |-- DEPOSIT.cbl           -> CALL RULE-ACCOUNT-CTRL, RULE-FORMAT, RULE-SEGMENT-RANGE, RULE-BALANCE
|       |-- WITHDRAW.cbl          -> CALL RULE-ACCOUNT-CTRL, RULE-FORMAT, RULE-SEGMENT-RANGE, RULE-LIMIT, RULE-BALANCE
|       |-- TRANSFER.cbl          -> CALL RULE-ACCOUNT-CTRL (x2), RULE-FORMAT, RULE-SEGMENT-RANGE, RULE-BALANCE
|       |-- DAYRPT.cbl
|
|-- docs/
|   |-- architecture.md
|   |-- data-dictionary.md
|
|-- tests/
|   |-- functional/
|   |-- input/
|   |-- integration/
|   |-- regression/
|   |-- robustness/
|   |-- unit/
|
|-- app.py
"""

st.code(project_structure, language="text")


programs = [
        ("LSTACC", "List all accounts", "BATCH"),
        ("CNSACC", "Consult one account", "CICS"),
        ("DEPOSIT", "Process a deposit", "CICS"),
        ("WITHDRAW", "Process a withdrawal", "CICS"),
        ("TRANSFER", "Process a transfer", "CICS"),
        ("DAYRPT", "Generate daily report", "BATCH"),
    ]

groups = [
        ("BATCH", "src/BATCH"),
        ("CICS", "src/CICS"),
    ]

rows = ""

for group_key, group_path in groups:
        group_color = "#3730a3" if group_key == "BATCH" else "#86198f"
        rows += f"""
        <div class="model-group-label" style="color:{group_color};">{group_path}</div>"""
        for name, role, ptype in programs:
            if ptype != group_key:
                continue
            badge_class = "badge-batch" if ptype == "BATCH" else "badge-cics"
            rows += f"""
            <div class="model-row">
              <div>
                <div class="model-type-tag">Program</div>
                <div class="model-name">{name}.cbl</div>
              </div>
              <div style="flex:1; padding:0 1rem; font-size:0.83rem; color:#475569;">{role}</div>
              <span class="badge {badge_class}">{ptype}</span>
            </div>"""

st.markdown(f"""
    <div class="section-box">
      <div style="font-size:0.8rem; font-weight:800; text-transform:uppercase; letter-spacing:0.08em; color:#2563eb; margin-bottom:0.75rem;">COBOL Programs</div>
      <div class="model-row-wrap" style="margin:0;">{rows}</div>
    </div>
    """, unsafe_allow_html=True)


# =============================================================================
# SECTION 6 - TECHNICAL CONSTRAINTS
# Defines the technologies, tools and technical limitations.
# =============================================================================

st.markdown('<div class="sec-label">Section 6 - Technical Constraints</div>', unsafe_allow_html=True)

col_c1, col_c2 = st.columns(2)

with col_c1:
    st.markdown("""
    <div class="section-box">
      <div style="font-size:0.8rem; font-weight:800; text-transform:uppercase; letter-spacing:0.08em; color:#2563eb; margin-bottom:0.6rem;">Current Stack</div>
      <table class="detail-table">
        <tr><td>Language</td><td><span class="badge">COBOL</span></td></tr>
        <tr><td>Compiler</td><td><span class="badge">GnuCOBOL</span></td></tr>
        <tr><td>Storage</td><td>Sequential files</td></tr>
        <tr><td>Online</td><td><span class="badge badge-cics">CICS</span> simulated transactions</td></tr>
        <tr><td>Batch</td><td><span class="badge badge-batch">BATCH</span> jobs</td></tr>
        <tr><td>IDE</td><td>VS Code</td></tr>
        <tr><td>VCS</td><td>Git / GitHub</td></tr>
        <tr><td>Dashboard</td><td>Streamlit</td></tr>
        <tr><td>Testing</td><td>Shell-script based test suites (tests/)</td></tr>
      </table>
    </div>
    """, unsafe_allow_html=True)

with col_c2:
    st.markdown("""
    <div class="section-box">
      <div style="font-size:0.8rem; font-weight:800; text-transform:uppercase; letter-spacing:0.08em; color:#7c3aed; margin-bottom:0.6rem;">Planned Evolutions</div>
      <div style="display:flex; flex-wrap:wrap; gap:0.5rem; margin-top:0.25rem;">
        <span class="badge" style="background:#f5f3ff; color:#5b21b6; border-color:#ddd6fe;">JCL</span>
        <span class="badge" style="background:#f5f3ff; color:#5b21b6; border-color:#ddd6fe;">VSAM</span>
        <span class="badge" style="background:#f5f3ff; color:#5b21b6; border-color:#ddd6fe;">DB2</span>
      </div>
      <div style="font-size:0.8rem; color:#94a3b8; margin-top:0.8rem; line-height:1.6;">
        Progressive evolution toward a full mainframe-style architecture,
        replacing sequential files with VSAM datasets and adding JCL job
        control for batch scheduling, alongside the existing CICS
        online transactions.
      </div>
    </div>
    """, unsafe_allow_html=True)


# =============================================================================
# SECTION 7 - BUSINESS RULES
# Defines segment-based validation rules and banking constraints.
# =============================================================================

st.markdown('<div class="sec-label">Section 7 - Business Rules</div>', unsafe_allow_html=True)

st.markdown("""
<div class="section-box">
  <div style="font-size:1.05rem; font-weight:800; color:#0f172a; margin-bottom:0.45rem;">
    Segment-Based Banking Rules
  </div>
  <div style="color:#475569; line-height:1.7; font-size:0.9rem;">
    Business rules are based on the customer segment stored in the customer file.
    The detected segments are <strong>YOUNG</strong>, <strong>STANDARD</strong>,
    <strong>PREMIUM</strong> and <strong>PRO</strong>. These limits are inspired by
    realistic retail banking constraints and remain fully parameter-driven for
    COBOL implementation.
  </div>
</div>
""", unsafe_allow_html=True)

# -----------------------------------------------------------------------------
# Segment limits
# -----------------------------------------------------------------------------

segment_limits = [
    {
        "segment": "YOUNG",
        "profile": "Young customer / student",
        "min_deposit": "10.00",
        "max_deposit": "2,000.00",
        "min_withdrawal": "10.00",
        "max_withdrawal": "300.00",
        "free_withdrawals": "3",
        "withdrawal_fee": "1.20",
        "min_transfer": "1.00",
        "max_transfer": "1,000.00",
        "max_balance": "20,000.00",
    },
    {
        "segment": "STANDARD",
        "profile": "Standard retail customer",
        "min_deposit": "10.00",
        "max_deposit": "5,000.00",
        "min_withdrawal": "10.00",
        "max_withdrawal": "700.00",
        "free_withdrawals": "3",
        "withdrawal_fee": "1.20",
        "min_transfer": "1.00",
        "max_transfer": "5,000.00",
        "max_balance": "100,000.00",
    },
    {
        "segment": "PREMIUM",
        "profile": "High-value individual customer",
        "min_deposit": "10.00",
        "max_deposit": "20,000.00",
        "min_withdrawal": "10.00",
        "max_withdrawal": "1,500.00",
        "free_withdrawals": "Unlimited",
        "withdrawal_fee": "0.00",
        "min_transfer": "1.00",
        "max_transfer": "15,000.00",
        "max_balance": "500,000.00",
    },
    {
        "segment": "PRO",
        "profile": "Professional customer",
        "min_deposit": "10.00",
        "max_deposit": "50,000.00",
        "min_withdrawal": "10.00",
        "max_withdrawal": "3,000.00",
        "free_withdrawals": "10",
        "withdrawal_fee": "1.20",
        "min_transfer": "1.00",
        "max_transfer": "50,000.00",
        "max_balance": "1,000,000.00",
    },
]

segment_rows = "".join(
    f"""<tr>
<td><strong>{item['segment']}</strong><br><span style="color:#94a3b8; font-size:0.72rem;">{item['profile']}</span></td>
<td>{item['min_deposit']}</td>
<td>{item['max_deposit']}</td>
<td>{item['min_withdrawal']}</td>
<td>{item['max_withdrawal']}</td>
<td>{item['free_withdrawals']}</td>
<td>{item['withdrawal_fee']}</td>
<td>{item['min_transfer']}</td>
<td>{item['max_transfer']}</td>
<td>{item['max_balance']}</td>
</tr>"""
    for item in segment_limits
)

st.markdown(textwrap.dedent(f"""
<div class="section-box">
  <div style="font-size:0.8rem; font-weight:800; text-transform:uppercase; letter-spacing:0.08em; color:#2563eb; margin-bottom:0.65rem;">
    Segment Parameter Table
  </div>
  <div style="overflow-x:auto;">
    <table class="detail-table">
      <tr>
        <td>Segment</td>
        <td>Min Deposit</td>
        <td>Max Deposit</td>
        <td>Min Withdrawal</td>
        <td>Max Withdrawal</td>
        <td>Free Withdrawals / Month</td>
        <td>Withdrawal Fee</td>
        <td>Min Transfer</td>
        <td>Max Transfer</td>
        <td>Max Account Balance</td>
      </tr>
      {segment_rows}
    </table>
  </div>
</div>
""").strip(), unsafe_allow_html=True)

# -----------------------------------------------------------------------------
# Detailed business rules by domain
# -----------------------------------------------------------------------------

business_rule_groups = [
    (
        "Customer and Account Consultation",
        "BR-CUST",
        "badge-info",
        [
            ("001", "The customer must exist in the customer file."),
            ("002", "The account must exist in the account file."),
            ("003", "The account customer ID must match an existing customer ID."),
            ("004", "The entered last name and first name must match the customer linked to the account."),
            ("005", "The account must be active."),
            ("006", "The consultation must return the account number, customer ID, account type, balance and opening date."),
        ],
    ),
    (
        "Deposit",
        "BR-DEP",
        "badge-success",
        [
            ("001", "The account must exist."),
            ("002", "The customer linked to the account must exist."),
            ("003", "The account must be active."),
            ("004", "The deposit amount must be strictly positive."),
            ("005", "The deposit amount must have a maximum of two decimal places."),
            ("006", "The deposit amount must be greater than or equal to the minimum deposit amount defined for the customer segment."),
            ("007", "The deposit amount must be less than or equal to the maximum deposit amount defined for the customer segment."),
            ("008", "The new account balance must not exceed the maximum account balance allowed for the customer segment."),
            ("009", "If all controls are valid, the account balance is increased by the deposit amount."),
            ("010", "A transaction record of type DEPOSIT must be created."),
        ],
    ),
    (
        "Withdrawal",
        "BR-WDR",
        "badge-warning",
        [
            ("001", "The account must exist."),
            ("002", "The customer linked to the account must exist."),
            ("003", "The account must be active."),
            ("004", "The withdrawal amount must be strictly positive."),
            ("005", "The withdrawal amount must have a maximum of two decimal places."),
            ("006", "The withdrawal amount must be greater than or equal to the minimum withdrawal amount defined for the customer segment."),
            ("007", "The withdrawal amount must be less than or equal to the maximum withdrawal amount defined for the customer segment."),
            ("008", "The number of monthly withdrawals must not exceed the limit defined for the customer segment."),
            ("009", "If the free withdrawal limit is exceeded, a withdrawal fee is applied."),
            ("010", "The account balance must be sufficient to cover the withdrawal amount plus any applicable fee."),
            ("011", "Overdraft is not allowed."),
            ("012", "If all controls are valid, the account balance is decreased by the withdrawal amount and the fee."),
            ("013", "A transaction record of type WITHDRAW must be created."),
        ],
    ),
    (
        "Transfer",
        "BR-TRF",
        "badge-cics",
        [
            ("001", "The source account must exist."),
            ("002", "The target account must exist."),
            ("003", "The source customer must exist."),
            ("004", "The target customer must exist."),
            ("005", "Both accounts must be active."),
            ("006", "The source and target accounts must be different."),
            ("007", "The transfer amount must be strictly positive."),
            ("008", "The transfer amount must have a maximum of two decimal places."),
            ("009", "The transfer amount must be greater than or equal to the minimum transfer amount defined for the source customer segment."),
            ("010", "The transfer amount must be less than or equal to the maximum transfer amount defined for the source customer segment."),
            ("011", "The source account balance must be sufficient to cover the transfer amount."),
            ("012", "The target account balance after transfer must not exceed the maximum balance allowed for the target customer segment."),
            ("013", "The debit and credit must be processed as one logical operation."),
            ("014", "If one update fails, the full transfer must be rejected."),
            ("015", "A transaction record of type TRANSFER must be created."),
        ],
    ),
]

for title, prefix, badge_class, items in business_rule_groups:
    rows = "".join(
        f"""<div class="model-row">
<span style="font-family:'JetBrains Mono',monospace; font-size:0.75rem; font-weight:700; color:#2563eb; white-space:nowrap;">{prefix}-{number}</span>
<span class="check-text" style="flex:1;">{rule}</span>
</div>"""
        for number, rule in items
    )

    st.markdown(textwrap.dedent(f"""
    <div class="section-box">
      <div style="display:flex; align-items:center; gap:0.6rem; margin-bottom:0.65rem;">
        <div style="font-size:0.95rem; font-weight:800; color:#0f172a;">{title}</div>
        <span class="badge {badge_class}">{prefix}</span>
      </div>
      <div class="model-row-wrap" style="margin:0;">{rows}</div>
    </div>
    """).strip(), unsafe_allow_html=True)

# -----------------------------------------------------------------------------
# COBOL parameter recommendation
# -----------------------------------------------------------------------------

st.markdown("""
<div class="section-box">
  <div style="font-size:0.8rem; font-weight:800; text-transform:uppercase; letter-spacing:0.08em; color:#7c3aed; margin-bottom:0.6rem;">
    COBOL Implementation Recommendation
  </div>
  <div style="color:#475569; line-height:1.7; font-size:0.9rem;">
    These values should not be hard-coded directly inside transaction programs.
    They should be centralized in a dedicated parameter copybook or parameter file,
    for example <code>BANKPARM.cpy</code> or <code>SEGMENT-RULES.cpy</code>, then reused by
    <code>DEPOSIT</code>, <code>WITHDRAW</code> and <code>TRANSFER</code>.
  </div>
</div>
""", unsafe_allow_html=True)


# =============================================================================
# SECTION 8 - SUCCESS CRITERIA
# Defines the acceptance criteria used to validate the project.
# =============================================================================

st.markdown('<div class="sec-label">Section 8 - Success Criteria</div>', unsafe_allow_html=True)

criteria = [
    "All COBOL programs compile without errors.",
    "Sequential files are correctly read.",
    "Account consultation returns the expected information.",
    "Balances are correctly updated after deposits, withdrawals, and transfers.",
    "Transactions are recorded in transactions.dat.",
    "Business errors are properly handled.",
    "The daily report is generated.",
    "Copybooks are reused across COBOL programs.",
    "BATCH and CICS programs are organized in dedicated source folders.",
    "Unit, functional, integration, regression and robustness tests pass.",
    "The project is documented and published on GitHub.",
]

crit_html = '<div class="model-row-wrap">'

for criterion in criteria:
    crit_html += f"""
    <div class="check-row" style="padding:0.75rem 1.1rem;">
      <span style="color:#059669; font-size:1rem; flex-shrink:0;">OK</span>
      <span class="check-text">{criterion}</span>
    </div>"""

crit_html += "</div>"

st.markdown(crit_html, unsafe_allow_html=True)


# =============================================================================
# SECTION 9 - PROJECT ROADMAP
# Planned evolutions and future milestones.
# =============================================================================

st.markdown('<div class="sec-label">Section 9 - Roadmap</div>', unsafe_allow_html=True)

roadmap = [
    ("V1.0", "Read account records (LSTACC - BATCH)", "todo"),
    ("V1.1", "Consult one account (CNSACC - CICS)", "todo"),
    ("V1.2", "Deposit processing (DEPOSIT - CICS)", "todo"),
    ("V1.3", "Withdrawal processing (WITHDRAW - CICS)", "todo"),
    ("V1.4", "Transfer processing (TRANSFER - CICS)", "todo"),
    ("V1.5", "Transaction history and daily report (DAYRPT - BATCH)", "todo"),
    ("V1.6", "Build full test suite (unit/functional/integration/regression/robustness/input)", "todo"),
    ("V2.0", "Add JCL batch execution", "future"),
    ("V3.0", "Evolution toward VSAM and DB2", "future"),
]

road_html = '<div class="model-row-wrap">'

for version, objective, status in roadmap:
    pill_class = "road-future" if status == "future" else "road-todo"
    pill_label = "Future" if status == "future" else "To do"

    road_html += f"""
    <div class="model-row">
      <span style="font-family:'JetBrains Mono',monospace; font-size:0.8rem; font-weight:700; color:#0f172a; white-space:nowrap; min-width:3rem;">{version}</span>
      <span class="check-text" style="flex:1;">{objective}</span>
      <span class="road-pill {pill_class}">{pill_label}</span>
    </div>"""

road_html += "</div>"

st.markdown(road_html, unsafe_allow_html=True)


# =============================================================================
# SECTION 10 - PORTFOLIO POSITIONING
# Highlights the skills demonstrated through this project.
# =============================================================================

st.markdown('<div class="sec-label">Section 10 - Portfolio Positioning</div>', unsafe_allow_html=True)

st.markdown("""
<div class="success-banner">
  This project demonstrates practical skills in <strong>COBOL</strong>,
  <strong>IBM Z concepts</strong>, batch and <strong>CICS online</strong>
  processing, sequential file management, copybook design,
  mainframe-oriented application architecture, and a rigorous
  <strong>testing methodology</strong> covering unit, functional,
  integration, regression, robustness and input validation.
</div>
""", unsafe_allow_html=True)