\documentclass[11pt,letterpaper]{article}

<%text>% Packages</%text>
\usepackage[utf8]{inputenc}
\usepackage[margin=0.75in]{geometry}
\usepackage{titlesec}
\usepackage{enumitem}
\usepackage{hyperref}
\usepackage{xcolor}
\usepackage{fontawesome5}
\usepackage[T1]{fontenc}

<%text>% Colors</%text>
\definecolor{headercolor}{RGB}{0, 102, 204}
\definecolor{sectioncolor}{RGB}{51, 51, 51}

<%text>% Hyperlink setup</%text>
\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    urlcolor=headercolor,
    pdftitle={${personal['name']} - Resume},
    pdfauthor={${personal['name']}}
}

<%text>% Custom commands</%text>
\newcommand{\resumeheader}[3]{
    \begin{center}
        {\huge \textbf{\textcolor{headercolor}{#1}}} \\[8pt]
        {\large #2} \\[6pt]
        {#3}
    \end{center}
    \vspace{15pt}
}

\newcommand{\resumesection}[1]{
    \vspace{10pt}
    {\Large \textbf{\textcolor{sectioncolor}{#1}}}
    \vspace{3pt}
    \hrule
    \vspace{6pt}
}

\newcommand{\resumesubheading}[4]{
    \noindent\textbf{#1} \hfill \textbf{#2} \\
    \if\relax\detokenize{#3}\relax
    \else
        \noindent\textit{#3} \hfill \textit{#4} \\
    \fi
    \vspace{3pt}
}

\newcommand{\resumeitem}[1]{\item #1}
\newcommand{\resumeitemlist}{\begin{itemize}[leftmargin=0.2in, rightmargin=0.1in]\setlength{\itemsep}{2pt}\setlength{\parskip}{0pt}}
\newcommand{\resumeitemlistend}{\end{itemize}\vspace{4pt}}

\newcommand{\resumeprojectitem}[4]{
    \noindent\textbf{#1} \hfill \makebox[2.0in][r]{\textbf{#2}}
    
    \noindent #3
    
    \noindent \textit{Technologies: #4}
    \vspace{8pt}
}

<%text>% Remove page numbers</%text>
\pagestyle{empty}

<%text>% Reduce section spacing</%text>
\titlespacing{\section}{0pt}{6pt}{6pt}
\titlespacing{\subsection}{0pt}{4pt}{4pt}

\begin{document}

<%text>% Header</%text>
\resumeheader
{${personal['name']}}
{${latex_escape(personal['description'])}}
{<%
social_links_str = []
for social_link in contact['social_links']:
    social_links_str.append('\\href{' + social_link['url'] + '}{' + social_link['name'] + '}')
%>${' $\\cdot$ '.join(social_links_str)}}

<%text>% Professional Summary</%text>
\resumesection{Professional Summary}
\begin{quote}
${latex_escape(personal['about_me'])}
\end{quote}

<%text>% Technical Skills</%text>
\resumesection{Technical Skills}
\begin{itemize}[leftmargin=0.2in, rightmargin=0.1in]
% for category in skills['categories']:
\item \textbf{${latex_escape(category['name'])}:} <%
skill_names = []
for skill in category['items']:
    skill_names.append(latex_escape(skill['name']))
%>${', '.join(skill_names)}
% endfor
\end{itemize}

<%text>% Professional Experience</%text>
\resumesection{Professional Experience}
% for job in experience['jobs']:
<%
# Split job title and company
if ' @ ' in job['title']:
    job_title = job['title'].split(' @ ')[0]
    company_name = job['title'].split(' @ ')[1]
else:
    job_title = job['title']
    company_name = ""
%>
\resumesubheading
{${latex_escape(job_title)}}
{${format_date_for_alignment(job['period'])}}
{${latex_escape(company_name)}}
{}

\resumeitemlist
% for responsibility in job['responsibilities']:
\resumeitem{${latex_escape(responsibility)}}
% endfor
\resumeitemlistend
\vspace{4pt}

% endfor

<%!
def latex_escape(text):
    """Escape special LaTeX characters"""
    if not text:
        return ""
    
    # Dictionary of characters to escape
    escape_chars = {
        '&': r'\&',
        '%': r'\%',
        '$': r'\$',
        '#': r'\#',
        '^': r'\textasciicircum{}',
        '_': r'\_',
        '{': r'\{',
        '}': r'\}',
        '~': r'\textasciitilde{}',
        '\\': r'\textbackslash{}',
    }
    
    # Replace each character
    for char, replacement in escape_chars.items():
        text = text.replace(char, replacement)
    
    return text

def format_date_for_alignment(date_str):
    """Format date string for consistent alignment"""
    if not date_str:
        return ""
    
    # Escape LaTeX characters first
    escaped = latex_escape(date_str)
    
    # Ensure consistent width by using a fixed-width font for dates
    # This helps with alignment in the resume
    return "\\texttt{" + escaped + "}"
%>

<%text>% Key Projects</%text>
\resumesection{Key Projects}
% for company in projects['companies']:
% for project in company['projects']:
<%
# Process description
description_text = ""
if '\n' in project['description']:
    paragraphs = []
    for paragraph in project['description'].split('\n'):
        if paragraph.strip():
            paragraphs.append(latex_escape(paragraph.strip()))
    description_text = ' '.join(paragraphs)
else:
    description_text = latex_escape(project['description'])

# Process technologies
tech_names = []
for tech in project['technologies']:
    tech_names.append(latex_escape(tech['name']))
tech_string = ', '.join(tech_names)
%>
\resumeprojectitem{${latex_escape(project['title'])}}{${format_date_for_alignment(project['period'])}}{${description_text}}{${tech_string}}
% endfor
% endfor

\end{document}
