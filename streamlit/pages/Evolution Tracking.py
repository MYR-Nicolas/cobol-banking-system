import streamlit as st

# =============================================================================
# STREAMLIT PAGE CONFIGURATION
# =============================================================================

st.set_page_config(
    page_title="Evolution Tracking - COBOL Core Banking System",
    layout="wide",
)


# =============================================================================
# GLOBAL STYLING
# Same visual identity as the main specification page, plus timeline styles.
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
    max-width: 1100px;
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

.hero-box {
    background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 55%, #2563eb 100%);
    color: white;
    border-radius: 24px;
    padding: 1.6rem 1.6rem 1.4rem 1.6rem;
    box-shadow: 0 18px 45px rgba(30,58,138,0.22);
    margin-bottom: 1.6rem;
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

/* =========================================================================
   TIMELINE
   ========================================================================= */

.timeline {
position: relative;
margin: 0.5rem 0 2rem 0;
padding-left: 2.6rem;
}

.timeline::before {
content: "";
position: absolute;
left: 1.05rem;
top: 0.4rem;
bottom: 0.4rem;
width: 2px;
background: linear-gradient(180deg, #2563eb 0%, #c7d2fe 60%, #e2e8f0 100%);
}

.timeline-item {
position: relative;
margin-bottom: 1.6rem;
}

.timeline-dot {
position: absolute;
left: -2.6rem;
top: 1.1rem;
width: 1.15rem;
height: 1.15rem;
border-radius: 50%;
border: 3px solid white;
box-shadow: 0 0 0 2px rgba(226,232,240,0.9);
z-index: 2;
}

.dot-done { background:#059669; }
.dot-progress { background:#f59e0b; }
.dot-todo { background:#94a3b8; }

.timeline-card {
background: rgba(255,255,255,0.92);
border: 1px solid rgba(226,232,240,0.95);
border-radius: 18px;
padding: 1.1rem 1.3rem;
box-shadow: 0 8px 24px rgba(15,23,42,0.05);
}

.timeline-card.is-progress {
border-color: #fde68a;
background: linear-gradient(135deg, rgba(255,255,255,0.96), rgba(255,251,235,0.7));
}

.timeline-card.is-done {
border-color: #a7f3d0;
}

.timeline-header {
display: flex;
align-items: center;
gap: 0.7rem;
margin-bottom: 0.5rem;
flex-wrap: wrap;
}

.timeline-index {
font-family:'JetBrains Mono',monospace;
font-size:0.72rem;
font-weight:700;
color:#94a3b8;
background:#f1f5f9;
border-radius:6px;
padding:0.15rem 0.5rem;
}

.timeline-title {
font-size: 1.05rem;
font-weight: 700;
color: #0f172a;
}

.status-pill {
margin-left: auto;
display:inline-block;
padding: 0.25rem 0.7rem;
border-radius: 999px;
font-size: 0.7rem;
font-weight: 700;
letter-spacing: 0.05em;
text-transform: uppercase;
}

.status-done {
background:#ecfdf5;
color:#065f46;
border:1px solid #a7f3d0;
}

.status-progress {
background:#fffbeb;
color:#92400e;
border:1px solid #fde68a;
}

.status-todo {
background:#f8fafc;
color:#64748b;
border:1px solid #e2e8f0;
}

.timeline-desc {
font-size: 0.88rem;
color: #475569;
line-height: 1.65;
margin-bottom: 0.7rem;
}

.timeline-meta {
display:flex;
flex-wrap:wrap;
gap:0.4rem;
margin-top:0.4rem;
}

.meta-tag {
font-size:0.7rem;
font-weight:600;
padding:0.2rem 0.55rem;
border-radius:6px;
background:#eff6ff;
color:#1d4ed8;
border:1px solid #bfdbfe;
}

.empty-note {
font-size: 0.82rem;
color: #94a3b8;
font-style: italic;
}
</style>
"""

st.markdown(GLOBAL_CSS, unsafe_allow_html=True)


# =============================================================================
# HERO SECTION
# =============================================================================

st.markdown("""
<div class="hero-box">
  <div style="font-size:1.6rem; font-weight:800; letter-spacing:-0.03em; line-height:1.1;">
    Evolution Tracking
  </div>
  <div style="font-size:0.85rem; opacity:0.75; margin-top:0.3rem; font-weight:400;">
    COBOL Core Banking System - Migration and Upgrade Log
  </div>
  <p style="font-size:0.95rem; opacity:0.9; line-height:1.65; margin:1rem 0 1rem 0;">
    This page lists, in chronological order, the major technical evolutions
    of the project: file migrations, business rule implementation, program
    integration, CICS-oriented design, DB2 preparation, and future changes
    to the mainframe-style architecture.
  </p>
</div>
""", unsafe_allow_html=True)


# =============================================================================
# EVOLUTIONS DATA
# Add a new entry at the END of this list each time a new evolution starts.
# status: "done" | "progress" | "todo"
# progress: 0-100 (only meaningful for "progress" status)
# =============================================================================

evolutions = [
    {
        "title": "Migration of sequential files to VSAM KSDS",
        "status": "done",
        "desc": (
            "Replace the sequential files (accounts.dat, customers.dat, "
            "transactions.dat) with VSAM KSDS datasets to enable direct "
            "key-based access using account numbers, customer IDs and "
            "transaction identifiers. This evolution brings the project "
            "closer to a realistic mainframe data architecture."
        ),
        "tags": ["VSAM", "KSDS", "Files", "Direct access"],
    },
    {
        "title": "Business rule creation and integration into COBOL programs",
        "status": "progress",
        "desc": (
            "Define, structure and integrate banking business rules directly "
            "into the COBOL application flow. The current scope covers "
            "LSTACC, CNSACC and DEPOSIT, with validation logic progressively "
            "added to improve account listing, account consultation and deposit "
            "processing. These rules are designed to strengthen data consistency, "
            "functional control and maintainability across the banking system."
        ),
        "tags": ["Business Rules", "LSTACC", "CNSACC", "DEPOSIT", "Validation"],
    },
]


# =============================================================================
# TIMELINE SECTION
# Each item is rendered with no leading indentation in the generated HTML,
# to avoid Streamlit/Markdown interpreting indented lines as a code block.
# =============================================================================

st.markdown('<div class="sec-label">Evolution Timeline</div>', unsafe_allow_html=True)

status_dot = {"done": "dot-done", "progress": "dot-progress", "todo": "dot-todo"}
status_card = {"done": "is-done", "progress": "is-progress", "todo": ""}
status_pill_class = {"done": "status-done", "progress": "status-progress", "todo": "status-todo"}
status_label = {"done": "Done", "progress": "In progress", "todo": "Upcoming"}

items_html = []

for i, evo in enumerate(evolutions, start=1):
    tags_html = "".join(f'<span class="meta-tag">{t}</span>' for t in evo["tags"])

    item_html = (
        f'<div class="timeline-item">'
        f'<div class="timeline-dot {status_dot[evo["status"]]}"></div>'
        f'<div class="timeline-card {status_card[evo["status"]]}">'
        f'<div class="timeline-header">'
        f'<span class="timeline-index">#{i:02d}</span>'
        f'<span class="timeline-title">{evo["title"]}</span>'
        f'<span class="status-pill {status_pill_class[evo["status"]]}">{status_label[evo["status"]]}</span>'
        f'</div>'
        f'<div class="timeline-desc">{evo["desc"]}</div>'
        f'<div class="timeline-meta">{tags_html}</div>'
        f'</div>'
        f'</div>'
    )

    items_html.append(item_html)

timeline_html = '<div class="timeline">' + "".join(items_html) + '</div>'

st.markdown(timeline_html, unsafe_allow_html=True)

st.markdown(
    '<div class="empty-note">Future evolutions such as extended business rules, '
    'native CICS execution, DB2 integration, RACF security, ISPF usage and advanced '
    'JCL batch orchestration will appear here as they get started.</div>',
    unsafe_allow_html=True,
)