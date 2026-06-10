# =============================================================================
# IMPORTS
# =============================================================================

from pathlib import Path

import streamlit as st


# =============================================================================
# STREAMLIT PAGE CONFIGURATION
# =============================================================================

st.set_page_config(
    page_title="COBOL Programs",
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
</style>
"""

st.markdown(GLOBAL_CSS, unsafe_allow_html=True)


# =============================================================================
# PROGRAM DEFINITIONS
# Catalog of COBOL programs included in the project.
# Each program is displayed with its title, file name, type, source path,
# business description and implementation status.
# =============================================================================

PROGRAMS = [
    {
        "title": "LSTCPT - List Accounts",
        "filename": "LSTCPT.cbl",
        "type": "Batch",
        "path": "src/LSTCPT.cbl",
        "description": "Reads the account file and displays all bank accounts stored in the system.",
    },
    {
        "title": "CNSCPT - Consult Account",
        "filename": "CNSCPT.cbl",
        "type": "Batch",
        "path": "src/CNSCPT.cbl",
        "description": "Searches one bank account by account number and displays detailed account information.",
    },
    {
        "title": "DEPOT - Deposit",
        "filename": "DEPOT.cbl",
        "type": "Batch",
        "path": "src/DEPOT.cbl",
        "description": "Credits an existing bank account and records the deposit transaction.",
    },
    {
        "title": "RETRAIT - Withdrawal",
        "filename": "RETRAIT.cbl",
        "type": "Batch",
        "path": "src/RETRAIT.cbl",
        "description": "Debits an account after checking that the balance is sufficient.",
    },
    {
        "title": "VIREMENT - Transfer",
        "filename": "VIREMENT.cbl",
        "type": "Batch",
        "path": "src/VIREMENT.cbl",
        "description": "Transfers an amount from a source account to a target account.",
    },
    {
        "title": "RAPJOUR - Daily Report",
        "filename": "RAPJOUR.cbl",
        "type": "Batch",
        "path": "src/RAPJOUR.cbl",
        "description": "Reads the transaction file and generates a daily banking activity report.",
    },
    {
        "title": "INITBANQ - Initialize Banking Files",
        "filename": "INITBANQ.cbl",
        "type": "Batch",
        "path": "src/INITBANQ.cbl",
        "description": "Initializes or prepares the banking files used by the COBOL core banking simulation.",
    },
]


# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

def get_program_status(program_path: str) -> tuple[Path, bool, str, str]:
    """
    Return the implementation status of a COBOL program.

    Parameters
    ----------
    program_path : str
        Relative path to the COBOL source file.

    Returns
    -------
    tuple[Path, bool, str, str]
        - file_path    : Path object pointing to the COBOL source file.
        - exists       : True if the file exists, False otherwise.
        - status       : Display status used in the UI.
        - status_class : CSS class used to style the status badge.
    """

    file_path = Path(program_path)
    exists = file_path.exists()

    status = "Created" if exists else "In Progress"
    status_class = "badge-created" if exists else "badge-progress"

    return file_path, exists, status, status_class


def render_program_card(program: dict) -> None:
    """
    Render a program documentation card.

    The card displays:
    - Program title
    - Business description
    - COBOL file name
    - Program type
    - Implementation status

    If the COBOL file exists, a source code expander is displayed.
    If the file does not exist, no expander is displayed.

    Parameters
    ----------
    program : dict
        Dictionary containing title, filename, type, path and description.

    Returns
    -------
    None
    """

    file_path, exists, status, status_class = get_program_status(program["path"])

    # Render the visual documentation card.
    # HTML is rendered through st.markdown with unsafe_allow_html=True.
    st.markdown(
        f"""
        <div class="program-card">
            <div class="program-title">{program["title"]}</div>
            <div class="program-description">{program["description"]}</div>
            <div>
                <span class="badge badge-file">{program["filename"]}</span>
                <span class="badge badge-type">{program["type"]}</span>
                <span class="badge {status_class}">{status}</span>
            </div>
        </div>
        """,
        unsafe_allow_html=True,
    )

    # Display the COBOL source code only when the source file exists.
    # This avoids showing placeholder or fake code for programs still in progress.
    if exists:
        with st.expander(f"Show Source Code - {program['filename']}", expanded=False):
            code = file_path.read_text(encoding="utf-8")
            st.code(code, language="cobol")


def count_programs(programs: list[dict]) -> tuple[int, int]:
    """
    Count created and in-progress COBOL programs.

    Parameters
    ----------
    programs : list[dict]
        List of program metadata dictionaries.

    Returns
    -------
    tuple[int, int]
        - created_count  : Number of programs whose source file exists.
        - progress_count : Number of programs still in progress.
    """

    created_count = sum(1 for program in programs if Path(program["path"]).exists())
    progress_count = len(programs) - created_count

    return created_count, progress_count


# =============================================================================
# HERO SECTION
# Main page banner presenting the purpose of the COBOL programs catalog.
# =============================================================================

st.markdown(
    """
    <div class="hero-box">
        <div style="font-size:1.7rem; font-weight:800; letter-spacing:-0.03em;">
            COBOL Programs
        </div>
        <div style="font-size:0.9rem; opacity:0.75; margin-top:0.25rem;">
            Core Banking System - Source Code Documentation
        </div>
        <p style="font-size:0.95rem; opacity:0.9; line-height:1.7; margin-top:1rem; margin-bottom:1rem;">
            This page presents the COBOL batch programs created for the banking simulation project.
            Each program includes its functional role, implementation status and source code preview.
        </p>
        <div>
            <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">COBOL</span>
            <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">Batch Programs</span>
            <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">Sequential Files</span>
            <span class="badge" style="background:rgba(255,255,255,0.12); color:white; border-color:rgba(255,255,255,0.3);">Copybooks</span>
        </div>
    </div>
    """,
    unsafe_allow_html=True,
)


# =============================================================================
# KPI SECTION
# Displays project statistics based on existing COBOL source files.
# =============================================================================

created_count, progress_count = count_programs(PROGRAMS)

st.markdown(
    f"""
    <div class="kpi-grid">
        <div class="kpi-cell">
            <div class="kpi-label">Programs</div>
            <div class="kpi-value">{len(PROGRAMS)}</div>
        </div>
        <div class="kpi-cell">
            <div class="kpi-label">Created</div>
            <div class="kpi-value">{created_count}</div>
        </div>
        <div class="kpi-cell">
            <div class="kpi-label">In Progress</div>
            <div class="kpi-value">{progress_count}</div>
        </div>
        <div class="kpi-cell">
            <div class="kpi-label">Execution</div>
            <div class="kpi-value" style="font-size:1.5rem;">Batch</div>
        </div>
    </div>
    """,
    unsafe_allow_html=True,
)


# =============================================================================
# PROGRAM CATALOG
# Displays all COBOL programs with their current implementation status.
# =============================================================================

st.markdown(
    '<div class="section-title">Program Catalog</div>',
    unsafe_allow_html=True,
)


# =============================================================================
# RENDER PROGRAMS
# =============================================================================

for program in PROGRAMS:
    render_program_card(program)