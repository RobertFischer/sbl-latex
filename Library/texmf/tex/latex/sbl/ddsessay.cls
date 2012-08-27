%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ddsessay}[2010/05/04
Class for Duke Divinity School papers]

\DeclareOption*{ \PassOptionsToClass{\CurrentOption}{sblessay} }
\ProcessOptions\relax
\LoadClass[notimes,letterpaper,firstrefwithpage]{sblessay}


\let\oldtoc\tableofcontents
\renewcommand\tableofcontents{%
  \oldtoc%
  \firstpage%
  \addtocounter{page}{-1}%
  \pagebreak%
}

\RequirePackage{xspace}
\RequirePackage{hyphenat}
\RequirePackage{scalefnt}
\RequirePackage{verbatim}

% Fix spacing for lists
\RequirePackage{mdwlist}
\let\olditemize\itemize
\renewcommand\itemize{\par\singlespacing\small\olditemize}


\newcommand\makebib {
  \bibliography{sbl}{}
}

\let\oldfootnote\footnote
\renewcommand{\footnote}[1] {%
  \oldfootnote{#1}\xspace%
}

\let\oldfootnotemark\footnotemark
\renewcommand{\footnotemark} {%
  \oldfootnotemark\xspace%
}



\institution{Duke~Divinity~School}

\geometry{letterpaper,margin=1in,verbose=true}
