# =============================================================================
# IMPORTS
# =============================================================================

from pathlib import Path

import streamlit as st


# =============================================================================
# STREAMLIT PAGE CONFIGURATION
# =============================================================================

st.set_page_config(
    page_title="COBOL Source Catalog",
    layout="wide",
)


# =============================================================================
# GLOBAL STYLING
# Custom CSS used to match the Core Banking System visual identity.
# =============================================================================

GLOBAL_CSS = """
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap');

.stApp {
    background:
        radial-gradient(circle at top left, rgba(59,130,246,0.08), transparent 28%),
        radial-gradient(circle at top right, rgba(99,102,241,0.08), transparent 24%),
        linear-gradient(180deg, #f8fbff 0%, #f6f8fc 45%, #f8fafc 100%);
}

.main .block-container {
    max-width: 1340px;
    padding-top: 1.4rem;
    padding-bottom: 3rem;
}

.hero-box {
    background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 55%, #2563eb 100%);
    color: white;
    border-radius: 24px;
    padding: 1.6rem;
    box-shadow: 0 18px 45px rgba(30,58,138,0.22);
    margin-bottom: 1.5rem;
}

.kpi-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 1px;
    background: rgba(226,232,240,0.9);
    border: 1px solid rgba(226,232,240,0.9);
    border-radius: 18px;
    overflow: hidden;
    margin-bottom: 2rem;
    box-shadow: 0 8px 24px rgba(15,23,42,0.05);
}

.kpi-cell {
    background: rgba(255,255,255,0.96);
    padding: 1.3rem 1.5rem;
}

.kpi-label {
    font-size: 0.68rem;
    font-weight: 700;
    letter-spacing: 0.09em;
    text-transform: uppercase;
    color: #94a3b8;
    margin-bottom: 0.5rem;
}

.kpi-value {
    font-size: 2rem;
    font-weight: 800;
    color: #2563eb;
    letter-spacing: -0.04em;
    line-height: 1;
    font-family: 'Inter', sans-serif;
}

.section-title {
    font-size: 0.7rem;
    font-weight: 800;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: #94a3b8;
    margin: 2rem 0 1rem 0;
    padding-bottom: 0.5rem;
    border-bottom: 1px solid rgba(226,232,240,0.9);
}

.program-card {
    background: rgba(255,255,255,0.96);
    border: 1px solid rgba(226,232,240,0.95);
    border-radius: 18px;
    padding: 1.1rem 1.2rem;
    box-shadow: 0 8px 24px rgba(15,23,42,0.05);
    margin-bottom: 0.6rem;
}

.program-title {
    font-size: 1.15rem;
    font-weight: 800;
    color: #0f172a;
    margin-bottom: 0.25rem;
}

.program-path {
    font-family: 'JetBrains Mono', monospace;
    font-size: 0.78rem;
    color: #94a3b8;
    margin-bottom: 0.5rem;
}

.program-description {
    color: #64748b;
    font-size: 0.9rem;
    line-height: 1.6;
    margin-bottom: 0.8rem;
}

.badge {
    display: inline-block;
    padding: 0.32rem 0.75rem;
    border-radius: 999px;
    margin-right: 0.35rem;
    margin-top: 0.15rem;
    font-size: 0.78rem;
    font-weight: 700;
}

.badge-file {
    background: #eef2ff;
    color: #3730a3;
    border: 1px solid #c7d2fe;
}

.badge-type {
    background: #eff6ff;
    color: #1d4ed8;
    border: 1px solid #bfdbfe;
}

.badge-cics {
    background: #fdf4ff;
    color: #86198f;
    border: 1px solid #f5d0fe;
}

.badge-created {
    background: #ecfdf5;
    color: #065f46;
    border: 1px solid #a7f3d0;
}

.badge-progress {
    background: #fff7ed;
    color: #9a3412;
    border: 1px solid #fdba74;
}

.badge-copybook {
    background: #f0fdfa;
    color: #115e59;
    border: 1px solid #99f6e4;
}

.badge-rule {
    background: #fef2f2;
    color: #991b1b;
    border: 1px solid #fecaca;
}

.badge-neutral {
    background: #f8fafc;
    color: #475569;
    border: 1px solid #e2e8f0;
}

[data-testid="stExpander"] {
    border-radius: 14px;
    border: 1px solid rgba(226,232,240,0.95);
    overflow: hidden;
    margin-bottom: 1rem;
}

[data-testid="stCodeBlock"] {
    border-radius: 14px !important;
    border: 1px solid rgba(226,232,240,0.9) !important;
    box-shadow: 0 4px 12px rgba(15,23,42,0.04) !important;
}

.stTabs [data-baseweb="tab-list"] {
    gap: 0.4rem;
    border-bottom: 1px solid rgba(226,232,240,0.9);
}

.stTabs [data-baseweb="tab"] {
    font-weight: 700;
    font-size: 0.9rem;
    letter-spacing: 0.01em;
    color: #64748b;
    padding: 0.7rem 1.2rem;
}

.stTabs [aria-selected="true"] {
    color: #2563eb;
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
# PROGRAM DEFINITIONS
# Catalog of COBOL programs included in the project.
#
# Source files are organized under src/BATCH/ and src/CICS/ depending on
# whether the program runs as a batch job or as an online CICS transaction.
# =============================================================================

PROGRAMS = [
    {
        "title": "LSTACC - List Accounts",
        "filename": "LSTACC.cbl",
        "type": "Batch",
        "path": "src/BATCH/LSTACC.cbl",
        "description": "Reads the account file and displays all bank accounts stored in the system.",
    },
    {
        "title": "CNSACC - Consult Account",
        "filename": "CNSACC.cbl",
        "type": "CICS",
        "path": "src/CICS/CNSACC.cbl",
        "description": "Searches one bank account by account number and displays detailed account information.",
    },
    {
        "title": "DEPOT - Deposit",
        "filename": "DEPOSIT.cbl",
        "type": "CICS",
        "path": "src/CICS/DEPOSIT.cbl",
        "description": "Credits an existing bank account and records the deposit transaction.",
    },
    {
        "title": "RETRAIT - Withdrawal",
        "filename": "WITHDRAW.cbl",
        "type": "CICS",
        "path": "src/CICS/WITHDRAW.cbl",
        "description": "Debits an account after checking that the balance is sufficient.",
    },
    {
        "title": "VIREMENT - Transfer",
        "filename": "TRANSFER.cbl",
        "type": "CICS",
        "path": "src/CICS/TRANSFER.cbl",
        "description": "Transfers an amount from a source account to a target account.",
    },
    {
        "title": "RAPJOUR - Daily Report",
        "filename": "DAYRPT.cbl",
        "type": "Batch",
        "path": "src/BATCH/DAYRPT.cbl",
        "description": "Reads the transaction file and generates a daily banking activity report.",
    },
]


# =============================================================================
# COPYBOOK DEFINITIONS
# Catalog of copybooks used across batch and CICS programs.
#
# Each copybook belongs to a family:
#   - RECORD : record layout, included in FILE SECTION or LINKAGE SECTION
#   - SELECT : SELECT clause fragment, included in FILE-CONTROL
#   - FD     : file description fragment, included in FILE SECTION
# =============================================================================

COPYBOOKS = [
    {
        "title": "CUSTOMER - Customer Record",
        "filename": "CUSTOMER.cpy",
        "type": "RECORD",
        "path": "bank-parameters/copybooks/CUSTOMER.cpy",
        "description": "Customer record layout for the CUSTOMER VSAM KSDS file.",
    },
    {
        "title": "SEG-CUSTOMER - Customer Segment Parameters",
        "filename": "SEG-CUSTOMER.cpy",
        "type": "RECORD",
        "path": "bank-parameters/copybooks/SEG-CUSTOMER.cpy",
        "description": (
            "Segment parameter record exposing CUST-SEGMENT with its condition-names "
            "(SEG-STANDARD, SEG-PREMIUM, SEG-PROFESSIONAL, SEG-YOUTH) used by the "
            "business rule modules."
        ),
    },
    {
        "title": "ACCOUNT - Account Record",
        "filename": "ACCOUNT.cpy",
        "type": "RECORD",
        "path": "bank-parameters/copybooks/ACCOUNT.cpy",
        "description": "Account record layout including balance and account status.",
    },
    {
        "title": "TRANSACTION - Transaction Record",
        "filename": "TRANSACTION.cpy",
        "type": "RECORD",
        "path": "bank-parameters/copybooks/TRANSACTION.cpy",
        "description": "Transaction record layout including transaction type, date and amount.",
    },
    {
        "title": "SEL-CUST - Customer SELECT",
        "filename": "SEL-CUST.cpy",
        "type": "SELECT",
        "path": "bank-parameters/copybooks/SEL-CUST.cpy",
        "description": "SELECT clause for the CUSTOMER VSAM KSDS file, indexed organization.",
    },
    {
        "title": "SEL-SEG-CUST - Segment Parameter SELECT",
        "filename": "SEL-SEG-CUST.cpy",
        "type": "SELECT",
        "path": "bank-parameters/copybooks/SEL-SEG-CUST.cpy",
        "description": "SELECT clause for the customer segment parameter file.",
    },
    {
        "title": "SEL-ACC - Account SELECT",
        "filename": "SEL-ACC.CPY",
        "type": "SELECT",
        "path": "bank-parameters/copybooks/SEL-ACC.CPY",
        "description": "SELECT clause for the ACCOUNT VSAM KSDS file, keyed on the account identifier.",
    },
    {
        "title": "SEL-TRX - Transaction SELECT",
        "filename": "SEL-TRX.cpy",
        "type": "SELECT",
        "path": "bank-parameters/copybooks/SEL-TRX.cpy",
        "description": "SELECT clause for the TRANSACTION VSAM KSDS file, dynamic access for account browsing.",
    },
    {
        "title": "WS-FILE-STATUS - File Status Codes",
        "filename": "WS-FILE-STATUS.cpy",
        "type": "STATUS",
        "path": "bank-parameters/copybooks/WS-FILE-STATUS.cpy",
        "description": (
            "Shared file status field with its condition-names, used to test VSAM "
            "return codes consistently across all programs."
        ),
    },
]


# =============================================================================
# BUSINESS RULE DEFINITIONS
# Catalog of the business rules implemented as external COBOL subprograms.
#
# Each rule is implemented in its own RULE-*.cbl module under
# src/BATCH/RULES/ and is invoked through a static or dynamic CALL.
# =============================================================================

BUSINESS_RULES = [
    {
        "title": "RULE-BALANCE - Maximum Balance",
        "rule_id": "BR-BAL-002",
        "filename": "RULE-BALANCE.cbl",
        "type": "Balance",
        "path": "bank-parameters/RULE-BALANCE.cbl",
        "description": (
            "BR-BAL-002 - The balance after the operation must not exceed the maximum "
            "balance allowed for the customer segment."
        ),
    },
    {
        "title": "RULE-WITHDRAWAL - Monthly Withdrawal Limit",
        "rule_id": "BR-LIM-001",
        "filename": "RULE-WITHDRAWAL.cbl",
        "type": "Limit",
        "path": "bank-parameters/RULE-WITHDRAWAL.cbl",
        "description": (
            "BR-LIM-001 - The number of monthly withdrawals must not exceed the limit "
            "defined for the customer segment. The PREMIUM segment has no withdrawal limit."
        ),
    },
    {
        "title": "RULE-ACCOUNT-CTRL - Account Control",
        "rule_id": "BR-ACC-001",
        "filename": "RULE-ACCOUNT-CTRL.cbl",
        "type": "Account",
        "path": "bank-parameters/RULE-ACCOUNT-CTRL.cbl",
        "description": (
            "BR-ACC-001 - Controls the eligibility of an account before any financial "
            "operation is applied."
        ),
    },
    {
        "title": "RULE-SEG-RANGE - Segment Range Control",
        "rule_id": "BR-SEG-001",
        "filename": "RULE-SEG-RANGE.cbl",
        "type": "Segment",
        "path": "bank-parameters/RULE-SEG-RANGE.cbl",
        "description": (
            "BR-SEG-001 - Validates that a value stays within the range authorised for "
            "the customer segment."
        ),
    },
    {
        "title": "RULE-FORMAT - Format Control",
        "rule_id": "BR-FMT-001",
        "filename": "RULE-FORMAT.cbl",
        "type": "Format",
        "path": "bank-parameters/RULE-FORMAT.cbl",
        "description": (
            "BR-FMT-001 - Validates the structural format of input fields before any "
            "business control is applied."
        ),
    },
]


# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

def get_source_status(source_path: str) -> tuple[Path, bool, str, str]:
    """
    Return the implementation status of a COBOL source artifact.

    Works for any source artifact: program, copybook or business rule module.

    Parameters
    ----------
    source_path : str
        Relative path to the COBOL source file.

    Returns
    -------
    tuple[Path, bool, str, str]
        - file_path    : Path object pointing to the source file.
        - exists       : True if the file exists, False otherwise.
        - status       : Display status used in the UI.
        - status_class : CSS class used to style the status badge.
    """

    file_path = Path(source_path)
    exists = file_path.exists()

    status = "Created" if exists else "In Progress"
    status_class = "badge-created" if exists else "badge-progress"

    return file_path, exists, status, status_class


def render_source_card(
    item: dict,
    type_badge_class: str,
    code_language: str = "cobol",
) -> None:
    """
    Render a source documentation card.

    The card displays:
    - Title
    - Source path
    - Business description
    - Source file name
    - Type badge
    - Implementation status

    If the source file exists, a source code expander is displayed.
    If the file does not exist, no expander is displayed. This avoids
    showing placeholder or fake code for artifacts still in progress.

    Parameters
    ----------
    item : dict
        Dictionary containing title, filename, type, path and description.
    type_badge_class : str
        CSS class applied to the type badge.
    code_language : str
        Language used for syntax highlighting in the expander.

    Returns
    -------
    None
    """

    file_path, exists, status, status_class = get_source_status(item["path"])

    # Same constraint as render_kpi_grid: no leading whitespace in the HTML.
    card_html = (
        f'<div class="program-card">'
        f'<div class="program-title">{item["title"]}</div>'
        f'<div class="program-path">{item["path"]}</div>'
        f'<div class="program-description">{item["description"]}</div>'
        f"<div>"
        f'<span class="badge badge-file">{item["filename"]}</span>'
        f'<span class="badge {type_badge_class}">{item["type"]}</span>'
        f'<span class="badge {status_class}">{status}</span>'
        f"</div>"
        f"</div>"
    )

    st.markdown(card_html, unsafe_allow_html=True)

    if exists:
        with st.expander(f"Show Source Code - {item['filename']}", expanded=False):
            code = file_path.read_text(encoding="utf-8")
            st.code(code, language=code_language)


def render_kpi_grid(cells: list[tuple[str, int]]) -> None:
    """
    Render a KPI grid from a list of label/value pairs.

    Parameters
    ----------
    cells : list[tuple[str, int]]
        List of (label, value) pairs displayed as KPI cells.

    Returns
    -------
    None
    """

    # The generated HTML must not contain leading whitespace on any line.
    # Streamlit renders markdown, and any line indented by 4 spaces or more
    # is interpreted as a code block instead of raw HTML.
    cells_html = "".join(
        f'<div class="kpi-cell">'
        f'<div class="kpi-label">{label}</div>'
        f'<div class="kpi-value">{value}</div>'
        f"</div>"
        for label, value in cells
    )

    st.markdown(
        f'<div class="kpi-grid">{cells_html}</div>',
        unsafe_allow_html=True,
    )


def count_status(items: list[dict]) -> tuple[int, int]:
    """
    Count created and in-progress source artifacts.

    Parameters
    ----------
    items : list[dict]
        List of artifact metadata dictionaries.

    Returns
    -------
    tuple[int, int]
        - created_count  : Number of artifacts whose source file exists.
        - progress_count : Number of artifacts still in progress.
    """

    created_count = sum(1 for item in items if Path(item["path"]).exists())
    progress_count = len(items) - created_count

    return created_count, progress_count


def count_by_type(items: list[dict], type_value: str) -> int:
    """
    Count artifacts matching a given type value.

    Parameters
    ----------
    items : list[dict]
        List of artifact metadata dictionaries.
    type_value : str
        Type value to match.

    Returns
    -------
    int
        Number of artifacts of the requested type.
    """

    return sum(1 for item in items if item["type"] == type_value)


def render_section_title(label: str) -> None:
    """
    Render a section title separator.

    Parameters
    ----------
    label : str
        Section label displayed in uppercase.

    Returns
    -------
    None
    """

    st.markdown(
        f'<div class="section-title">{label}</div>',
        unsafe_allow_html=True,
    )


# =============================================================================
# HERO SECTION
# Main page banner presenting the purpose of the source catalog.
# =============================================================================

st.markdown(
    """
    <div class="hero-box">
        <div style="font-size:1.7rem; font-weight:800; letter-spacing:-0.03em;">
            COBOL Source Catalog
        </div>
        <div style="font-size:0.9rem; opacity:0.75; margin-top:0.25rem;">
            Core Banking System - Source Code Documentation
        </div>
        <p style="font-size:0.95rem; opacity:0.9; line-height:1.7; margin-top:1rem; margin-bottom:1rem;">
            This page presents the COBOL artifacts created for the banking simulation project:
            programs organized under src/BATCH and src/CICS, copybooks shared across modules,
            and business rules implemented as external subprograms. Each entry includes its
            functional role, implementation status and source code preview.
        </p>
        <div>
            <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">COBOL</span>
            <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">Batch Programs</span>
            <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">CICS Programs</span>
            <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">VSAM KSDS</span>
            <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">Copybooks</span>
            <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">Business Rules</span>
        </div>
    </div>
    """,
    unsafe_allow_html=True,
)


# =============================================================================
# TAB LAYOUT
# One tab per artifact family: Programs, Copybooks, Business Rules.
# Each tab reuses the same KPI grid + card catalog layout.
# =============================================================================

tab_programs, tab_copybooks, tab_rules = st.tabs(
    ["Programs", "Copybooks", "Business Rules"]
)


# -----------------------------------------------------------------------------
# TAB 1 - PROGRAMS
# -----------------------------------------------------------------------------

with tab_programs:

    # Professional warning about the current CICS simulation constraint.
    st.markdown(
        """
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
        """,
        unsafe_allow_html=True,
    )

    created_count, progress_count = count_status(PROGRAMS)
    batch_count = count_by_type(PROGRAMS, "Batch")
    cics_count = count_by_type(PROGRAMS, "CICS")

    render_kpi_grid(
        [
            ("Programs", len(PROGRAMS)),
            ("Batch", batch_count),
            ("CICS", cics_count),
            ("Created", created_count),
            ("In Progress", progress_count),
        ]
    )

    render_section_title("Program Catalog")

    for program in PROGRAMS:
        type_badge_class = (
            "badge-cics" if program["type"] == "CICS" else "badge-type"
        )
        render_source_card(program, type_badge_class)


# -----------------------------------------------------------------------------
# TAB 2 - COPYBOOKS
# -----------------------------------------------------------------------------

with tab_copybooks:

    created_count, progress_count = count_status(COPYBOOKS)
    record_count = count_by_type(COPYBOOKS, "RECORD")
    select_count = count_by_type(COPYBOOKS, "SELECT")
    status_count = count_by_type(COPYBOOKS, "STATUS")

    render_kpi_grid(
        [
            ("Copybooks", len(COPYBOOKS)),
            ("Record", record_count),
            ("Select", select_count),
            ("Status", status_count),
            ("Created", created_count),
            ("In Progress", progress_count),
        ]
    )

    render_section_title("Copybook Catalog")

    for copybook in COPYBOOKS:
        render_source_card(copybook, "badge-copybook")


# -----------------------------------------------------------------------------
# TAB 3 - BUSINESS RULES
# -----------------------------------------------------------------------------

with tab_rules:

    created_count, progress_count = count_status(BUSINESS_RULES)
    rule_families = len({rule["type"] for rule in BUSINESS_RULES})

    render_kpi_grid(
        [
            ("Business Rules", len(BUSINESS_RULES)),
            ("Families", rule_families),
            ("Created", created_count),
            ("In Progress", progress_count),
        ]
    )

    render_section_title("Business Rule Catalog")

    for rule in BUSINESS_RULES:
        render_source_card(rule, "badge-rule")